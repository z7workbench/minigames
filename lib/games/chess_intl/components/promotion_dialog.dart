import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';
import '../models/enums.dart';

class PromotionDialog extends StatelessWidget {
  final PieceColor playerColor;

  const PromotionDialog({super.key, required this.playerColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pieces = [
      (PieceType.queen, playerColor == PieceColor.white ? '\u2655' : '\u265B', 'Queen'),
      (PieceType.rook, playerColor == PieceColor.white ? '\u2656' : '\u265C', 'Rook'),
      (PieceType.bishop, playerColor == PieceColor.white ? '\u2657' : '\u265D', 'Bishop'),
      (PieceType.knight, playerColor == PieceColor.white ? '\u2658' : '\u265E', 'Knight'),
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? context.themeSurface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Promotion',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.themeTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: pieces.map((p) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context, p.$1),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: context.themeCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.themeBorder),
                    ),
                    child: Center(
                      child: Text(
                        p.$2,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  static Future<PieceType?> show(BuildContext context, PieceColor color) {
    return showDialog<PieceType>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PromotionDialog(playerColor: color),
    );
  }
}
