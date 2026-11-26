import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Imagine de profil incarcata din retea; daca nu exista internet,
// se afiseaza o iconita de persoana in loc.
class AvatarImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double radius;

  const AvatarImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: AppColors.iconBg,
          child: Icon(Icons.person,
              size: width * 0.6, color: AppColors.primaryDark),
        ),
      ),
    );
  }
}
