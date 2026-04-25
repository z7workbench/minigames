import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import 'models/bluff_bar_state.dart';
import 'models/enums.dart';
import 'bluff_bar_provider.dart';

// New Wave 2 components
import 'components/player_panel_widget.dart';
import 'components/hand_display_widget.dart';
import 'components/ai_action_overlay_widget.dart';
import 'components/challenge_overlay_widget.dart';
import 'components/roulette_overlay_widget.dart';
import 'components/round_ranking_overlay.dart';
import 'components/game_end_overlay_widget.dart';
import 'components/played_pile_widget.dart';

/// Main game screen for Bluff Bar card game.
/// 
/// Features:
/// - 4 players (东/西/南/北), human always at 南 (index 0)
/// - Responsive portrait/landscape layouts
/// - Human hand with selection (gray unselected, highlighted selected)
/// - AI action overlays (play/challenge)
/// - Challenge overlay with revealed cards
/// - Roulette overlay with manual draw for human
/// - Immediate defeat overlay when human eliminated
/// - Victory/defeat overlay with rankings at game end
class BluffBarScreen extends ConsumerStatefulWidget {
  final List<AiDifficulty> aiDifficulties;

  const BluffBarScreen({
    super.key,
    required this.aiDifficulties,
  });

  @override
  ConsumerState<BluffBarScreen> createState() => _BluffBarScreenState();
}

class _BluffBarScreenState extends ConsumerState<BluffBarScreen> {
  Set<int> _selectedCardIndices = {};
  
  // Track AI action overlay visibility
  bool _showAiAction = false;
  String _aiActionPlayerName = '';
  AiActionType? _aiActionType;
  int? _aiActionCardCount;
  String? _aiActionTargetPlayer;

