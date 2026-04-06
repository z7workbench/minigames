import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'yacht_dice_provider.dart';
import 'models/yacht_dice_state.dart';
import 'models/scoring_category.dart';
import 'models/scoring.dart';
import 'components/score_preview_card.dart';
import 'components/score_detail_modal.dart';
import 'components/animated_dice.dart';
import 'components/category_confirmation_dialog.dart';
import 'package:minigames/ui/theme/theme_colors.dart';
import 'package:minigames/l10n/generated/app_localizations.dart';

class YachtDiceScreen extends ConsumerStatefulWidget {
  final int playerCount;
  final AiDifficulty? aiDifficulty;
  final YachtDiceState? restoredState;

  const YachtDiceScreen({
    super.key,
    required this.playerCount,
    this.aiDifficulty,
    this.restoredState,
  });

  @override
  ConsumerState<YachtDiceScreen> createState() => _YachtDiceScreenState();
}

class _YachtDiceScreenState extends ConsumerState<YachtDiceScreen> {
  /// Track if dice are currently rolling for animation
  bool _isRolling = false;

  /// Track the last player index to detect player changes
  int _lastPlayerIndex = -1;

  /// Track if this is the first build
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to modify provider after widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.restoredState != null) {
        // Restore saved game state - don't auto-roll
        ref
            .read(yachtDiceGameProvider.notifier)
            .startGame(
              widget.playerCount,
              widget.aiDifficulty,
              restoredState: widget.restoredState,
            );
      } else {
        // Start new game - don't auto-roll, let user click the button
        ref
            .read(yachtDiceGameProvider.notifier)
            .startGame(widget.playerCount, widget.aiDifficulty);
      }
    });
  }

  /// Show a full-screen player turn indicator
  void _showPlayerTurnIndicator(String playerName) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: context.themePrimary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.casino, size: 64, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      playerName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.yd_playerTurn,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Auto dismiss after 700ms
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  /// Show celebration animation for special combinations
  void _showCombinationCelebration(ScoringCategory category) {
    final l10n = AppLocalizations.of(context)!;

    // Get category name and color based on type
    String categoryName;
    IconData icon;
    List<Color> gradientColors;

    switch (category) {
      case ScoringCategory.yacht:
        categoryName = l10n.yd_yacht;
        icon = Icons.emoji_events;
        gradientColors = [const Color(0xFFFFD700), const Color(0xFFFF8C00)];
        break;
      case ScoringCategory.largeStraight:
        categoryName = l10n.yd_largeStraight;
        icon = Icons.stars;
        gradientColors = [const Color(0xFF9C27B0), const Color(0xFFE91E63)];
        break;
      case ScoringCategory.smallStraight:
        categoryName = l10n.yd_smallStraight;
        icon = Icons.star;
        gradientColors = [const Color(0xFF2196F3), const Color(0xFF03A9F4)];
        break;
      case ScoringCategory.fullHouse:
        categoryName = l10n.yd_fullHouse;
        icon = Icons.home;
        gradientColors = [const Color(0xFF4CAF50), const Color(0xFF8BC34A)];
        break;
      case ScoringCategory.fourOfAKind:
        categoryName = l10n.yd_fourOfAKind;
        icon = Icons.casino;
        gradientColors = [const Color(0xFFFF5722), const Color(0xFFFF9800)];
        break;
      default:
        return; // Should not happen
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(180),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.scale(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                ).value,
                child: Opacity(opacity: animation.value, child: child),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withAlpha(150),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated icon with glow effect
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  // Category name
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Celebration text
                  Text(
                    '🎉 Congratulations! 🎉',
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Auto dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  /// Show exit confirmation dialog
  Future<bool> _showExitConfirmationDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.yd_exitTitle),
        content: Text(l10n.yd_exitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'exit_no_save'),
            child: Text(l10n.yd_exitWithoutSaving),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'save_and_exit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.yd_saveAndExit),
          ),
        ],
      ),
    );

    if (result == null || result == 'cancel') {
      return false; // User cancelled
    }

    if (result == 'save_and_exit') {
      await ref.read(yachtDiceGameProvider.notifier).saveGameState();
    }

    return true; // User wants to exit
  }

  /// Perform dice roll with animation state tracking
  void _performRoll() {
    setState(() {
      _isRolling = true;
    });
    ref.read(yachtDiceGameProvider.notifier).rollDice();
    // End rolling animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isRolling = false;
        });
        // Show toast after roll for human players
        final state = ref.read(yachtDiceGameProvider);
        final currentPlayer = state.players[state.currentPlayerIndex];
        if (currentPlayer.type == PlayerType.human && !state.isGameOver) {
          final rollNumber =
              3 - currentPlayer.rollsRemaining; // Fixed: correct roll number
          if (rollNumber > 0) {
            _showRollInfoToast(
              context,
              rollNumber,
              currentPlayer.rollsRemaining,
            );
          }

          // Check for special combinations and show celebration
          final specialCombination = detectSpecialCombination(
            currentPlayer.dice,
          );
          if (specialCombination != null) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _showCombinationCelebration(specialCombination);
              }
            });
          }
        }
      }
    });
  }

  void _showRollInfoToast(
    BuildContext context,
    int rollNumber,
    int rollsRemaining,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.refresh, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            '${l10n.yd_roll(rollNumber)} • ${l10n.yd_rollsRemaining}: $rollsRemaining',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: context.themeAccent,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Get localized name for a scoring category
  String _getCategoryLocalizedName(ScoringCategory category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case ScoringCategory.ones:
        return l10n.yd_ones;
      case ScoringCategory.twos:
        return l10n.yd_twos;
      case ScoringCategory.threes:
        return l10n.yd_threes;
      case ScoringCategory.fours:
        return l10n.yd_fours;
      case ScoringCategory.fives:
        return l10n.yd_fives;
      case ScoringCategory.sixes:
        return l10n.yd_sixes;
      case ScoringCategory.allSelect:
        return l10n.yd_allSelect;
      case ScoringCategory.fullHouse:
        return l10n.yd_fullHouse;
      case ScoringCategory.fourOfAKind:
        return l10n.yd_fourOfAKind;
      case ScoringCategory.smallStraight:
        return l10n.yd_smallStraight;
      case ScoringCategory.largeStraight:
        return l10n.yd_largeStraight;
      case ScoringCategory.yacht:
        return l10n.yd_yacht;
    }
  }

  Widget _buildScoreCard(
    PlayerState player,
    bool canSelect,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return ScorePreviewCard(
      player: player,
      dice: player.dice,
      canSelect: canSelect,
      onCategorySelected: (category) {
        if (!canSelect) return;

        final score = calculateScore(player.dice, category);
        final categoryName = _getCategoryLocalizedName(category);

        showDialog(
          context: context,
          builder: (context) => CategoryConfirmationDialog(
            categoryName: categoryName,
            score: score,
            onConfirm: () {
              Navigator.pop(context);
              ref.read(yachtDiceGameProvider.notifier).selectCategory(category);
            },
            onCancel: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(yachtDiceGameProvider);
    final currentPlayer = state.players[state.currentPlayerIndex];

    // Check for player change and show turn indicator
    if (!_isFirstBuild &&
        _lastPlayerIndex != -1 &&
        _lastPlayerIndex != state.currentPlayerIndex &&
        !state.isGameOver) {
      // Player has changed, show indicator after current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && currentPlayer.type == PlayerType.human) {
          _showPlayerTurnIndicator(currentPlayer.name);
        }
      });
    }
    _lastPlayerIndex = state.currentPlayerIndex;
    _isFirstBuild = false;

    // Theme-aware colors
    final backgroundColor = context.themeBackground;
    final surfaceColor = context.themeSurface;
    final cardColor = context.themeCard;
    final primaryColor = context.themePrimary;
    final secondaryColor = context.themeSecondary;
    final textPrimary = context.themeTextPrimary;
    final textSecondary = context.themeTextSecondary;

    // Check game over
    if (state.isGameOver) {
      final winner = ref.read(yachtDiceGameProvider.notifier).getWinner();
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(l10n.game_yacht_dice),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                winner != null ? '${winner.name} wins!' : 'Draw!',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: textPrimary),
              ),
              Text(
                'Score: ${winner?.totalScore ?? 0}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(yachtDiceGameProvider.notifier)
                      .startGame(widget.playerCount, widget.aiDifficulty);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    ref.read(yachtDiceGameProvider.notifier).startFirstRoll();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.themeAccent,
                  foregroundColor: context.themeOnAccent,
                ),
                child: Text(l10n.newGame),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.back),
              ),
            ],
          ),
        ),
      );
    }

    final canRoll =
        currentPlayer.rollsRemaining > 0 && state.phase == GamePhase.rolling;
    final canToggleKept =
        currentPlayer.rollsRemaining > 0 &&
        state.phase == GamePhase.rolling &&
        currentPlayer.rollsRemaining < 3; // Can only toggle after first roll
    // Can select category only if at least one roll has been made and dice are not 0
    final diceRolled = !currentPlayer.dice.any((d) => d == 0);
    final canSelectCategory =
        diceRolled &&
        (state.phase == GamePhase.selectingCategory ||
            (state.phase == GamePhase.rolling &&
                currentPlayer.rollsRemaining < 3));
    final isAiTurn =
        currentPlayer.type == PlayerType.ai &&
        (state.phase == GamePhase.rolling ||
            state.phase == GamePhase.selectingCategory);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final gameState = ref.read(yachtDiceGameProvider);
        // Only show dialog if game is in progress (not game over)
        if (!gameState.isGameOver) {
          if (await _showExitConfirmationDialog()) {
            if (mounted) {
              Navigator.of(context).pop();
            }
          }
        } else {
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(l10n.game_yacht_dice),
          backgroundColor: primaryColor,
          foregroundColor: context.themeOnPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final gameState = ref.read(yachtDiceGameProvider);
              if (!gameState.isGameOver) {
                if (await _showExitConfirmationDialog()) {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              } else {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Player info
              Container(
                padding: const EdgeInsets.all(16),
                color: surfaceColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentPlayer.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          '${l10n.score}: ${currentPlayer.totalScore}',
                          style: TextStyle(fontSize: 14, color: textSecondary),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${l10n.yd_rollsRemaining}: ${currentPlayer.rollsRemaining}',
                          style: TextStyle(fontSize: 14, color: textSecondary),
                        ),
                        Text(
                          canSelectCategory
                              ? l10n.yd_selectCategory
                              : (canRoll ? l10n.yd_rollDice : '...'),
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // AI thinking indicator
              if (isAiTurn)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: context.themeAccent.withValues(alpha: 0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${l10n.yd_ai} ${l10n.yd_playerTurn}...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              // Dice area - Using AnimatedDice with responsive sizing
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate dice size to fit 5 dice in a row with spacing
                  final horizontalPadding = 12.0;
                  final diceSpacing = 6.0;
                  final availableWidth =
                      constraints.maxWidth -
                      (horizontalPadding * 2) -
                      (diceSpacing * 4);
                  final diceSize = (availableWidth / 5).clamp(55.0, 80.0);

                  return Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            return AnimatedDice(
                              value: currentPlayer.dice[index],
                              isKept: currentPlayer.kept[index],
                              isRolling:
                                  _isRolling && !currentPlayer.kept[index],
                              size: diceSize,
                              onTap: canToggleKept
                                  ? () => ref
                                        .read(yachtDiceGameProvider.notifier)
                                        .toggleKeepDie(index)
                                  : null,
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        if (canToggleKept)
                          Text(
                            l10n.yd_tapToKeep,
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              // Roll button
              if (canRoll && !isAiTurn)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: _performRoll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.themeAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      l10n.yd_rollDice,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

              // Phase indicator
              if (canSelectCategory && !isAiTurn)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.yd_selectCategory,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),

              // Score card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: secondaryColor),
                  ),
                  child: _buildScoreCard(
                    currentPlayer,
                    canSelectCategory,
                    primaryColor,
                    secondaryColor,
                  ),
                ),
              ),

              // All players scores
              if (state.players.length > 1)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: surfaceColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: state.players.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final player = entry.value;
                      final isCurrent = idx == state.currentPlayerIndex;
                      return GestureDetector(
                        onTap: () => showScoreDetailModal(context, player),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? context.themeAccent.withAlpha(50)
                                : null,
                            borderRadius: BorderRadius.circular(4),
                            border: isCurrent
                                ? Border.all(color: context.themeAccent)
                                : null,
                          ),
                          child: Text(
                            '${player.name}: ${player.totalScore}',
                            style: TextStyle(
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
