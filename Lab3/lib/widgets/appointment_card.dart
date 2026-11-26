import 'package:flutter/material.dart';

import '../models/home_data.dart';
import '../theme/app_colors.dart';
import 'avatar_image.dart';

// Cardul turcoaz cu programarea + cardul alb al doctorului suprapus
class AppointmentCard extends StatelessWidget {
  final UpcomingAppointment appointment;
  final VoidCallback onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const white = TextStyle(color: Colors.white, fontSize: 12);
    final doctor = appointment.doctor;

    return GestureDetector(
      onTap: onTap,
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
                    Text(appointment.title,
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
                          _InfoRow(
                              icon: Icons.calendar_month_outlined,
                              text: appointment.date),
                          const SizedBox(height: 12),
                          _InfoRow(
                              icon: Icons.access_time, text: appointment.time),
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
              child: Row(
                children: [
                  AvatarImage(
                    url: doctor.avatarUrl,
                    width: 38,
                    height: 38,
                    radius: 4,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          doctor.specialty,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chat_outlined,
                      size: 20, color: AppColors.textDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
