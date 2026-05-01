import '../models/chess_move.dart';
import '../models/chess_state.dart';

abstract class ChessAi {
  Future<ChessMove?> findBestMove(
    ChessState state, {
    Duration? timeLimit,
    bool Function()? isCancelled,
  });

  int getRandomDelay() => 300 + (DateTime.now().microsecond % 700);
}
