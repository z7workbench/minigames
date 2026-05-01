import '../models/chess_state.dart';
import '../models/enums.dart';
import 'san_converter.dart';

class PgnExporter {
  static String exportPgn(
    ChessState state, {
    String? event,
    String? site,
    String? date,
    String? white,
    String? black,
  }) {
    final buffer = StringBuffer();

    final result = _getResult(state);
    final effectiveDate = date ?? _formatDate(DateTime.now());

    buffer.writeln('[Event "${event ?? "MiniGames Chess"}"]');
    buffer.writeln('[Site "${site ?? "Local"}"]');
    buffer.writeln('[Date "$effectiveDate"]');
    buffer.writeln('[Round "1"]');
    buffer.writeln('[White "${white ?? "Player"}"]');
    buffer.writeln('[Black "${black ?? "AI"}"]');
    buffer.writeln('[Result "$result"]');

    if (state.isImported) {
      final initialFen = _getInitialFen(state);
      buffer.writeln('[FEN "$initialFen"]');
      buffer.writeln('[SetUp "1"]');
    }

    buffer.writeln();

    final pgnMoves = SanConverter.moveToPgnMoves(state);
    final moveText = StringBuffer();
    for (int i = 0; i < pgnMoves.length; i++) {
      moveText.write('${pgnMoves[i]} ');
      if ((i + 1) % 8 == 0) moveText.writeln();
    }
    moveText.write(result);

    buffer.writeln(moveText.toString().trim());

    return buffer.toString();
  }

  static String _getResult(ChessState state) {
    switch (state.status) {
      case GameStatus.checkmate:
        return state.winner == PieceColor.white ? '1-0' : '0-1';
      case GameStatus.stalemate:
      case GameStatus.draw:
        return '1/2-1/2';
      default:
        return '*';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  static String _getInitialFen(ChessState state) {
    if (state.positionHistory.isNotEmpty) {
      return state.positionHistory.first;
    }
    return 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  }
}
