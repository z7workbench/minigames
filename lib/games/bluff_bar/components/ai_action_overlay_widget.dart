import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';

enum AiActionType { playCards, challenge }

class AiActionOverlayWidget extends StatefulWidget {
  final String playerName; // 东/西/北
  final AiActionType actionType;
  final int cardCount; // Cards played or challenged
  final String targetPlayerName; // Who was challenged (for challenge action)
  final VoidCallback? onComplete;

  const AiActionOverlayWidget({
    super.key,
    required this.playerName,
    required this.actionType,
    required this.cardCount,
    this.targetPlayerName = '',
    this.onComplete,
  });

  @override
  State<AiActionOverlayWidget> createState() => _AiActionOverlayWidgetState();
}

class _AiActionOverlayWidgetState extends State<AiActionOverlayWidget> {
  @override
  void initState() {
    super.initState();
    // Auto dismiss after 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.themeBackground.withAlpha(180),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: context.themeSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.themeAccent, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AI icon
              Icon(Icons.smart_toy, size: 40, color: context.themeAccent),
              const SizedBox(height: 16),
              
              // Player name
              Text(
                widget.playerName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.themeTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Action text
              if (widget.actionType == AiActionType.playCards)
                Text(
                  '出了 ${widget.cardCount} 张牌',
                  style: TextStyle(
                    fontSize: 18,
                    color: context.themeAccent,
                  ),
                )
              else if (widget.actionType == AiActionType.challenge)
                Text(
                  '质疑 ${widget.targetPlayerName} 的 ${widget.cardCount} 张牌',
                  style: TextStyle(
                    fontSize: 18,
                    color: context.themeError,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
