import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/avatar_image.dart';
import 'appointment_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAppointment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AppointmentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          children: [
            _buildHeader(),
            const SizedBox(height: 22),
            _buildSearchBar(),
            const SizedBox(height: 22),
            _buildAppointmentCard(context),
            const SizedBox(height: 26),
            _buildSectionTitle('Health Services'),
            const SizedBox(height: 14),
            _buildHealthServices(),
            const SizedBox(height: 26),
            _buildSectionTitle('Nearby Doctor'),
            const SizedBox(height: 14),
            _NearbyDoctorTile(
              name: 'Dr. Emmly Lestiryno',
              specialty: 'General Practitioner',
              address: '3167 Durgan Shores - 500M from you',
              imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
              onTap: () => _openAppointment(context),
            ),
            const SizedBox(height: 18),
            _NearbyDoctorTile(
              name: 'Dr. Sonja Littel',
              specialty: 'Dental Specialist',
              address: '950 Sigrid Port - 753M from you',
              imageUrl: 'https://randomuser.me/api/portraits/men/75.jpg',
              onTap: () => _openAppointment(context),
            ),
          ],
        ),
      ),
    );
  }

  // Avatar + salut + clopotel notificari
  Widget _buildHeader() {
    return Row(
      children: [
        const AvatarImage(
          url: 'https://randomuser.me/api/portraits/men/32.jpg',
          width: 40,
          height: 40,
          radius: 20,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Jonathan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'May you always be healthy',
                style: TextStyle(fontSize: 10, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            const Icon(Icons.notifications_none,
                size: 24, color: AppColors.textDark),
            Positioned(
              right: 2,
              top: 1,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: AppColors.textGrey, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search something',
                hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Icon(Icons.tune, color: AppColors.textGrey, size: 22),
        ],
      ),
    );
  }

  // Cardul turcoaz cu programarea + cardul alb al doctorului suprapus
  Widget _buildAppointmentCard(BuildContext context) {
    const white = TextStyle(color: Colors.white, fontSize: 12);

    return GestureDetector(
      onTap: () => _openAppointment(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 155,
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Appointment',
                        style: white.copyWith(
                            fontSize: 11, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    const Icon(Icons.chevron_right,
                        color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.calendar_month_outlined,
                                  color: Colors.white, size: 16),
                              SizedBox(width: 8),
                              Text('22 October, 2023', style: white),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: Colors.white, size: 16),
                              SizedBox(width: 8),
                              Text('08:00 AM - 10.30 AM', style: white),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit_note,
                          color: AppColors.primary, size: 22),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  AvatarImage(
                    url: 'https://randomuser.me/api/portraits/men/36.jpg',
                    width: 38,
                    height: 38,
                    radius: 4,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Richar Kandowen',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Child Specialist',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chat_outlined,
                      size: 20, color: AppColors.textDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        const Text(
          'See All',
          style: TextStyle(fontSize: 10, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildHealthServices() {
    const services = [
      ('🦷', 'Tooth'),
      ('👁️', 'Eye'),
      ('🫁', 'Lungs'),
      ('👂', 'Ear'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final (emoji, label) in services)
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
      ],
    );
  }
}

class _NearbyDoctorTile extends StatelessWidget {
  final String name;
  final String specialty;
  final String address;
  final String imageUrl;
  final VoidCallback onTap;

  const _NearbyDoctorTile({
    required this.name,
    required this.specialty,
    required this.address,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarImage(url: imageUrl, width: 40, height: 40, radius: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(specialty,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textGrey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(address,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textDark)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.favorite_border,
              size: 20, color: AppColors.textGrey),
        ],
      ),
    );
  }
}
