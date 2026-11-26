import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../theme/app_colors.dart';
import 'avatar_image.dart';
import 'favorite_button.dart';

// Element din lista "Nearby Doctor"
class DoctorTile extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const DoctorTile({
    super.key,
    required this.doctor,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'doctor-avatar-${doctor.id}',
              child: AvatarImage(
                  url: doctor.avatarUrl, width: 40, height: 40, radius: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(doctor.specialty,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(doctor.distance,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.textDark)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FavoriteButton(
              isFavorite: doctor.isFavorite,
              onPressed: onFavoriteTap,
            ),
          ],
        ),
      ),
    );
  }
}
