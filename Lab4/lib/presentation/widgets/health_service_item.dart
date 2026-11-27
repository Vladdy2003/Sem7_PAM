import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entities/home_feed.dart';
import '../theme/app_colors.dart';

// Un serviciu medical (iconita SVG din retea + denumire)
class HealthServiceItem extends StatelessWidget {
  /// In testele widget reteaua e blocata, asa ca acolo se dezactiveaza.
  static bool loadNetworkIcons = true;

  final HealthService service;
  final bool selected;
  final VoidCallback? onTap;

  const HealthServiceItem({
    super.key,
    required this.service,
    this.selected = false,
    this.onTap,
  });

  static const Widget _fallbackIcon = Icon(
    Icons.medical_services_outlined,
    color: AppColors.primaryDark,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selected ? AppColors.iconBg : AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: loadNetworkIcons
                ? SvgPicture.network(
                    service.iconUrl,
                    placeholderBuilder: (_) => const SizedBox.shrink(),
                    errorBuilder: (_, _, _) => _fallbackIcon,
                  )
                : _fallbackIcon,
          ),
          const SizedBox(height: 8),
          Text(
            service.name,
            style: TextStyle(
              fontSize: 11,
              color: selected ? AppColors.primaryDark : AppColors.textGrey,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
