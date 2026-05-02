import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../ui/theme/theme_colors.dart';
import '../../ui/widgets/wooden_button.dart';
import '../guess_arrangement/models/playing_card.dart';
import 'components/hand_widget.dart';
import 'components/pass_phase_widget.dart';
import 'components/player_info_widget.dart';
import 'components/scoreboard_widget.dart';
import 'components/trick_widget.dart';
import 'logic/hearts_rules.dart';
import 'models/enums.dart';
import 'models/hearts_player.dart';
import 'models/hearts_state.dart';
import 'hearts_provider.dart';

/// Main game screen for Hearts card game.
///
/// Layout:
/// - AppBar with game title, round number, and menu
/// - Player info widgets at 4 positions (North, East, West, South)
/// - Trick display in center showing current trick cards
/// - Hand display at bottom for human player
/// - Status bar with hearts broken indicator, Q♠ taken, current round
class HeartsScreen extends ConsumerStatefulWidget {
  /// AI difficulties for the 3 AI players (null for human)
  final List<AiDifficulty> aiDifficulties;

  /// Timer option for passing phase
  final TimerOption timerOption;

  /// Moon announcement visibility option
  final MoonAnnouncementOption moonOption;

  const HeartsScreen({
    super.key,
    this.aiDifficulties = const [
      AiDifficulty.medium,
      AiDifficulty.medium,
      AiDifficulty.medium,
    ],
    this.timerOption = TimerOption.seconds15,
    this.moonOption = MoonAnnouncementOption.hidden,
  });

  @override
  ConsumerState<HeartsScreen> createState() => _HeartsScreenState();
}

