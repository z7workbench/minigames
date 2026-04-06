import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';

/// Displays the battle log with scrollable message history.
class BattleLog extends StatelessWidget {
  /// List of log messages.
  final List<String> messages;

  /// Maximum height of the log.
  final double maxHeight;

  const BattleLog({super.key, required this.messages, this.maxHeight = 120});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.themeCard,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  size: 16,
                  color: context.themeTextSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  '战斗日志',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: context.themeTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      '战斗开始...',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.themeTextSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = messages.length - 1 - index;
                      final message = messages[reversedIndex];
                      return _buildLogItem(
                        context,
                        message,
                        reversedIndex == messages.length - 1,
                        isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(
    BuildContext context,
    String message,
    bool isLatest,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isLatest
            ? context.themeAccent.withAlpha(30)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 5, right: 8),
            decoration: BoxDecoration(
              color: isLatest
                  ? context.themeAccent
                  : context.themeTextSecondary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: isLatest
                    ? context.themeTextPrimary
                    : context.themeTextSecondary,
                fontWeight: isLatest ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
