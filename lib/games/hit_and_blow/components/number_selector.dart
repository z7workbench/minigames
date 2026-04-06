import 'package:flutter/material.dart';
import 'package:minigames/ui/theme/theme_colors.dart';

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
        color: isSelected ? context.themeAccent : context.themePrimary,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? context.themeAccent : context.themeBorder,
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
                style: TextStyle(
                  color: isSelected ? Colors.black : context.themeOnPrimary,
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