class _HeartsScreenState extends ConsumerState<HeartsScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _cardPlayController;
  late AnimationController _trickCollectionController;

  // Track trick winner for collection animation
  int? _trickWinnerIndex;

  @override
  void initState() {
    super.initState();
    _cardPlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _trickCollectionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialize game after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
  }

  @override
  void dispose() {
    _cardPlayController.dispose();
    _trickCollectionController.dispose();
    super.dispose();
  }

  void _initializeGame() {
    ref
        .read(heartsGameProvider.notifier)
        .startGame(
          aiDifficulties: widget.aiDifficulties,
          timerOption: widget.timerOption,
          moonOption: widget.moonOption,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(heartsGameProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && state.status == GameStatus.playing) {
          final shouldExit = await _showExitConfirmation(context, l10n);
          if (shouldExit == true && mounted) {
            Navigator.of(context).pop();
          }
        } else if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: context.themeBackground,
        extendBody: true,
        appBar: _buildAppBar(context, state, isDark, l10n),
        body: _buildBody(context, state, isDark, l10n),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final statusText = _getStatusText(state, l10n);

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(l10n.hearts_game_hearts),
            ],
          ),
          Text(
            '${l10n.hearts_roundScores} ${state.roundNumber} - $statusText',
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
          if (state.status == GameStatus.playing) {
            final shouldExit = await _showExitConfirmation(context, l10n);
            if (shouldExit == true && mounted) {
              Navigator.of(context).pop();
            }
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        // Menu button
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(value, context, l10n),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'restart',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: context.themeTextPrimary),
                  const SizedBox(width: 8),
                  Text(l10n.hearts_newGame),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'save',
              child: Row(
                children: [
                  Icon(Icons.save, color: context.themeTextPrimary),
                  const SizedBox(width: 8),
                  Text(l10n.hearts_saveGame),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'quit',
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: context.themeError),
                  const SizedBox(width: 8),
                  Text(l10n.hearts_exitGame),
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
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    // Handle different game statuses
    switch (state.status) {
      case GameStatus.idle:
        return _buildLoadingState(isDark, l10n);
      case GameStatus.dealing:
        return _buildDealingState(isDark, l10n);
      case GameStatus.passing:
        return _buildPassingState(state, isDark, l10n);
      case GameStatus.passComplete:
        return _buildPassCompleteState(state, isDark, l10n);
      case GameStatus.roundEnd:
        return _buildRoundEndState(state, isDark, l10n);
      case GameStatus.gameOver:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showGameOverDialog(state, l10n);
        });
        return _buildGameOverState(state, isDark, l10n);
      case GameStatus.playing:
      case GameStatus.trickEnd:
        return _buildPlayingState(context, state, isDark, l10n);
    }
  }

  Widget _buildLoadingState(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.themeAccent),
          const SizedBox(height: 16),
          Text(
            l10n.hearts_dealing,
            style: TextStyle(color: context.themeTextPrimary, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDealingState(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.themeAccent),
          const SizedBox(height: 16),
          Text(
            l10n.hearts_dealing,
            style: TextStyle(color: context.themeTextPrimary, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPassingState(
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: PassPhaseWidget(
            hand: state.humanPlayer.hand,
            direction: state.passDirection,
            timerOption: state.timerOption,
            onCardsSelected: (cards) {
              ref.read(heartsGameProvider.notifier).selectPassCards(cards);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPassCompleteState(
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final receivedCards = state.humanPlayer.receivedPassCards ?? [];

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.themeSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.themeBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Icon(Icons.swap_horiz, size: 48, color: context.themeAccent),
                const SizedBox(height: 16),
                Text(
                  l10n.hearts_passComplete,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.themeTextPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Received cards message
                Text(
                  l10n.hearts_receivedCards,
                  style: TextStyle(
                    fontSize: 16,
                    color: context.themeTextSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Display received cards
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: receivedCards.map((card) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: context.themeCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.themeBorder),
                      ),
                      child: Text(
                        card.displayString, // Use displayString to show card (e.g., "♠A", "♥K")
                        style: TextStyle(
                          color: _getCardColor(card, isDark),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Continue button
                WoodenButton(
                  text: l10n.hearts_continuePlaying,
                  icon: Icons.arrow_forward,
                  variant: WoodenButtonVariant.primary,
                  size: WoodenButtonSize.large,
                  expandWidth: true,
                  onPressed: () {
                    ref.read(heartsGameProvider.notifier).confirmPassComplete();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayingState(
    BuildContext context,
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: Column(
        children: [
          // Top section: North player
          _buildNorthPlayerSection(state, isDark),

          // Middle section: West, Trick, East
          Expanded(
            child: Row(
              children: [
                // West player
                _buildWestPlayerSection(state, isDark),

                // Center: Trick display and status
                Expanded(child: _buildCenterSection(state, isDark, l10n)),

                // East player
                _buildEastPlayerSection(state, isDark),
              ],
            ),
          ),

          // Bottom section: South player (human) with hand
          _buildSouthPlayerSection(context, state, isDark, l10n),
        ],
      ),
    );
  }

  Widget _buildNorthPlayerSection(HeartsState state, bool isDark) {
    final northPlayer = _getPlayerAtPosition(state, 2); // North position
    if (northPlayer == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      child: PlayerInfoWidget(
        player: northPlayer,
        isCurrentTurn: state.currentPlayerIndex == northPlayer.index,
        isHuman: northPlayer.isHuman,
        position: PlayerPosition.north,
      ),
    );
  }

  Widget _buildWestPlayerSection(HeartsState state, bool isDark) {
    final westPlayer = _getPlayerAtPosition(state, 1); // West position
    if (westPlayer == null) return const SizedBox.shrink();

    return Container(
      width: 100, // Increased from 80 to fit player name
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayerInfoWidget(
            player: westPlayer,
            isCurrentTurn: state.currentPlayerIndex == westPlayer.index,
            isHuman: westPlayer.isHuman,
            position: PlayerPosition.west,
          ),
          const SizedBox(height: 16),
          // Show card count
          _buildCardCountIndicator(westPlayer.cardCount, isDark),
        ],
      ),
    );
  }

  Widget _buildEastPlayerSection(HeartsState state, bool isDark) {
    final eastPlayer = _getPlayerAtPosition(state, 3); // East position
    if (eastPlayer == null) return const SizedBox.shrink();

    return Container(
      width: 100, // Increased from 80 to fit player name
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayerInfoWidget(
            player: eastPlayer,
            isCurrentTurn: state.currentPlayerIndex == eastPlayer.index,
            isHuman: eastPlayer.isHuman,
            position: PlayerPosition.east,
          ),
          const SizedBox(height: 16),
          // Show card count
          _buildCardCountIndicator(eastPlayer.cardCount, isDark),
        ],
      ),
    );
  }

  Widget _buildCenterSection(
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status bar
          _buildStatusBar(state, isDark, l10n),

          const SizedBox(height: 12),

          // Trick display
          AnimatedBuilder(
            animation: _trickCollectionController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (_trickCollectionController.value * 0.3),
                child: Opacity(
                  opacity: 1.0 - _trickCollectionController.value,
                  child: TrickWidget(
                    trick: state.currentTrick,
                    humanPlayerPosition: state.humanPlayerIndex,
                    showWinner: state.status == GameStatus.trickEnd,
                    winnerIndex: _trickWinnerIndex,
                    cardWidth: 55,
                    cardHeight: 80,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // Turn indicator
          _buildTurnIndicator(state, isDark, l10n),
        ],
      ),
    );
  }

  Widget _buildSouthPlayerSection(
    BuildContext context,
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    // Get the player actually at South position (position 0)
    final southPlayer = _getPlayerAtPosition(state, 0) ?? state.humanPlayer;

    // Check if the South player is the human player
    final isHuman = southPlayer.index == state.humanPlayerIndex;

    // Check if it's this player's turn (whether human or AI)
    final isCurrentPlayerTurn = state.currentPlayerIndex == southPlayer.index;

    // Get legal cards for highlighting (only show if human player's turn)
    final legalCards =
        isHuman && isCurrentPlayerTurn && state.status == GameStatus.playing
        ? HeartsRules.getLegalCards(southPlayer, state).toSet()
        : <PlayingCard>{};

    // Don't highlight received pass cards in playing phase - they should only be shown
    // in the passComplete dialog, not highlighted during gameplay
    // So we always pass an empty set for highlightedCards
    final highlightedCards = <PlayingCard>{};

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(50),
        border: Border(top: BorderSide(color: context.themeBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Player info and score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlayerInfoWidget(
                player: southPlayer,
                isCurrentTurn: isCurrentPlayerTurn,
                isHuman: isHuman,
                position: PlayerPosition.south,
              ),
              const SizedBox(width: 16),
              // Score display
              _buildScoreDisplay(southPlayer, isDark),
            ],
          ),

          const SizedBox(height: 8),

          // Hand display - only allow tap on legal cards if it's human player's turn
          HandWidget(
            cards: southPlayer.hand,
            legalCards: legalCards,
            highlightedCards: highlightedCards,
            isSelectable: isHuman && isCurrentPlayerTurn,
            onCardTap: (isHuman && isCurrentPlayerTurn)
                ? (card) {
                    // Only allow tap on legal cards to prevent turn skipping
                    if (legalCards.contains(card)) {
                      _playCard(card, state);
                    }
                  }
                : null,
            cardWidth: 50,
            cardHeight: 75,
            overlap: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildCardCountIndicator(int count, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.themeCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.themeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.style, size: 16, color: context.themeTextSecondary),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              color: context.themeTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(HeartsPlayer player, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.themeCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        children: [
          Text(
            '${player.totalScore}',
            style: TextStyle(
              color: player.totalScore >= 100
                  ? context.themeError
                  : context.themeTextPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '(${player.roundScore} pts)',
            style: TextStyle(color: context.themeTextSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.themeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trick number
          _buildStatusItem(
            icon: Icons.format_list_numbered,
            label: 'Trick ${state.trickNumber}/13',
            color: context.themeTextPrimary,
          ),

          const SizedBox(width: 16),

          // Hearts broken indicator
          if (state.heartsBroken)
            _buildStatusItem(
              icon: Icons.favorite,
              label: l10n.hearts_heartsBroken,
              color: Colors.red,
            ),

          if (state.heartsBroken) const SizedBox(width: 16),

          // Queen of Spades indicator (if taken this round)
          if (_isQueenOfSpadesTaken(state))
            _buildStatusItem(
              icon: Icons.coronavirus, // Using as spade-ish icon
              label: 'Q♠ ${l10n.hearts_pointsTaken}',
              color: Colors.red.shade700,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTurnIndicator(
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final isHumanTurn = state.isHumanTurn;
    final currentPlayer = state.currentPlayer;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isHumanTurn
            ? context.themeAccent.withAlpha(50)
            : context.themeSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHumanTurn ? context.themeAccent : context.themeBorder,
          width: isHumanTurn ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHumanTurn ? Icons.person : Icons.smart_toy,
            color: isHumanTurn
                ? context.themeAccent
                : context.themeTextSecondary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isHumanTurn
                ? l10n.hearts_yourTurn
                : '${currentPlayer.name} ${l10n.hearts_waitTurn}',
            style: TextStyle(
              color: isHumanTurn
                  ? context.themeAccent
                  : context.themeTextSecondary,
              fontSize: 14,
              fontWeight: isHumanTurn ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundEndState(
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.hearts_roundEnd,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.themeTextPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ScoreboardWidget(
                players: state.players,
                currentRound: state.roundNumber,
                humanPlayerIndex: state.humanPlayerIndex,
                showGameScores: true,
              ),
              const SizedBox(height: 24),
              WoodenButton(
                text: l10n.hearts_resume,
                icon: Icons.play_arrow,
                variant: WoodenButtonVariant.primary,
                size: WoodenButtonSize.large,
                onPressed: () {
                  ref.read(heartsGameProvider.notifier).startNextRound();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverState(
    HeartsState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 64, color: context.themeAccent),
          const SizedBox(height: 16),
          Text(
            l10n.hearts_gameOver,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: context.themeTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Helper Methods ====================

  Color _getCardColor(PlayingCard card, bool isDark) {
    if (card.suit == CardSuit.hearts || card.suit == CardSuit.diamonds) {
      return Colors.red.shade600;
    }
    return isDark ? Colors.white : Colors.black;
  }

  HeartsPlayer? _getPlayerAtPosition(HeartsState state, int position) {
    try {
      return state.players.firstWhere((p) => p.position == position);
    } catch (e) {
      return null;
    }
  }

  bool _isQueenOfSpadesTaken(HeartsState state) {
    // Check if any player has won the Queen of Spades in their tricks
    for (final player in state.players) {
      if (player.tricksWon.any(
        (c) => c.suit == CardSuit.spades && c.rank == CardRank.queen,
      )) {
        return true;
      }
    }
    return false;
  }

  String _getStatusText(HeartsState state, AppLocalizations l10n) {
    switch (state.status) {
      case GameStatus.idle:
        return l10n.hearts_dealing;
      case GameStatus.dealing:
        return l10n.hearts_dealing;
      case GameStatus.passing:
        return l10n.hearts_passing;
      case GameStatus.passComplete:
        return l10n.hearts_passComplete;
      case GameStatus.playing:
        return l10n.hearts_playing;
      case GameStatus.trickEnd:
        return l10n.hearts_roundEnd;
      case GameStatus.roundEnd:
        return l10n.hearts_roundEnd;
      case GameStatus.gameOver:
        return l10n.hearts_gameOver;
    }
  }

  // ==================== Game Actions ====================

  void _playCard(PlayingCard card, HeartsState state) {
    ref.read(heartsGameProvider.notifier).playCard(card);
  }

  void _handleMenuAction(
    String action,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    switch (action) {
      case 'restart':
        _showRestartConfirmation(context, l10n);
        break;
      case 'save':
        _showSaveGameDialog(context, l10n);
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

  // ==================== Dialogs ====================

  Future<bool?> _showExitConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.hearts_exitGame),
        content: Text('确定要退出游戏吗？当前进度将会丢失。'),
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
        title: Text(l10n.hearts_newGame),
        content: Text('确定要重新开始游戏吗？当前进度将会丢失。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _showSaveGameDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.hearts_saveGame),
        content: const Text('保存功能即将推出'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(HeartsState state, AppLocalizations l10n) {
    final winner = state.winner;
    final isHumanWinner = winner == state.humanPlayerIndex;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: context.themeAccent),
            const SizedBox(width: 8),
            Text(l10n.hearts_finalResults),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Winner announcement
            Text(
              winner != null
                  ? '${state.players[winner].name} ${l10n.hearts_winner}!'
                  : l10n.hearts_draw,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isHumanWinner
                    ? context.themeAccent
                    : context.themeTextPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Final scores
            ScoreboardWidget(
              players: state.players,
              currentRound: state.roundNumber,
              humanPlayerIndex: state.humanPlayerIndex,
              showGameScores: true,
              compact: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.hearts_exitGame),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: Text(l10n.hearts_playAgain),
          ),
        ],
      ),
    );
  }
}

// Extension for draw message
extension on AppLocalizations {
  String get hearts_draw => 'Draw!';
}
