import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Titlu de sectiune cu actiune optionala in dreapta ("See All")
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double fontSize;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel = 'See All',
    this.onAction,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                fontSize: fontSize * 0.7,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
