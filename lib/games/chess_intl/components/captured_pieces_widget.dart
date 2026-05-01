import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';
import '../models/chess_piece.dart';
import '../models/enums.dart';

class CapturedPiecesWidget extends StatelessWidget {
  final List<ChessPiece> capturedPieces;
  final PieceColor capturedColor;

  const CapturedPiecesWidget({
    super.key,
    required this.capturedPieces,
    required this.capturedColor,
  });

  @override
  Widget build(BuildContext context) {
    if (capturedPieces.isEmpty) return const SizedBox.shrink();

    final sorted = List<ChessPiece>.from(capturedPieces)
      ..sort((a, b) => b.type.baseValue.compareTo(a.type.baseValue));

    final materialAdvantage = _calculateMaterialAdvantage();

    return Wrap(
      spacing: 1,
      runSpacing: 0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...sorted.map((p) => Text(
              p.unicode,
              style: TextStyle(fontSize: 16, color: context.themeTextSecondary),
            )),
        if (materialAdvantage > 0)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '+$materialAdvantage',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: context.themeAccent,
              ),
            ),
          ),
      ],
    );
  }

  int _calculateMaterialAdvantage() {
    int total = 0;
    for (final p in capturedPieces) {
      total += p.type.baseValue;
    }
    return total ~/ 100;
  }
}
