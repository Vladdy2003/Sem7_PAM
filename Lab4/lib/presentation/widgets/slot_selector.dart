import 'package:flutter/material.dart';

import '../../domain/entities/appointment_details.dart';
import '../theme/app_colors.dart';

// Lista orizontala de sloturi selectabile (ore / zile)
class SlotSelector extends StatelessWidget {
  final List<TimeSlot> slots;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const SlotSelector({
    super.key,
    required this.slots,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: slots.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final slot = slots[i];
          final isSelected = slot.id == selectedId;
          return GestureDetector(
            onTap: () => onSelected(slot.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 116,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryDark : AppColors.chip,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                slot.label,
                style: TextStyle(
                  fontSize: 17,
                  color: isSelected ? Colors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
