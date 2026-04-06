import 'package:flutter/material.dart';
import 'package:minigames/ui/theme/theme_colors.dart';

class GuessHistoryItem extends StatelessWidget {
  final List<int> guess;
  final int hits;
  final int blows;
  final int targetLength;

  const GuessHistoryItem({
    super.key,
    required this.guess,
    required this.hits,
    required this.blows,
    required this.targetLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.themeBorder),
      ),
      child: Row(
        children: [
          // Guess numbers
          Expanded(
            child: Wrap(
              spacing: 4,
              children: List.generate(targetLength, (index) {
                final number = index < guess.length ? guess[index] : 0;
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.themePrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      number > 0 ? number.toString() : '',
                      style: TextStyle(
                        color: context.themeOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Hit/Blow indicators
          Row(
            children: [
              ...List.generate(
                hits,
                (_) => Icon(
                  Icons.check_circle,
                  color: context.themeSuccess,
                  size: 16,
                ),
              ),
              ...List.generate(
                blows,
                (_) => Icon(
                  Icons.check_circle_outline,
                  color: context.themeTextSecondary,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
