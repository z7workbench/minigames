import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/game_type.dart';
import '../../models/game_category.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/category_provider.dart';
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
/// Supports two sort modes:
/// - Category mode: Games grouped by category with reorderable sections
/// - Release time mode: Games sorted by release date, recent releases highlighted
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundColor = context.themeBackground;

    final favorites = ref.watch(favoritesProvider);
    final sortSettings = ref.watch(sortSettingsProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: WoodenAppBar(
        titleText: l10n.appTitle,
        actions: [
          // Sort button - shows dropdown menu on tap
          PopupMenuButton<SortMode>(
            key: ValueKey('sort_menu_${l10n.localeName}'), // Force rebuild on locale change
            initialValue: sortSettings.sortMode,
            onSelected: (mode) {
              ref.read(sortSettingsProvider.notifier).setSortMode(mode);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortMode.category,
                child: Row(
                  children: [
                    Expanded(child: Text(l10n.sort_by_category)),
                    if (sortSettings.sortMode == SortMode.category)
                      Icon(Icons.check, color: context.themeAccent, size: 18),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortMode.releaseTime,
                child: Row(
                  children: [
                    Expanded(child: Text(l10n.sort_by_release_time)),
                    if (sortSettings.sortMode == SortMode.releaseTime)
                      Icon(Icons.check, color: context.themeAccent, size: 18),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.sort, color: context.themeOnPrimary, size: 20),
            tooltip: l10n.sort_by_category,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.themeBorder, width: 1),
            ),
            elevation: 8,
            color: context.themeCard,
          ),
          // Settings icon
          IconButton(
            icon: Icon(Icons.settings, color: context.themeOnPrimary),
            onPressed: () => _navigateToSettings(context),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: sortSettings.sortMode == SortMode.category
          ? _buildCategoryModeBody(l10n, sortSettings, favorites)
          : _buildReleaseTimeModeBody(l10n, favorites),
    );
  }

  /// Build body for category mode: grouped sections with reorderable categories
  Widget _buildCategoryModeBody(
    AppLocalizations l10n,
    SortSettingsModel settings,
    Set<GameType> favorites,
  ) {
    final orderedCategories = settings.categoryOrder;
    final hasFavorites = favorites.isNotEmpty;

    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        // Adjust indices if favorites section exists at top
        int adjustedOld = oldIndex;
        int adjustedNew = newIndex;
        if (hasFavorites) {
          if (adjustedOld == 0 || adjustedNew == 0) return; // Can't reorder favorites
          adjustedOld -= 1;
          adjustedNew -= 1;
        }
        if (adjustedNew > adjustedOld) adjustedNew -= 1;
        ref.read(sortSettingsProvider.notifier).reorderCategory(adjustedOld, adjustedNew);
      },
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          elevation: 0,
          child: child,
        );
      },
      children: [
        // Favorites section first (if any)
        if (hasFavorites)
          Container(
            key: const ValueKey('favorites'),
            child: _buildFavoritesSection(l10n, favorites),
          ),

        // Category sections
        for (int i = 0; i < orderedCategories.length; i++)
          Container(
            key: ValueKey(orderedCategories[i].name),
            child: Column(
              children: [
                _buildCategoryHeader(orderedCategories[i], i, l10n),
                _buildGameGrid(context, orderedCategories[i].gameTypes, l10n, nested: true),
              ],
            ),
          ),
      ],
    );
  }

  /// Build body for release time mode: sorted by release date, recent releases at top
  Widget _buildReleaseTimeModeBody(
    AppLocalizations l10n,
    Set<GameType> favorites,
  ) {
    final hasFavorites = favorites.isNotEmpty;
    
    // Games sorted by release date (ascending - earliest first)
    final allGames = GameType.values.toList();
    allGames.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    
    // Recent releases (top 2 most recent) - reactionTest and aimTest
    final recentGames = [GameType.reactionTest, GameType.aimTest];
    
    // All other games (excluding only recent releases, keeping favorites)
    final otherGames = allGames.where((g) => !recentGames.contains(g)).toList();

    return ListView(
      children: [
        if (hasFavorites) _buildFavoritesSection(l10n, favorites),
        _buildRecentReleasesSection(l10n),
        _buildAllGamesSection(l10n, otherGames),
      ],
    );
  }

  /// Build the all games section with header
  Widget _buildAllGamesSection(AppLocalizations l10n, List<GameType> games) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.games, color: context.themeAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.category_all_games,
                  style: TextStyle(
                    color: context.themeTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.favorites_count(games.length),
                  style: TextStyle(
                    color: context.themeTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _buildGameGrid(context, games, l10n, nested: true),
        ],
      ),
    );
  }

  /// Build the recent releases section
  Widget _buildRecentReleasesSection(AppLocalizations l10n) {
    final recentGames = [
      GameType.reactionTest,
      GameType.aimTest,
    ];
    
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.new_releases, color: context.themeAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.category_recent,
                  style: TextStyle(
                    color: context.themeTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.recent_count(2),
                  style: TextStyle(
                    color: context.themeTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _buildGameGrid(context, recentGames, l10n, nested: true),
        ],
      ),
    );
  }

  /// Build the favorites section at the top
  Widget _buildFavoritesSection(AppLocalizations l10n, Set<GameType> favorites) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row (with same padding as category headers)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.favorite, color: context.themeError, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.category_favorites,
                  style: TextStyle(
                    color: context.themeTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.favorites_count(favorites.length),
                  style: TextStyle(
                    color: context.themeTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Game grid (with standard padding)
          _buildGameGrid(context, favorites.toList(), l10n, nested: true),
        ],
      ),
    );
  }

  /// Build category section header with drag handle
  Widget _buildCategoryHeader(
    GameCategory category,
    int index,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Drag handle (wrapped in ReorderableDragStartListener)
          ReorderableDragStartListener(
            index: index + 1, // +1 because favorites section takes index 0
            child: Icon(Icons.drag_handle, size: 20, color: context.themeDisabled),
          ),
          const SizedBox(width: 8),
          Icon(category.icon, size: 20, color: context.themeAccent),
          const SizedBox(width: 8),
          Text(
            category.displayName(l10n),
            style: TextStyle(
              color: context.themeTextPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.favorites_count(category.gameTypes.length),
            style: TextStyle(
              color: context.themeTextSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the scrollable grid of game cards with responsive layout.
  ///
  /// When [nested] is true (inside ReorderableListView/ListView),
  /// uses shrinkWrap and NeverScrollableScrollPhysics to avoid scroll conflicts.
  Widget _buildGameGrid(
    BuildContext context,
    List<GameType> games,
    AppLocalizations l10n, {
    required bool nested,
  }) {
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

        final favorites = ref.read(favoritesProvider);

        return GridView.builder(
          shrinkWrap: nested,
          physics: nested ? const NeverScrollableScrollPhysics() : null,
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

            return GameCard(
              gameType: game,
              title: _getGameTitle(l10n, game),
              description: _getGameDescription(l10n, game),
              isFavorite: favorites.contains(game),
              onToggleFavorite: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(game);
              },
              onTap: () => _navigateToGame(context, game),
            );
          },
        );
      },
    );
  }
}
