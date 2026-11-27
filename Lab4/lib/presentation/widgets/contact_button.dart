import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Buton rotund mic (mesaj / apel / video)
class ContactButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  const ContactButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: AppColors.textDark),
        ),
      ),
    );
  }
}
