import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minigames/games/hit_and_blow/components/game_result_dialog.dart';
import 'package:minigames/games/hit_and_blow/components/guess_history_item.dart';
import 'package:minigames/games/hit_and_blow/components/number_selector.dart';
import 'package:minigames/games/hit_and_blow/hit_and_blow_provider.dart';
import 'package:minigames/games/hit_and_blow/models/hit_and_blow_state.dart';
import 'package:minigames/l10n/generated/app_localizations.dart';
import 'package:minigames/ui/theme/theme_colors.dart';

class HitAndBlowScreen extends ConsumerStatefulWidget {
  final Difficulty difficulty;
  final bool allowDuplicates;

  const HitAndBlowScreen({
    super.key,
    required this.difficulty,
    this.allowDuplicates = false,
  });

  @override
  ConsumerState<HitAndBlowScreen> createState() => _HitAndBlowScreenState();
}

class _HitAndBlowScreenState extends ConsumerState<HitAndBlowScreen> {
  final List<int> currentGuess = [];
  late Difficulty currentDifficulty;
  late bool currentAllowDuplicates;
  bool _resultDialogShown = false;

  @override
  void initState() {
    super.initState();
    currentDifficulty = widget.difficulty;
    currentAllowDuplicates = widget.allowDuplicates;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGame(currentDifficulty);
    });
  }

  void _startGame(Difficulty difficulty) {
    currentDifficulty = difficulty;
    ref.read(hitAndBlowStateProviderProvider.notifier).startGame(
      difficulty,
      allowDuplicates: currentAllowDuplicates,
    );
    setState(() {
      currentGuess.clear();
      _resultDialogShown = false;
    });
  }

  void _selectNumber(int number) {
    final state = ref.read(hitAndBlowStateProviderProvider);
    final targetLength = currentDifficulty == Difficulty.easy ? 4 : 6;

    if (state.status != GameStatus.playing) return;
    if (currentGuess.length >= targetLength) return;
    if (!currentAllowDuplicates && currentGuess.contains(number)) return;

    setState(() {
      currentGuess.add(number);
    });
  }

  void _clearLastNumber() {
    if (currentGuess.isNotEmpty) {
      setState(() {
        currentGuess.removeLast();
      });
    }
  }

  void _submitGuess() {
    final state = ref.read(hitAndBlowStateProviderProvider);
    if (state.status != GameStatus.playing) return;

    final targetLength = currentDifficulty == Difficulty.easy ? 4 : 6;
    if (currentGuess.length < targetLength) return;

    ref
        .read(hitAndBlowStateProviderProvider.notifier)
        .submitGuess(List.from(currentGuess));
    setState(() {
      currentGuess.clear();
    });
  }

  void _showResultDialog(BuildContext context, HitAndBlowState state) {
    if (_resultDialogShown) return;
    _resultDialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => GameResultDialog(
        isWin: state.status == GameStatus.won,
        attempts: state.attemptsUsed,
        duration: state.duration!,
        targetNumber: state.status == GameStatus.lost ? state.targetNumber : null,
        onPlayAgain: () {
          Navigator.of(dialogContext).pop();
          _startGame(currentDifficulty);
        },
        onGoHome: () {
          Navigator.of(dialogContext).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final state = ref.watch(hitAndBlowStateProviderProvider);

    // Show result dialog when game ends
    if ((state.status == GameStatus.won || state.status == GameStatus.lost) &&
        state.duration != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showResultDialog(context, state);
      });
    }

    final targetLength = currentDifficulty == Difficulty.easy ? 4 : 6;
    final maxDigit = currentDifficulty == Difficulty.easy ? 6 : 8;

    return Scaffold(
      backgroundColor: context.themeBackground,
      appBar: AppBar(
        title: Text(localization.game_hit_and_blow),
        backgroundColor: context.themePrimary,
        foregroundColor: context.themeOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Current guess display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.themeSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.themeBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(targetLength, (index) {
                    final hasValue = index < currentGuess.length;
                    final value = hasValue ? currentGuess[index] : 0;

                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: hasValue
                            ? context.themePrimary
                            : context.themeCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.themeBorder),
                      ),
                      child: Center(
                        child: Text(
                          hasValue ? value.toString() : '',
                          style: TextStyle(
                            color: hasValue
                                ? context.themeOnPrimary
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: currentGuess.length == targetLength
                    ? _submitGuess
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.themePrimary,
                  foregroundColor: context.themeOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(localization.hnb_check),
              ),
              const SizedBox(height: 16),

              // Number selector grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(maxDigit, (index) {
                  final number = index + 1;
                  final isSelected = currentGuess.contains(number);
                  final isDisabled = !currentAllowDuplicates && isSelected;
                  return NumberSelector(
                    number: number,
                    isSelected: isSelected,
                    isDisabled: isDisabled,
                    onTap: () => _selectNumber(number),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Clear button
              TextButton(
                onPressed: currentGuess.isNotEmpty ? _clearLastNumber : null,
                style: TextButton.styleFrom(
                  foregroundColor: context.themeTextSecondary,
                ),
                child: Text(localization.hnb_clear),
              ),
              const SizedBox(height: 16),

              // Attempts remaining
              Text(
                localization.hnb_attemptsFormat(
                  state.maxAttempts - state.attemptsUsed,
                  state.maxAttempts,
                ),
                style: TextStyle(
                  color: context.themeTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Guess history
              if (state.guessHistory.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.guessHistory.length,
                    itemBuilder: (context, index) {
                      return GuessHistoryItem(
                        guess: state.guessHistory[index],
                        hits: state.hitsHistory[index],
                        blows: state.blowsHistory[index],
                        targetLength: targetLength,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
