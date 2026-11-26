import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Inimioara pentru adaugare / eliminare din favorite
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;
  final double size;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFavorite),
          size: size,
          color: isFavorite ? Colors.redAccent : AppColors.textGrey,
        ),
      ),
    );
  }
}