  // Track roulette result overlay visibility (shows for 2 seconds after completion)
  bool _showRouletteResult = false;
  String? _rouletteResultPlayerName;
  bool? _rouletteResultSurvived;
  int? _rouletteResultShotsFired;
  Timer? _rouletteResultTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bluffBarGameProvider.notifier).startGame(
        playerCount: 4,
        aiDifficulties: widget.aiDifficulties,
      );
    });
  }

  @override
  void dispose() {
    _rouletteResultTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(bluffBarGameProvider);

    // Listen for roulette completion to show result overlay
    ref.listen(bluffBarGameProvider, (prev, next) {
      if (prev != null &&
          prev.phase == GamePhase.roulette &&
          next.phase != GamePhase.roulette) {
        // Roulette just completed - show result for 2 seconds
        if (prev.roulettePlayerIndex != null) {
          final playerIndex = prev.roulettePlayerIndex!;
          final updatedShots = next.players[playerIndex].rouletteShots;
          setState(() {
            _showRouletteResult = true;
            _rouletteResultPlayerName = _getPositionName(playerIndex);
            _rouletteResultSurvived = next.rouletteSurvived;
            _rouletteResultShotsFired = updatedShots; // Use updated shots count
          });
          _rouletteResultTimer?.cancel();
          _rouletteResultTimer = Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _showRouletteResult = false;
              });
            }
          });
        }
      }
    });

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
        appBar: _buildAppBar(context, state, l10n),
        body: Stack(
          children: [
            // Main game layout
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isLandscape = constraints.maxWidth > constraints.maxHeight;
                  return _buildGameLayout(context, state, l10n, isLandscape);
                },
              ),
            ),

            // AI action overlay
            if (_showAiAction)
              AiActionOverlayWidget(
                playerName: _aiActionPlayerName,
                actionType: _aiActionType!,
                cardCount: _aiActionCardCount!,
                targetPlayerName: _aiActionTargetPlayer ?? '',
                onComplete: () {
                  if (mounted) {
                    setState(() {
                      _showAiAction = false;
                    });
                  }
                },
              ),

            // Challenge overlay
            if (state.phase == GamePhase.reveal && state.challengerIndex != null)
              ChallengeOverlayWidget(
                challengerName: _getPositionName(state.challengerIndex!),
                challengedName: _getPositionName(state.lastPlayerIndex!),
                revealedCards: state.revealedCards,
                result: state.challengeResult,
                loserName: _getPositionName(
                  state.challengeResult == ChallengeResult.liarGuilty
                      ? state.lastPlayerIndex!
                      : state.challengerIndex!,
                ),
                onComplete: () {
                  // Overlay auto-dismisses, state will advance to roulette
                },
              ),

            // Roulette overlay (shows during human's turn)
            if (state.phase == GamePhase.roulette && state.roulettePlayerIndex != null)
              RouletteOverlayWidget(
                playerName: _getPositionName(state.roulettePlayerIndex!),
                shotsFired: state.players[state.roulettePlayerIndex!].rouletteShots,
                remainingChances: 6 - state.players[state.roulettePlayerIndex!].rouletteShots,
                isHuman: state.roulettePlayerIndex == state.humanPlayerIndex,
                showResult: false,
                survived: false,
                onDraw: state.roulettePlayerIndex == state.humanPlayerIndex
                    ? () {
                        ref.read(bluffBarGameProvider.notifier).drawRouletteCard();
                      }
                    : null,
              ),

            // Roulette result overlay (shows for 2 seconds after completion)
            if (_showRouletteResult)
              RouletteOverlayWidget(
                playerName: _rouletteResultPlayerName!,
                shotsFired: _rouletteResultShotsFired ?? 0,
                remainingChances: 6 - (_rouletteResultShotsFired ?? 0),
                isHuman: false,
                showResult: true,
                survived: _rouletteResultSurvived!,
                onDraw: null,
              ),

            // Game end overlay
            if (state.phase == GamePhase.gameOver)
              GameEndOverlayWidget(
                humanWon: state.winnerIndex == state.humanPlayerIndex,
                rankings: ref.read(bluffBarGameProvider.notifier).getRankings(),
                onPlayAgain: () {
                  setState(() {
                    _selectedCardIndices.clear();
                  });
                  ref.read(bluffBarGameProvider.notifier).startGame(
                    playerCount: 4,
                    aiDifficulties: widget.aiDifficulties,
                  );
                },
                onExit: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),

            // Waiting overlay for AI turn
            if (!state.isHumanTurn && state.phase == GamePhase.play && !_showAiAction)
              _buildWaitingOverlay(context, state, l10n),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    BluffBarState state,
    AppLocalizations l10n,
  ) {
    return AppBar(
      title: Text(l10n.bb_game_title),
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
        // Round indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.themeOnPrimary.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            l10n.bb_round(state.roundNumber),
            style: TextStyle(
              color: context.themeOnPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Timer display
        if (state.elapsedSeconds > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                '${state.elapsedSeconds}s',
                style: TextStyle(
                  color: context.themeOnPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGameLayout(
    BuildContext context,
    BluffBarState state,
    AppLocalizations l10n,
    bool isLandscape,
  ) {
    if (isLandscape) {
      return _buildLandscapeLayout(context, state, l10n);
    } else {
      return _buildPortraitLayout(context, state, l10n);
    }
  }

  /// Portrait layout: North(top) + [West(left) + Center + East(right)] + South(bottom)
  Widget _buildPortraitLayout(
    BuildContext context,
    BluffBarState state,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        // North player (index 3)
        _buildPlayerPanelAtTop(context, state, 3),

        // Middle row: West + Center + East
        Expanded(
          child: Row(
            children: [
              _buildPlayerPanelAtLeft(context, state, 2), // West (index 2)
              Expanded(child: _buildCenterArea(context, state, l10n)),
              _buildPlayerPanelAtRight(context, state, 1), // East (index 1)
            ],
          ),
        ),

        // South player (human, index 0) with controls
        if (state.phase == GamePhase.play)
          _buildHumanControls(context, state, l10n),
      ],
    );
  }

  /// Landscape layout: West(left) + [North(top) + Center + South(bottom)] + East(right)
  Widget _buildLandscapeLayout(
    BuildContext context,
    BluffBarState state,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        // West player (index 2)
        _buildPlayerPanelAtLeft(context, state, 2),

        // Center column: North + Game area + South
        Expanded(
          child: Column(
            children: [
              _buildPlayerPanelAtTop(context, state, 3), // North (index 3)
              Expanded(child: _buildCenterArea(context, state, l10n)),
              if (state.phase == GamePhase.play)
                _buildHumanControls(context, state, l10n),
            ],
          ),
        ),

        // East player (index 1)
        _buildPlayerPanelAtRight(context, state, 1),
      ],
    );
  }

  Widget _buildPlayerPanelAtTop(
    BuildContext context,
    BluffBarState state,
    int playerIndex,
  ) {
    try {
      final player = state.players.firstWhere((p) => p.index == playerIndex);
      return Container(
        padding: const EdgeInsets.all(8),
        child: PlayerPanelWidget(
          player: player,
          isCurrentTurn: state.currentPlayerIndex == playerIndex,
          l10n: AppLocalizations.of(context)!,
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildPlayerPanelAtLeft(
    BuildContext context,
    BluffBarState state,
    int playerIndex,
  ) {
    try {
      final player = state.players.firstWhere((p) => p.index == playerIndex);
      return Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: PlayerPanelWidget(
          player: player,
          isCurrentTurn: state.currentPlayerIndex == playerIndex,
          l10n: AppLocalizations.of(context)!,
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildPlayerPanelAtRight(
    BuildContext context,
    BluffBarState state,
    int playerIndex,
  ) {
    try {
      final player = state.players.firstWhere((p) => p.index == playerIndex);
      return Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: PlayerPanelWidget(
          player: player,
          isCurrentTurn: state.currentPlayerIndex == playerIndex,
          l10n: AppLocalizations.of(context)!,
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCenterArea(
    BuildContext context,
    BluffBarState state,
    AppLocalizations l10n,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use more compact layout when space is limited (landscape)
        final isCompact = constraints.maxHeight < 200;

        return Container(
          padding: isCompact ? const EdgeInsets.all(8) : const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.themeSurface.withAlpha(100),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.themeBorder),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Target card display with highlighted gradient background (same style as Joker)
                if (state.targetCard != null)
                  Container(
                    padding: isCompact 
                        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                        : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.themeAccent.withAlpha(200),
                          context.themeAccentSecondary.withAlpha(200),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.themeAccent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.themeAccent.withAlpha(100),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag, size: isCompact ? 16 : 20, color: context.themeOnAccent),
                        const SizedBox(width: 6),
                        Text(
                          '${l10n.bb_target_card}: ${state.targetCard!.symbol}',
                          style: TextStyle(
                            color: context.themeOnAccent,
                            fontSize: isCompact ? 13 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: isCompact ? 6 : 12),

                 // Played pile with count
                 PlayedPileWidget(
                   playedPile: state.playedPile,
                   lastPlayerCardCount: state.playedPile.isNotEmpty ? state.playedPile.last.count : 0,
                   lastClaim: state.lastClaim,
                   l10n: l10n,
                 ),

                 SizedBox(height: isCompact ? 4 : 8),

                 // Phase indicator
                SizedBox(height: isCompact ? 4 : 12),
                Container(
                  padding: isCompact 
                      ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                      : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.themeCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.themeBorder),
                  ),
                  child: Text(
                    _getPhaseLabel(state.phase, l10n),
                    style: TextStyle(
                      color: context.themeTextSecondary,
                      fontSize: isCompact ? 10 : 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHumanControls(
    BuildContext context,
    BluffBarState state,
    AppLocalizations l10n,
  ) {
    final isHumanTurn = state.isHumanTurn && state.phase == GamePhase.play;
    final humanPlayer = state.humanPlayer;
    final shotsFired = humanPlayer.rouletteShots; // Use cumulative shots

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.themeSurface,
        border: Border(top: BorderSide(color: context.themeBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hand display with selection
          if (humanPlayer.hand.isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 80),
              child: HandDisplayWidget(
                cards: humanPlayer.hand,
                selectedIndices: _selectedCardIndices,
                isHumanTurn: isHumanTurn,
                l10n: l10n,
                onCardTap: isHumanTurn ? _onCardTap : null,
                targetRank: state.targetCard,  // 传递目标牌rank
              ),
            ),

          const SizedBox(height: 4),

          // Bottom row: Roulette info + Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Roulette shots indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: humanPlayer.isEliminated 
                      ? context.themeError.withAlpha(50)
                      : context.themeCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: humanPlayer.isEliminated 
                        ? context.themeError 
                        : context.themeBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.gps_fixed,
                      size: 14,
                      color: humanPlayer.isEliminated 
                          ? context.themeError 
                          : context.themeTextSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$shotsFired/6',
                      style: TextStyle(
                        color: humanPlayer.isEliminated 
                            ? context.themeError 
                            : context.themeTextPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Challenge button
              WoodenButton(
                text: l10n.bb_challenge,
                icon: Icons.gavel,
                variant: WoodenButtonVariant.accent,
                size: WoodenButtonSize.small,
                onPressed: isHumanTurn && state.lastPlayerIndex != null &&
                    state.canPlayerChallenge(state.humanPlayerIndex)
                    ? _challenge
                    : null,
              ),

              // Play cards button
              WoodenButton(
                text: l10n.bb_play_cards,
                icon: Icons.play_arrow,
                variant: WoodenButtonVariant.primary,
                size: WoodenButtonSize.small,
                onPressed: isHumanTurn && _selectedCardIndices.isNotEmpty
                    ? _playCards
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingOverlay(
    BuildContext context,
    BluffBarState state,
    AppLocalizations l10n,
  ) {
    final currentPlayer = state.currentPlayer;
    
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: context.themeSurface.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.themeBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.themeAccent,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.bb_waiting_for(_getPositionName(currentPlayer.index)),
                style: TextStyle(
                  color: context.themeTextSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPhaseLabel(GamePhase phase, AppLocalizations l10n) {
    switch (phase) {
      case GamePhase.setup:
        return l10n.bb_phase_setup;
      case GamePhase.deal:
        return l10n.bb_phase_deal;
      case GamePhase.play:
        return l10n.bb_phase_play;
      case GamePhase.challenge:
        return l10n.bb_phase_challenge;
      case GamePhase.reveal:
        return l10n.bb_phase_reveal;
      case GamePhase.roulette:
        return l10n.bb_phase_roulette;
      case GamePhase.roundEnd:
        return l10n.bb_phase_roundEnd;
      case GamePhase.gameOver:
        return l10n.bb_phase_gameOver;
    }
  }

  String _getPositionName(int index) {
    switch (index) {
      case 0:
        return '南';
      case 1:
        return '东';
      case 2:
        return '西';
      case 3:
        return '北';
      default:
        return 'P${index + 1}';
    }
  }

  // ============ Game Actions ============

  void _playCards() {
    if (_selectedCardIndices.isEmpty) return;
    final targetCard = ref.read(bluffBarGameProvider).targetCard;
    if (targetCard == null) return;
    ref.read(bluffBarGameProvider.notifier).playCards(
      _selectedCardIndices.toList(),
      targetCard,
    );

    setState(() {
      _selectedCardIndices.clear();
    });
  }

  void _challenge() {
    ref.read(bluffBarGameProvider.notifier).challengePlayer();
  }

  void _onCardTap(int index) {
    setState(() {
      if (_selectedCardIndices.contains(index)) {
        _selectedCardIndices.remove(index);
      } else if (_selectedCardIndices.length < 4) {
        _selectedCardIndices.add(index);
      }
    });
  }

  // ============ Dialogs ============

  Future<bool?> _showExitConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.themeSurface,
        title: Text(
          l10n.bb_exit,
          style: TextStyle(color: context.themeTextPrimary),
        ),
        content: Text(
          l10n.bb_exit_confirm,
          style: TextStyle(color: context.themeTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeError,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.quit),
          ),
        ],
      ),
    );
  }
}
