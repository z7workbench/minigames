import 'dart:async';
import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../models/enums.dart';
import '../utils/card_utils.dart';
import 'hand_widget.dart';

/// Pass phase UI with card selection and timer
class PassPhaseWidget extends StatefulWidget {
  final List<PlayingCard> hand;
  final PassDirection direction;
  final TimerOption timerOption;
  final Function(List<PlayingCard>) onCardsSelected;
  final VoidCallback? onCancel;

  const PassPhaseWidget({
    super.key,
    required this.hand,
    required this.direction,
    required this.timerOption,
    required this.onCardsSelected,
    this.onCancel,
  });

  @override
  State<PassPhaseWidget> createState() => _PassPhaseWidgetState();
}

class _PassPhaseWidgetState extends State<PassPhaseWidget> {
  final Set<PlayingCard> _selectedCards = {};
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    if (widget.timerOption == TimerOption.unlimited) {
      _remainingSeconds = -1; // -1 indicates unlimited
      return;
    }

    _remainingSeconds = _getTimerSeconds(widget.timerOption);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        // Time's up - auto-submit with whatever is selected
        _autoSubmit();
      }
    });
  }

  int _getTimerSeconds(TimerOption option) {
    switch (option) {
      case TimerOption.unlimited:
        return -1;
      case TimerOption.seconds15:
        return 15;
      case TimerOption.seconds20:
        return 20;
      case TimerOption.seconds30:
        return 30;
    }
  }

  void _autoSubmit() {
    _timer?.cancel();

    // If less than 3 selected, auto-select highest remaining cards
    if (_selectedCards.length < 3) {
      final remaining = widget.hand
          .where((c) => !_selectedCards.contains(c))
          .toList();
      remaining.sort((a, b) => CardUtils.compareByRank(b, a));

      while (_selectedCards.length < 3 && remaining.isNotEmpty) {
        _selectedCards.add(remaining.removeAt(0));
      }
    }

    widget.onCardsSelected(_selectedCards.toList());
  }

  void _toggleCard(PlayingCard card) {
    setState(() {
      if (_selectedCards.contains(card)) {
        _selectedCards.remove(card);
      } else if (_selectedCards.length < 3) {
        _selectedCards.add(card);
      }
    });
  }

  void _confirmPass() {
    if (_selectedCards.length == 3) {
      _timer?.cancel();
      widget.onCardsSelected(_selectedCards.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Direction header
          _buildDirectionHeader(context, isDark, l10n),

          const SizedBox(height: 16),

          // Instructions
          Text(
            l10n.hearts_selectCardsToPass(3),
            style: TextStyle(color: context.themeTextSecondary, fontSize: 14),
          ),

          const SizedBox(height: 8),

          // Selected count
          Text(
            '${_selectedCards.length}/3',
            style: TextStyle(
              color: context.themeAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Card selection
          HandWidget(
            cards: widget.hand,
            selectedCards: _selectedCards,
            isSelectable: true,
            maxSelectable: 3,
            onCardTap: _toggleCard,
          ),

          const SizedBox(height: 16),

          // Timer
          if (widget.timerOption != TimerOption.unlimited)
            _buildTimerBar(context, isDark, l10n),

          const SizedBox(height: 16),

          // Confirm button
          WoodenButton(
            text: l10n.hearts_confirmPass,
            icon: Icons.send,
            variant: WoodenButtonVariant.primary,
            size: WoodenButtonSize.large,
            expandWidth: true,
            onPressed: _selectedCards.length == 3 ? _confirmPass : null,
          ),

          // Cancel button (optional)
          if (widget.onCancel != null) ...[
            const SizedBox(height: 8),
            WoodenButton(
              text: l10n.cancel,
              variant: WoodenButtonVariant.ghost,
              expandWidth: true,
              onPressed: widget.onCancel,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDirectionHeader(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final directionText = _getDirectionText(l10n);
    final directionIcon = _getDirectionIcon();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeAccent.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(directionIcon, color: context.themeAccent, size: 24),
          const SizedBox(width: 8),
          Text(
            directionText,
            style: TextStyle(
              color: context.themeAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBar(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final totalSeconds = _getTimerSeconds(widget.timerOption);
    final progress = _remainingSeconds / totalSeconds;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: context.themeBorder,
            valueColor: AlwaysStoppedAnimation(
              _remainingSeconds <= 5 ? context.themeError : context.themeAccent,
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.hearts_passTimer(_remainingSeconds),
          style: TextStyle(
            color: _remainingSeconds <= 5
                ? context.themeError
                : context.themeTextSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getDirectionText(AppLocalizations l10n) {
    switch (widget.direction) {
      case PassDirection.left:
        return l10n.hearts_passLeft;
      case PassDirection.right:
        return l10n.hearts_passRight;
      case PassDirection.across:
        return l10n.hearts_passAcross;
      case PassDirection.none:
        return l10n.hearts_passHold;
    }
  }

  IconData _getDirectionIcon() {
    switch (widget.direction) {
      case PassDirection.left:
        return Icons.arrow_back;
      case PassDirection.right:
        return Icons.arrow_forward;
      case PassDirection.across:
        return Icons.swap_horiz;
      case PassDirection.none:
        return Icons.block;
    }
  }
}
