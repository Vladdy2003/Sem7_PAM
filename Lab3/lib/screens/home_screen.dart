import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/home/home_cubit.dart';
import '../models/appointment_details.dart';
import '../models/doctor.dart';
import '../models/home_data.dart';
import '../theme/app_colors.dart';
import '../widgets/appointment_card.dart';
import '../widgets/avatar_image.dart';
import '../widgets/doctor_tile.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/health_service_item.dart';
import '../widgets/search_field.dart';
import '../widgets/section_header.dart';
import '../widgets/sort_filter_sheet.dart';
import '../widgets/state_views.dart';
import 'appointment_screen.dart';

// Legatura dintre un serviciu medical si specialitatea doctorilor
const Map<String, String> _serviceToSpecialty = {
  'tooth': 'Dental Specialist',
  'eye': 'Eye Specialist',
  'lungs': 'Lungs Specialist',
  'ear': 'Ear Specialist',
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAppointment(AppointmentDetails details, {Doctor? doctor}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentScreen(details: details, doctorId: doctor?.id),
      ),
    );
  }

  void _openDoctor(HomeReady state, Doctor doctor) {
    final template = state.data.appointmentDetails;
    final details = template.forDoctor(template.doctor.copyWith(
      name: doctor.name,
      clinic: doctor.specialty,
      avatarUrl: doctor.avatarUrl,
    ));
    _openAppointment(details, doctor: doctor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          // tinem textul din bara de cautare sincronizat cu starea
          listenWhen: (prev, curr) =>
              curr is HomeReady && curr.query != _searchController.text.trim(),
          listener: (context, state) {
            if (state is HomeReady) _searchController.text = state.query;
          },
          builder: (context, state) {
            return switch (state) {
              HomeInitial() || HomeLoading() =>
                const LoadingView(message: 'Loading your health data...'),
              HomeError(:final message) => ErrorView(
                  message: message,
                  onRetry: () => context.read<HomeCubit>().loadData(),
                ),
              HomeReady() => _buildContent(context, state),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeReady state) {
    final cubit = context.read<HomeCubit>();
    final home = state.data.home;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: cubit.loadData,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        children: [
          _Header(user: home.user, hasUnread: home.hasUnreadNotifications),
          const SizedBox(height: 22),
          SearchField(
            controller: _searchController,
            hint: home.searchHint,
            onChanged: cubit.search,
            filtersActive: state.favoritesOnly || state.sort != DoctorSort.none,
            onFilterTap: () => showSortFilterSheet(context),
          ),
          const SizedBox(height: 22),
          AppointmentCard(
            appointment: home.appointment,
            onTap: () => _openAppointment(state.data.appointmentDetails),
          ),
          const SizedBox(height: 26),
          const SectionHeader(title: 'Health Services'),
          const SizedBox(height: 14),
          _buildHealthServices(home.healthServices, state, cubit),
          const SizedBox(height: 26),
          SectionHeader(
            title: 'Nearby Doctor',
            actionLabel: state.hasActiveFilters ? 'Clear filters' : null,
            onAction: cubit.clearFilters,
          ),
          const SizedBox(height: 12),
          FilterChipsBar(
            options: state.specialties,
            selected: state.specialty,
            onSelected: cubit.selectSpecialty,
          ),
          const SizedBox(height: 8),
          ..._buildDoctorList(state, cubit),
        ],
      ),
    );
  }

  Widget _buildHealthServices(
      List<HealthService> services, HomeReady state, HomeCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final service in services)
          Builder(builder: (_) {
            final specialty = _serviceToSpecialty[service.id];
            final selected = specialty != null && state.specialty == specialty;
            return HealthServiceItem(
              service: service,
              selected: selected,
              onTap: specialty == null
                  ? null
                  : () => cubit.selectSpecialty(selected ? null : specialty),
            );
          }),
      ],
    );
  }

  List<Widget> _buildDoctorList(HomeReady state, HomeCubit cubit) {
    return switch (state) {
      HomeEmpty() => [
          EmptyView(
            message: state.hasActiveFilters
                ? 'Try another search or remove some filters.'
                : 'There are no doctors near you yet.',
            actionLabel: state.hasActiveFilters ? 'Clear filters' : null,
            onAction: cubit.clearFilters,
          ),
        ],
      HomeSuccess() => [
          for (final doctor in state.visibleDoctors)
            DoctorTile(
              key: ValueKey(doctor.id),
              doctor: doctor,
              onTap: () => _openDoctor(state, doctor),
              onFavoriteTap: () => cubit.toggleFavorite(doctor.id),
            ),
        ],
    };
  }
}

// Avatar + salut + clopotel notificari
class _Header extends StatelessWidget {
  final UserProfile user;
  final bool hasUnread;

  const _Header({required this.user, required this.hasUnread});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarImage(url: user.avatarUrl, width: 40, height: 40, radius: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.greeting,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user.subtitle,
                style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        Badge(
          isLabelVisible: hasUnread,
          smallSize: 7,
          backgroundColor: Colors.red,
          child: const Icon(Icons.notifications_none,
              size: 24, color: AppColors.textDark),
        ),
      ],
    );
  }
}
