import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Rand orizontal de chip-uri pentru filtrarea dupa specialitate.
// null = "All".
class FilterChipsBar extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const FilterChipsBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = <String?>[null, ...options];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final value = items[i];
          final isSelected = value == selected;
          return ChoiceChip(
            label: Text(value ?? 'All'),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => onSelected(value),
            labelStyle: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
            selectedColor: AppColors.primaryDark,
            backgroundColor: AppColors.background,
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
    );
  }
}
