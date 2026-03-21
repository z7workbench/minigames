import 'package:flutter/material.dart';
import 'package:minigames/ui/theme/wooden_colors.dart';

class NumberSelector extends StatelessWidget {
  final int number;
  final VoidCallback onTap;
  final bool isSelected;

  const NumberSelector({
    super.key,
    required this.number,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? WoodenColors.accentAmber
            : WoodenColors.lightPrimary,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? WoodenColors.lightSecondary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
