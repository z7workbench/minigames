import 'dart:math';

import '../models/connect_four_state.dart';
import '../models/enums.dart';
import '../logic/connect_four_rules.dart';
import 'connect_four_ai.dart';

class EasyConnectFourAi extends ConnectFourAi {
  final Random _random = Random();

  @override
  Future<int?> findBestMove(
    ConnectFourState state, {
    Duration? timeLimit,
    bool Function()? isCancelled,
  }) async {
    final validCols = state.validColumns;
    if (validCols.isEmpty) return null;

    final aiPiece = state.currentTurn;
    final playerPiece = aiPiece.opposite;

    for (final col in validCols) {
      if (ConnectFourRules.wouldWin(state, col, aiPiece)) {
        return col;
      }
    }

    for (final col in validCols) {
      if (ConnectFourRules.wouldWin(state, col, playerPiece)) {
        return col;
      }
    }

    return validCols[_random.nextInt(validCols.length)];
  }
}
