import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/game_type.dart';
import '../theme/theme_colors.dart';
import '../widgets/game_card.dart';
import '../widgets/wooden_app_bar.dart';
import 'settings_screen.dart';
import '../../games/hit_and_blow/hit_and_blow_screen.dart';
import '../../games/yacht_dice/screens/yacht_dice_start_screen.dart';
import '../../games/guess_arrangement/screens/start_screen.dart';
import '../../games/twenty48/screens/twenty48_start_screen.dart';
import '../../games/dice_battle/screens/start_screen.dart' as dice_battle;
import '../../games/mancala/screens/mancala_start_screen.dart';
import '../../games/hearts/screens/hearts_start_screen.dart';
import '../../games/bluff_bar/screens/bluff_bar_start_screen.dart';
import '../../games/reaction_test/screens/reaction_test_start_screen.dart';
import '../../games/aim_test/screens/aim_test_start_screen.dart';

/// The home screen displaying a scrollable grid of game cards.
///
/// Shows available games and placeholders in a responsive grid layout.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// Navigate to the game screen based on game type
  void _navigateToGame(BuildContext context, GameType gameType) {
    switch (gameType) {
      case GameType.hitAndBlow:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HitAndBlowScreen()),
        );
        break;
      case GameType.yachtDice:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const YachtDiceStartScreen()),
        );
        break;
      case GameType.guessArrangement:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GuessArrangementStartScreen(),
          ),
        );
        break;
      case GameType.twenty48:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Twenty48StartScreen()),
        );
        break;
      case GameType.diceBattle:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const dice_battle.DiceBattleStartScreen(),
          ),
        );
        break;
      case GameType.mancala:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MancalaStartScreen()),
        );
        break;
      case GameType.hearts:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HeartsStartScreen()),
        );
        break;
      case GameType.bluffBar:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BluffBarStartScreen()),
        );
        break;
      case GameType.reactionTest:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReactionTestStartScreen()),
        );
        break;
      case GameType.aimTest:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AimTestStartScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${gameType.displayName} - Coming in next update!'),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  /// Navigate to settings screen
  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  /// Get the localized title for a game
  String _getGameTitle(AppLocalizations l10n, GameType gameType) {
    switch (gameType) {
      case GameType.hitAndBlow:
        return l10n.game_hit_and_blow;
      case GameType.yachtDice:
        return l10n.game_yacht_dice;
      case GameType.guessArrangement:
        return l10n.game_guess_arrangement;
      case GameType.twenty48:
        return l10n.game_2048;
      case GameType.diceBattle:
        return l10n.game_dice_battle;
      case GameType.mancala:
        return l10n.game_mancala;
      case GameType.hearts:
        return l10n.hearts_game_hearts;
      case GameType.bluffBar:
        return l10n.bb_game_title;
      case GameType.reactionTest:
        return l10n.game_reaction_test;
      case GameType.aimTest:
        return l10n.game_aim_test;
      default:
        return gameType.displayName;
    }
  }

  /// Get the localized description for a game
  String _getGameDescription(AppLocalizations l10n, GameType gameType) {
    switch (gameType) {
      case GameType.hitAndBlow:
        return l10n.hnb_gameDescription;
      case GameType.yachtDice:
        return l10n.yd_gameDescription;
      case GameType.guessArrangement:
        return l10n.ga_gameDescription;
      case GameType.twenty48:
        return l10n.t48_gameDescription;
      case GameType.diceBattle:
        return l10n.db_gameDescription;
      case GameType.mancala:
        return l10n.mc_gameDescription;
      case GameType.hearts:
        return l10n.hearts_description;
      case GameType.bluffBar:
        return l10n.bb_gameDescription;
      case GameType.reactionTest:
        return l10n.rt_gameDescription;
      case GameType.aimTest:
        return l10n.at_gameDescription;
      default:
        return '${gameType.displayName} - Coming Soon!';
    }
  }

  /// Check if a game is a placeholder
  bool _isPlaceholder(GameType gameType) {
    return gameType.index >=
        10; // First 10 games are real (0-9), rest are placeholders
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundColor = context.themeBackground;

    // Get all game types
    final allGames = GameType.values;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: WoodenAppBar(
        titleText: l10n.appTitle,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: context.themeOnPrimary),
            onPressed: () => _navigateToSettings(context),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: _buildGameGrid(context, allGames, l10n),
    );
  }

  /// Build the scrollable grid of game cards with responsive layout
  Widget _buildGameGrid(
    BuildContext context,
    List<GameType> games,
    AppLocalizations l10n,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // Define card size constraints
        const double minCardWidth = 140.0;
        const double maxCardWidth = 200.0;
        const double minCardHeight = 160.0;
        const double maxCardHeight = 200.0;
        const double spacing = 16.0;
        const double horizontalPadding = 16.0;

        // Calculate number of columns based on available width
        final availableWidth = screenWidth - (horizontalPadding * 2);

        int crossAxisCount = 1;
        double cardWidth = minCardWidth;

        // Calculate how many cards can fit (try from 4 down to 1)
        for (int cols = 4; cols >= 1; cols--) {
          final possibleCardWidth =
              (availableWidth - (spacing * (cols - 1))) / cols;
          if (possibleCardWidth >= minCardWidth) {
            crossAxisCount = cols;
            cardWidth = possibleCardWidth.clamp(minCardWidth, maxCardWidth);
            break;
          }
        }

        // Calculate card height with aspect ratio
        final cardHeight = (cardWidth * 1.15).clamp(
          minCardHeight,
          maxCardHeight,
        );

        return GridView.builder(
          padding: const EdgeInsets.all(horizontalPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: cardHeight,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            final isPlaceholder = _isPlaceholder(game);

            return GameCard(
              gameType: game,
              title: _getGameTitle(l10n, game),
              description: _getGameDescription(l10n, game),
              isPlaceholder: isPlaceholder,
              comingSoonText: 'Coming Soon',
              onTap: isPlaceholder
                  ? null
                  : () => _navigateToGame(context, game),
            );
          },
        );
      },
    );
  }
}
