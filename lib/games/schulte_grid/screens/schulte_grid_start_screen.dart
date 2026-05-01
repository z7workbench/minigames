import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/database_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/schulte_grid_state.dart';
import '../schulte_grid_provider.dart';
import '../schulte_grid_screen.dart';
import '../widgets/schulte_grid_leaderboard.dart';

class SchulteGridStartScreen extends ConsumerStatefulWidget {
  const SchulteGridStartScreen({super.key});

  @override
  ConsumerState<SchulteGridStartScreen> createState() =>
      _SchulteGridStartScreenState();
}

class _SchulteGridStartScreenState
    extends ConsumerState<SchulteGridStartScreen> {
  final Map<SchulteGridSize, int?> _bestTimes = {};

  @override
  void initState() {
    super.initState();
    _loadBestTimes();
  }

  Future<void> _loadBestTimes() async {
    final dao = ref.read(gameRecordsDaoProvider);
    for (final size in SchulteGridSize.values) {
      final records =
          await dao.getTopScoresByGameType(size.gameTypeKey, limit: 1);
      if (mounted) {
        setState(() {
          _bestTimes[size] = records.isNotEmpty ? records.first.score : null;
        });
      }
    }
  }

  void _startGame(SchulteGridSize size) {
    ref.read(schulteGridGameProvider.notifier).startGame(size);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SchulteGridScreen()),
    ).then((_) {
      _loadBestTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        title: Text(l10n.sg_gameTitle),
        backgroundColor: themeColors.primary,
        foregroundColor: themeColors.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: l10n.back,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => SchulteGridLeaderboard.show(context),
            tooltip: l10n.leaderboard,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape =
                constraints.maxWidth > constraints.maxHeight;
            final padding = isLandscape
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
                : const EdgeInsets.all(24.0);

            return Center(
              child: SingleChildScrollView(
                padding: padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGameIcon(isDark, themeColors, 80),
                        const SizedBox(width: 16),
                        _buildTitleSection(
                            l10n, context, themeColors),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ...SchulteGridSize.values.map(
                      (size) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildSizeCard(
                            context, l10n, themeColors, size),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.sg_instructions,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: themeColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 24),
                    WoodenButton(
                      text: l10n.back,
                      icon: Icons.arrow_back,
                      size: WoodenButtonSize.medium,
                      variant: WoodenButtonVariant.ghost,
                      expandWidth: true,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameIcon(
      bool isDark, ThemeColorSet colors, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.card, colors.surface],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: colors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.grid_on,
        size: size * 0.5,
        color: isDark ? colors.accent : colors.secondary,
      ),
    );
  }

  Widget _buildTitleSection(
    AppLocalizations l10n,
    BuildContext context,
    ThemeColorSet colors,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.sg_gameTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.createdByMimo,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.sg_gameDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeCard(
    BuildContext context,
    AppLocalizations l10n,
    ThemeColorSet colors,
    SchulteGridSize size,
  ) {
    final best = _bestTimes[size];
    final total = size.total;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                size.label,
                style: TextStyle(
                  color: colors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sg_sizeLabel(size.dimension, total),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  best != null
                      ? '${l10n.sg_bestTime}: ${SchulteGridState.formatTime(best)}'
                      : l10n.sg_noRecord,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: best != null
                            ? colors.accent
                            : colors.textSecondary,
                        fontFamily: best != null ? 'monospace' : null,
                      ),
                ),
              ],
            ),
          ),
          WoodenButton(
            text: l10n.play,
            icon: Icons.play_arrow,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.primary,
            onPressed: () => _startGame(size),
          ),
        ],
      ),
    );
  }
}
