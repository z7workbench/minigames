import 'package:flutter/material.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../models/enums.dart';
import 'card_widget.dart';

/// Full-screen overlay widget displayed during challenge resolution.
/// 
/// Shows the challenger, challenged player, revealed cards, challenge result,
/// and who will face the roulette. Automatically dismisses after 2 seconds.
class ChallengeOverlayWidget extends StatefulWidget {
  /// Name of the player who initiated the challenge (东/西/南/北)
  final String challengerName;

  /// Name of the player who was challenged
  final String challengedName;

  /// The cards that were played and are now revealed
  final List<PlayingCard> revealedCards;

  /// Result of the challenge (liar guilty or innocent)
  final ChallengeResult result;

  /// Name of the player who will face the roulette
  final String loserName;

  /// Callback when the overlay is dismissed
  final VoidCallback? onComplete;

  const ChallengeOverlayWidget({
    super.key,
    required this.challengerName,
    required this.challengedName,
    required this.revealedCards,
    required this.result,
    required this.loserName,
    this.onComplete,
  });

  @override
  State<ChallengeOverlayWidget> createState() => _ChallengeOverlayWidgetState();
}

class _ChallengeOverlayWidgetState extends State<ChallengeOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup entrance animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isLiar => widget.result == ChallengeResult.liarGuilty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: context.themeBackground.withAlpha(200),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.themeSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isLiar ? context.themeError : context.themeSuccess,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isLiar ? context.themeError : context.themeSuccess)
                        .withAlpha(100),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Challenge title
                  Text(
                    l10n.bb_challenge_title(
                      widget.challengerName,
                      widget.challengedName,
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.themeTextPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Revealed cards section
                  Text(
                    l10n.bb_revealed_cards,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.themeTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: widget.revealedCards.map((card) {
                      return CardWidget(
                        card: card,
                        isSelected: false,
                        isFaceDown: false,
                        width: 50,
                        height: 70,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Result badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _isLiar ? context.themeError : context.themeSuccess,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (_isLiar
                                  ? context.themeError
                                  : context.themeSuccess)
                              .withAlpha(80),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _isLiar ? l10n.bb_liar : l10n.bb_honest,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Loser indicator
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.themeSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: context.themeBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.gavel,
                          color: context.themeError,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.loserName} ${l10n.bb_face_roulette}',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.themeTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
