import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/appointment/appointment_cubit.dart';
import '../cubits/home/home_cubit.dart';
import '../models/appointment_details.dart';
import '../theme/app_colors.dart';
import '../widgets/avatar_image.dart';
import '../widgets/contact_button.dart';
import '../widgets/favorite_button.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';
import '../widgets/slot_selector.dart';

// Pagina de detalii / programare. Primeste datele deja incarcate din JSON.
// doctorId != null => doctorul provine din lista "Nearby" si poate fi
// adaugat/eliminat din favorite (starea este partajata cu HomeCubit).
class AppointmentScreen extends StatelessWidget {
  final AppointmentDetails details;
  final String? doctorId;

  const AppointmentScreen({super.key, required this.details, this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentCubit(details),
      child: _AppointmentView(details: details, doctorId: doctorId),
    );
  }
}

class _AppointmentView extends StatelessWidget {
  final AppointmentDetails details;
  final String? doctorId;

  const _AppointmentView({required this.details, this.doctorId});

  static const TextStyle _sectionStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  void _showMessage(BuildContext context, String text, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
        backgroundColor: error ? Colors.redAccent : AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentCubit, AppointmentState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == BookingStatus.success) {
          _showMessage(context, state.message ?? 'Appointment booked!');
        } else if (state.status == BookingStatus.failure) {
          _showMessage(context, state.message ?? 'Booking failed', error: true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildDoctorInfo(context),
                    ),
                    const SizedBox(height: 34),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(details.detailsTitle, style: _sectionStyle),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        details.description,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _slotHeader(details.workingHours),
                    const SizedBox(height: 16),
                    BlocBuilder<AppointmentCubit, AppointmentState>(
                      buildWhen: (p, c) => p.selectedHourId != c.selectedHourId,
                      builder: (context, state) => SlotSelector(
                        slots: details.workingHours.slots,
                        selectedId: state.selectedHourId,
                        onSelected: context.read<AppointmentCubit>().selectHour,
                      ),
                    ),
                    const SizedBox(height: 26),
                    _slotHeader(details.dates),
                    const SizedBox(height: 16),
                    BlocBuilder<AppointmentCubit, AppointmentState>(
                      buildWhen: (p, c) => p.selectedDateId != c.selectedDateId,
                      builder: (context, state) => SlotSelector(
                        slots: details.dates.slots,
                        selectedId: state.selectedDateId,
                        onSelected: context.read<AppointmentCubit>().selectDate,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: BlocBuilder<AppointmentCubit, AppointmentState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) => PrimaryButton(
                    label: state.status == BookingStatus.success
                        ? 'Booked ✓'
                        : details.bookLabel,
                    isLoading: state.status == BookingStatus.booking,
                    onPressed: details.bookEnabled
                        ? context.read<AppointmentCubit>().book
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slotHeader(SlotGroup group) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SectionHeader(
        title: group.title,
        fontSize: 20,
        actionLabel: group.showAll ? 'See All' : null,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 22),
              color: AppColors.textDark,
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          Text(
            details.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          if (doctorId != null)
            Align(
              alignment: Alignment.centerRight,
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, _) {
                  final cubit = context.read<HomeCubit>();
                  final doctor = cubit.doctorById(doctorId!);
                  if (doctor == null) return const SizedBox.shrink();
                  return FavoriteButton(
                    size: 26,
                    isFavorite: doctor.isFavorite,
                    onPressed: () => cubit.toggleFavorite(doctor.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Poza doctorului, nume, clinica, butoane de contact si pret
  Widget _buildDoctorInfo(BuildContext context) {
    final doctor = details.doctor;
    final avatar = AvatarImage(
      url: doctor.avatarUrl,
      width: 118,
      height: 118,
      radius: 8,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        doctorId != null
            ? Hero(tag: 'doctor-avatar-$doctorId', child: avatar)
            : avatar,
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 118,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doctor.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    if (doctor.canMessage)
                      ContactButton(
                        icon: Icons.chat_bubble_outline,
                        tooltip: 'Message',
                        onTap: () => _showMessage(
                            context, 'Opening chat with ${doctor.name}...'),
                      ),
                    if (doctor.canCall) ...[
                      const SizedBox(width: 10),
                      ContactButton(
                        icon: Icons.call_outlined,
                        tooltip: 'Call',
                        onTap: () =>
                            _showMessage(context, 'Calling ${doctor.name}...'),
                      ),
                    ],
                    if (doctor.canVideoCall) ...[
                      const SizedBox(width: 10),
                      ContactButton(
                        icon: Icons.videocam_outlined,
                        tooltip: 'Video call',
                        onTap: () => _showMessage(
                            context, 'Starting video call...'),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  doctor.clinic,
                  style: const TextStyle(fontSize: 14, color: AppColors.accent),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      details.payment.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      details.payment.formatted,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
