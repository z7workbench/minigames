import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../ui/theme/theme_colors.dart';
import '../../ui/widgets/wooden_button.dart';
import 'components/chess_board_widget.dart';
import 'components/promotion_dialog.dart';
import 'components/captured_pieces_widget.dart';
import 'models/chess_move.dart';
import 'models/chess_state.dart';
import 'models/enums.dart';
import 'chess_intl_provider.dart';

class ChessIntlScreen extends ConsumerStatefulWidget {
  final AiDifficulty difficulty;
  final PieceColor playerColor;
  final PieceStyle pieceStyle;
  final String? fen;

  const ChessIntlScreen({
    super.key,
    this.difficulty = AiDifficulty.easy,
    this.playerColor = PieceColor.white,
    this.pieceStyle = PieceStyle.filled,
    this.fen,
  });

  @override
  ConsumerState<ChessIntlScreen> createState() => _ChessIntlScreenState();
}

class _ChessIntlScreenState extends ConsumerState<ChessIntlScreen> {
  int? _selectedRow;
  int? _selectedCol;
  List<ChessMove> _legalMoves = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
  }

  void _initializeGame() {
    ref.read(chessGameProvider.notifier).startGame(
          difficulty: widget.difficulty,
          playerColor: widget.playerColor,
          fen: widget.fen,
        );
  }

  void _onSquareTap(int row, int col) {
    final state = ref.read(chessGameProvider);
    final provider = ref.read(chessGameProvider.notifier);

    if (provider.isAiThinking) return;
    if (state.status == GameStatus.checkmate ||
        state.status == GameStatus.stalemate ||
        state.status == GameStatus.draw ||
        state.status == GameStatus.gameOver) return;

    if (state.currentTurn != widget.playerColor) return;

    final piece = state.pieceAt(row, col);

    if (_selectedRow != null && _selectedCol != null) {
      final isLegalTarget = _legalMoves.any(
        (m) => m.toRow == row && m.toCol == col,
      );

      if (isLegalTarget) {
        final hasPromotion = _legalMoves.any(
          (m) => m.toRow == row && m.toCol == col && m.promotionPiece != null,
        );

        if (hasPromotion) {
          _showPromotionDialog(row, col);
        } else {
          final move = _legalMoves.firstWhere(
            (m) => m.toRow == row && m.toCol == col,
          );
          provider.makeMove(move);
          _clearSelection();
        }
        return;
      }

      if (piece != null && piece.color == widget.playerColor) {
        setState(() {
          _selectedRow = row;
          _selectedCol = col;
          _legalMoves = provider.getLegalMovesForSquare(row, col);
        });
        return;
      }

      _clearSelection();
      return;
    }

    if (piece != null && piece.color == widget.playerColor) {
      setState(() {
        _selectedRow = row;
        _selectedCol = col;
        _legalMoves = provider.getLegalMovesForSquare(row, col);
      });
    }
  }

  void _showPromotionDialog(int toRow, int toCol) async {
    final promotionPiece = await PromotionDialog.show(
      context,
      widget.playerColor,
    );

    if (promotionPiece != null && mounted) {
      final move = ChessMove(
        fromRow: _selectedRow!,
        fromCol: _selectedCol!,
        toRow: toRow,
        toCol: toCol,
        promotionPiece: promotionPiece,
      );
      ref.read(chessGameProvider.notifier).makeMove(move);
    }
    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _selectedRow = null;
      _selectedCol = null;
      _legalMoves = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chessGameProvider);
    final provider = ref.read(chessGameProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _showExitConfirmation(context, l10n);
          if (shouldExit == true && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.themeBackground,
        appBar: _buildAppBar(context, state, l10n),
        body: _buildBody(context, state, provider, isDark, l10n),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ChessState state,
    AppLocalizations l10n,
  ) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u265A', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(l10n.ci_gameTitle),
            ],
          ),
          Text(
            _getStatusText(state, l10n),
            style: TextStyle(
              fontSize: 12,
              color: context.themeOnPrimary.withAlpha(200),
            ),
          ),
        ],
      ),
      backgroundColor: context.themePrimary,
      foregroundColor: context.themeOnPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          final shouldExit = await _showExitConfirmation(context, l10n);
          if (shouldExit == true && mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(value, context, l10n),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'new_game',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: context.themeTextPrimary),
                  const SizedBox(width: 8),
                  Text(l10n.ci_newGame),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'undo',
              child: Row(
                children: [
                  Icon(Icons.undo, color: context.themeTextPrimary),
                  const SizedBox(width: 8),
                  Text(l10n.ci_undo),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'copy_fen',
              child: Row(
                children: [
                  Icon(Icons.copy, color: context.themeTextPrimary),
                  const SizedBox(width: 8),
                  Text(l10n.ci_copyFen),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export_pgn',
              child: Row(
                children: [
                  Icon(Icons.share, color: context.themeTextPrimary),
                  const SizedBox(width: 8),
                  Text(l10n.ci_exportPgn),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'quit',
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: context.themeError),
                  const SizedBox(width: 8),
                  Text(l10n.ci_exitGame),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    ChessState state,
    ChessGame provider,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          if (isLandscape) {
            return _buildLandscapeLayout(
                context, state, provider, isDark, l10n, constraints);
          } else {
            return _buildPortraitLayout(
                context, state, provider, isDark, l10n, constraints);
          }
        },
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    ChessState state,
    ChessGame provider,
    bool isDark,
    AppLocalizations l10n,
    BoxConstraints constraints,
  ) {
    final opponentColor = widget.playerColor.opposite;
    final opponentCaptured = widget.playerColor == PieceColor.white
        ? state.capturedBlackPieces
        : state.capturedWhitePieces;
    final playerCaptured = widget.playerColor == PieceColor.white
        ? state.capturedWhitePieces
        : state.capturedBlackPieces;

    return Column(
      children: [
        _buildOpponentInfoBar(state, opponentColor, opponentCaptured, l10n),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ChessBoardWidget(
                state: state,
                playerColor: widget.playerColor,
                onSquareTap: _onSquareTap,
                selectedRow: _selectedRow,
                selectedCol: _selectedCol,
                legalMoves: _legalMoves,
                pieceStyle: widget.pieceStyle,
              ),
            ),
          ),
        ),
        _buildPlayerInfoBar(state, widget.playerColor, playerCaptured, l10n),
        _buildBottomControls(state, provider, l10n),
      ],
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    ChessState state,
    ChessGame provider,
    bool isDark,
    AppLocalizations l10n,
    BoxConstraints constraints,
  ) {
    final opponentColor = widget.playerColor.opposite;
    final opponentCaptured = widget.playerColor == PieceColor.white
        ? state.capturedBlackPieces
        : state.capturedWhitePieces;
    final playerCaptured = widget.playerColor == PieceColor.white
        ? state.capturedWhitePieces
        : state.capturedBlackPieces;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ChessBoardWidget(
                state: state,
                playerColor: widget.playerColor,
                onSquareTap: _onSquareTap,
                selectedRow: _selectedRow,
                selectedCol: _selectedCol,
                legalMoves: _legalMoves,
                pieceStyle: widget.pieceStyle,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildOpponentInfoBar(
                  state, opponentColor, opponentCaptured, l10n),
              Expanded(child: _buildMoveHistoryPanel(state, l10n)),
              _buildPlayerInfoBar(
                  state, widget.playerColor, playerCaptured, l10n),
              _buildBottomControls(state, provider, l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOpponentInfoBar(
    ChessState state,
    PieceColor color,
    List<dynamic> capturedPieces,
    AppLocalizations l10n,
  ) {
    final isAiTurn = state.currentTurn == color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(50),
        border: Border(bottom: BorderSide(color: context.themeBorder)),
      ),
      child: Row(
        children: [
          Text(
            color == PieceColor.white ? '\u2654' : '\u265A',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Text(
            color == PieceColor.white ? l10n.ci_white : l10n.ci_black,
            style: TextStyle(
              color: context.themeTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isAiTurn) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.themeAccent,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              l10n.ci_thinking,
              style: TextStyle(
                color: context.themeAccent,
                fontSize: 12,
              ),
            ),
          ],
          const Spacer(),
          CapturedPiecesWidget(
            capturedPieces: capturedPieces.cast(),
            capturedColor: color.opposite,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoBar(
    ChessState state,
    PieceColor color,
    List<dynamic> capturedPieces,
    AppLocalizations l10n,
  ) {
    final isMyTurn = state.currentTurn == color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(50),
        border: Border(top: BorderSide(color: context.themeBorder)),
      ),
      child: Row(
        children: [
          Text(
            color == PieceColor.white ? '\u2654' : '\u265A',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.ci_you,
            style: TextStyle(
              color: isMyTurn ? context.themeAccent : context.themeTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          CapturedPiecesWidget(
            capturedPieces: capturedPieces.cast(),
            capturedColor: color.opposite,
          ),
        ],
      ),
    );
  }

  Widget _buildMoveHistoryPanel(ChessState state, AppLocalizations l10n) {
    final moves = ref.read(chessGameProvider.notifier).moveHistorySan;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ci_moveHistory,
            style: TextStyle(
              color: context.themeTextPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: moves.isEmpty
                ? Center(
                    child: Text(
                      l10n.ci_noMovesYet,
                      style: TextStyle(
                        color: context.themeDisabled,
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: (moves.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final whiteIdx = index * 2;
                      final blackIdx = index * 2 + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                '${index + 1}.',
                                style: TextStyle(
                                  color: context.themeTextSecondary,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                whiteIdx < moves.length
                                    ? moves[whiteIdx]
                                    : '',
                                style: TextStyle(
                                  color: context.themeTextPrimary,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                blackIdx < moves.length
                                    ? moves[blackIdx]
                                    : '',
                                style: TextStyle(
                                  color: context.themeTextPrimary,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(
    ChessState state,
    ChessGame provider,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(50),
        border: Border(top: BorderSide(color: context.themeBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: WoodenButton(
              text: l10n.ci_undo,
              icon: Icons.undo,
              variant: WoodenButtonVariant.secondary,
              onPressed: state.moveHistory.length >= 2 && !provider.isAiThinking
                  ? () {
                      provider.undoMove();
                      _clearSelection();
                    }
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: WoodenButton(
              text: l10n.ci_newGame,
              icon: Icons.refresh,
              variant: WoodenButtonVariant.primary,
              onPressed: () {
                _clearSelection();
                _initializeGame();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(ChessState state, AppLocalizations l10n) {
    switch (state.status) {
      case GameStatus.idle:
        return l10n.ci_preparing;
      case GameStatus.playing:
        return state.currentTurn == widget.playerColor
            ? l10n.ci_yourTurn
            : l10n.ci_aiTurn;
      case GameStatus.check:
        return state.currentTurn == widget.playerColor
            ? l10n.ci_youAreInCheck
            : l10n.ci_aiInCheck;
      case GameStatus.checkmate:
        return state.winner == widget.playerColor
            ? l10n.ci_youWin
            : l10n.ci_aiWins;
      case GameStatus.stalemate:
        return l10n.ci_stalemate;
      case GameStatus.draw:
        return l10n.ci_draw;
      case GameStatus.promotion:
        return l10n.ci_choosePromotion;
      case GameStatus.gameOver:
        if (state.winner == widget.playerColor) return l10n.ci_youWin;
        if (state.winner == widget.playerColor.opposite) return l10n.ci_aiWins;
        return l10n.ci_draw;
    }
  }

  void _handleMenuAction(
      String action, BuildContext context, AppLocalizations l10n) {
    switch (action) {
      case 'new_game':
        _showRestartConfirmation(context, l10n);
        break;
      case 'undo':
        ref.read(chessGameProvider.notifier).undoMove();
        _clearSelection();
        break;
      case 'copy_fen':
        final fen = ref.read(chessGameProvider.notifier).currentFen;
        Clipboard.setData(ClipboardData(text: fen));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.ci_fenCopied),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case 'export_pgn':
        _showPgnExportDialog(context, l10n);
        break;
      case 'quit':
        _showExitConfirmation(context, l10n).then((shouldExit) {
          if (shouldExit == true && mounted) {
            Navigator.of(context).pop();
          }
        });
        break;
    }
  }

  void _showPgnExportDialog(BuildContext context, AppLocalizations l10n) {
    final pgn = ref.read(chessGameProvider.notifier).exportPgn();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.ci_exportPgn),
        content: SizedBox(
          width: double.maxFinite,
          child: SelectableText(
            pgn,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: pgn));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.ci_pgnCopied),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(l10n.ci_copyPgn),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showExitConfirmation(
      BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.ci_exitGame),
        content: Text(l10n.ci_exitConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeError,
            ),
            child: Text(l10n.quit),
          ),
        ],
      ),
    );
  }

  void _showRestartConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.ci_newGame),
        content: Text(l10n.ci_restartConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearSelection();
              _initializeGame();
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
