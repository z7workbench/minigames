// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../models/keyword.dart';

/// 关键词弹窗
/// 点击带有粗体标记的关键词文字时弹出，显示关键词的详细解释
class KeywordPopup extends StatelessWidget {
  final Keyword keyword;
  final VoidCallback onClose;

  const KeywordPopup({super.key, required this.keyword, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onClose,
      child: Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [context.themeCard, context.themeSurface],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.themeAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: context.themeAccent.withAlpha(100),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 标题栏
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.themeAccent,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(_getKeywordIcon(), color: Colors.black, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getLocalizedName(l10n),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                keyword.englishName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withAlpha(180),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: onClose,
                        ),
                      ],
                    ),
                  ),
                  // 内容区
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 关键词描述
                        Text(
                          l10n.db_fieldEffect,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: context.themeAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getLocalizedDescription(l10n),
                          style: TextStyle(
                            fontSize: 16,
                            color: context.themeTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 示例
                        Text(
                          '示例',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: context.themeAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.themeSurface.withAlpha(100),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: context.themeBorder),
                          ),
                          child: Text(
                            keyword.example,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: context.themeTextSecondary,
                            ),
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

  String _getLocalizedName(AppLocalizations l10n) {
    switch (keyword) {
      case Keyword.upgrade:
        return l10n.db_keywordUpgrade;
      case Keyword.instant:
        return l10n.db_keywordInstant;
      case Keyword.perfectBlock:
        return l10n.db_keywordPerfectBlock;
      case Keyword.disrupt:
        return l10n.db_keywordDisrupt;
      case Keyword.combo:
        return l10n.db_keywordCombo;
    }
  }

  String _getLocalizedDescription(AppLocalizations l10n) {
    switch (keyword) {
      case Keyword.upgrade:
        return l10n.db_keywordUpgradeDesc;
      case Keyword.instant:
        return l10n.db_keywordInstantDesc;
      case Keyword.perfectBlock:
        return l10n.db_keywordPerfectBlockDesc;
      case Keyword.disrupt:
        return l10n.db_keywordDisruptDesc;
      case Keyword.combo:
        return l10n.db_keywordComboDesc;
    }
  }

  IconData _getKeywordIcon() {
    switch (keyword) {
      case Keyword.upgrade:
        return Icons.upgrade;
      case Keyword.instant:
        return Icons.flash_on;
      case Keyword.perfectBlock:
        return Icons.shield;
      case Keyword.disrupt:
        return Icons.warning;
      case Keyword.combo:
        return Icons.repeat;
    }
  }
}

/// 可点击的关键词文本
/// 显示为带下划线的琥珀色粗体文字，点击后弹出关键词说明弹窗
class KeywordText extends StatelessWidget {
  final String text;
  final Keyword keyword;
  final TextStyle? style;

  const KeywordText({
    super.key,
    required this.text,
    required this.keyword,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopup(context),
      child: Text(
        _getLocalizedName(context),
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
          color: context.themeAccent,
          decoration: TextDecoration.underline,
          decorationColor: context.themeAccent,
        ),
      ),
    );
  }

  String _getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (keyword) {
      case Keyword.upgrade:
        return l10n.db_keywordUpgrade;
      case Keyword.instant:
        return l10n.db_keywordInstant;
      case Keyword.perfectBlock:
        return l10n.db_keywordPerfectBlock;
      case Keyword.disrupt:
        return l10n.db_keywordDisrupt;
      case Keyword.combo:
        return l10n.db_keywordCombo;
    }
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) =>
          KeywordPopup(keyword: keyword, onClose: () => Navigator.pop(context)),
    );
  }
}
