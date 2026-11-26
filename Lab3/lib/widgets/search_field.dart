import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Bara de cautare cu buton de stergere si buton de filtre
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final bool filtersActive;

  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onFilterTap,
    this.filtersActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 14, right: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textGrey, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    const TextStyle(color: AppColors.textGrey, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          // butonul "x" apare doar cand exista text
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close,
                        size: 18, color: AppColors.textGrey),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
          ),
          IconButton(
            tooltip: 'Filter & sort',
            onPressed: onFilterTap,
            icon: Badge(
              isLabelVisible: filtersActive,
              backgroundColor: AppColors.primary,
              smallSize: 7,
              child: const Icon(Icons.tune, color: AppColors.textGrey, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
