import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import 'models/reaction_test_state.dart';
import 'reaction_test_provider.dart';

class ReactionTestScreen extends ConsumerStatefulWidget {
  const ReactionTestScreen({super.key});

  @override
  ConsumerState<ReactionTestScreen> createState() =>
      _ReactionTestScreenState();
}

class _ReactionTestScreenState extends ConsumerState<ReactionTestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reactionTestGameProvider.notifier).startGame();
    });
  }

  Color _getBackgroundColor(ReactionTestState state) {
    return state.status == ReactionTestStatus.colorChanged
        ? state.afterColor
        : state.beforeColor;
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  Color _getContrastingIconColor(Color backgroundColor) {
    return _getContrastingTextColor(backgroundColor);
  }

  void _showResultsDialog(BuildContext context, ReactionTestState state) {
    final l10n = AppLocalizations.of(context)!;
    final reactionTimes = state.reactionTimes;
    final average = state.averageReactionTime;
    final best = reactionTimes.reduce((a, b) => a < b ? a : b);
    final worst = reactionTimes.reduce((a, b) => a > b ? a : b);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(dialogContext).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.rt_results,
                style: Theme.of(dialogContext).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(dialogContext).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(dialogContext).colorScheme.outline.withAlpha(50),
                  ),
                ),
                child: Column(
                  children: [
                    ...List.generate(reactionTimes.length, (index) {
                      final isLast = index == reactionTimes.length - 1;
                      final time = reactionTimes[index];
                      final isBest = time == best;
                      final isWorst = time == worst;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: isLast
                              ? null
                              : Border(
                                  bottom: BorderSide(
                                    color: Theme.of(dialogContext)
                                        .colorScheme
                                        .outline
                                        .withAlpha(30),
                                  ),
                                ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${index + 1}',
                              style: Theme.of(dialogContext).textTheme.bodyLarge,
                            ),
                            Row(
                              children: [
                                if (isBest)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Theme.of(dialogContext)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                if (isWorst)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.warning_amber,
                                      size: 16,
                                      color: Theme.of(dialogContext)
                                          .colorScheme
                                          .error,
                                    ),
                                  ),
                                Text(
                                  '$time ms',
                                  style: Theme.of(dialogContext)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isBest
                                            ? Theme.of(dialogContext)
                                                .colorScheme
                                                .primary
                                            : isWorst
                                                ? Theme.of(dialogContext)
                                                    .colorScheme
                                                    .error
                                                : null,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(dialogContext)
                            .colorScheme
                            .primary
                            .withAlpha(25),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.rt_average,
                            style: Theme.of(dialogContext)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '$average ms',
                            style: Theme.of(dialogContext)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(dialogContext).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatChip(
                    icon: Icons.star,
                    label: l10n.rt_best,
                    value: '$best ms',
                    color: Theme.of(dialogContext).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  _StatChip(
                    icon: Icons.warning_amber,
                    label: l10n.rt_worst,
                    value: '$worst ms',
                    color: Theme.of(dialogContext).colorScheme.error,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text(l10n.quit),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      ref.read(reactionTestGameProvider.notifier).startGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(dialogContext).colorScheme.primary,
                      foregroundColor:
                          Theme.of(dialogContext).colorScheme.onPrimary,
                    ),
                    child: Text(l10n.newGame),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(reactionTestGameProvider);
    final status = gameState.status;
    final backgroundColor = _getBackgroundColor(gameState);
    final textColor = _getContrastingTextColor(backgroundColor);

    if (status == ReactionTestStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showResultsDialog(context, gameState);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _getContrastingIconColor(backgroundColor)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: backgroundColor.withAlpha(180),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          if (status == ReactionTestStatus.colorChanged) {
            ref.read(reactionTestGameProvider.notifier).recordReaction();
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: backgroundColor,
          child: SafeArea(
            child: Center(
              child: AnimatedSwitcher(
                duration: Duration.zero,
                child: _buildContent(context, gameState, status, textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ReactionTestState state,
    ReactionTestStatus status,
    Color textColor,
  ) {
    switch (status) {
      case ReactionTestStatus.idle:
      case ReactionTestStatus.waiting:
        return _buildWaitingContent(context, state, textColor);
      case ReactionTestStatus.colorChanged:
        return _buildTapNowContent(context, textColor);
      case ReactionTestStatus.testing:
        return _buildTestingContent(context, state, textColor);
      case ReactionTestStatus.completed:
        return _buildCompletedContent(context, state, textColor);
    }
  }

  Widget _buildWaitingContent(
    BuildContext context,
    ReactionTestState state,
    Color textColor,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          size: 64,
          color: textColor,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.rt_testNumber(state.currentTestNumber, 5),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.rt_waitForIt,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: textColor.withAlpha(179),
          ),
        ),
      ],
    );
  }

  Widget _buildTapNowContent(BuildContext context, Color textColor) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.touch_app,
          size: 80,
          color: textColor,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.rt_tapNow,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTestingContent(
    BuildContext context,
    ReactionTestState state,
    Color textColor,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final lastReactionTime =
        state.reactionTimes.isNotEmpty ? state.reactionTimes.last : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 64,
          color: textColor,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.rt_reactionTime(lastReactionTime),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.rt_waitForIt,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: textColor.withAlpha(179),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedContent(
    BuildContext context,
    ReactionTestState state,
    Color textColor,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.flag,
          size: 64,
          color: textColor,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.rt_results,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.rt_average}: ${state.averageReactionTime} ms',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: textColor.withAlpha(179),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
