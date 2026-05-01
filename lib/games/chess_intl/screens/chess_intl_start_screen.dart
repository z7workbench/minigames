import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/enums.dart';
import '../logic/fen_validator.dart';
import '../chess_intl_screen.dart';

class ChessIntlStartScreen extends ConsumerStatefulWidget {
  const ChessIntlStartScreen({super.key});

  @override
  ConsumerState<ChessIntlStartScreen> createState() =>
      _ChessIntlStartScreenState();
}

class _ChessIntlStartScreenState extends ConsumerState<ChessIntlStartScreen> {
  AiDifficulty _difficulty = AiDifficulty.easy;
  PieceColor _playerColor = PieceColor.white;
  PieceStyle _pieceStyle = PieceStyle.filled;
  String? _importedFen;
  String? _fenError;
  final _fenController = TextEditingController();

  void _startGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChessIntlScreen(
          difficulty: _difficulty,
          playerColor: _playerColor,
          pieceStyle: _pieceStyle,
          fen: _importedFen,
        ),
      ),
    );
  }

  void _importFen() {
    final fen = _fenController.text.trim();
    if (fen.isEmpty) {
      setState(() {
        _fenError = null;
        _importedFen = null;
      });
      return;
    }

    final (state, error) = FenValidator.parse(fen);
    if (error != null) {
      setState(() {
        _fenError = error;
        _importedFen = null;
      });
    } else {
      setState(() {
        _fenError = null;
        _importedFen = fen;
      });
    }
  }

  void _showRules() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? context.themeSurface : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.ci_howToPlay,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.themeTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRuleItem(l10n.ci_rule1Title, l10n.ci_rule1Desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.ci_rule2Title, l10n.ci_rule2Desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.ci_rule3Title, l10n.ci_rule3Desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.ci_rule4Title, l10n.ci_rule4Desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.ci_rule5Title, l10n.ci_rule5Desc),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
                    foregroundColor: isDark ? Colors.white : Colors.black,
                  ),
                  child: Text(l10n.ok),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: context.themeAccent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 13, color: context.themeTextSecondary),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.themeBackground,
      appBar: AppBar(
        title: Text(l10n.ci_gameTitle),
        backgroundColor: context.themePrimary,
        foregroundColor: context.themeOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final padding = isLandscape
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
                : const EdgeInsets.all(24);

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
                        _buildGameIcon(isDark, 80),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTitleSection(l10n)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsPanel(context, l10n),
                    const SizedBox(height: 24),
                    WoodenButton(
                      text: l10n.ci_howToPlay,
                      icon: Icons.help_outline,
                      variant: WoodenButtonVariant.outlined,
                      expandWidth: true,
                      onPressed: _showRules,
                    ),
                    const SizedBox(height: 12),
                    WoodenButton(
                      text: l10n.ci_startGame,
                      icon: Icons.play_arrow,
                      variant: WoodenButtonVariant.primary,
                      size: WoodenButtonSize.large,
                      expandWidth: true,
                      onPressed: _startGame,
                    ),
                    const SizedBox(height: 12),
                    WoodenButton(
                      text: l10n.back,
                      icon: Icons.arrow_back,
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

  Widget _buildGameIcon(bool isDark, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.themeCard, context.themeSurface],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: context.themeBorder, width: 2),
        boxShadow: [
          BoxShadow(
            color: context.themeShadow.withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '\u265A',
          style: TextStyle(fontSize: size * 0.6, color: context.themeTextPrimary),
        ),
      ),
    );
  }

  Widget _buildTitleSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.ci_gameTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.themeTextPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.ci_gameDescription,
          style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
        ),
      ],
    );
  }

  Widget _buildSettingsPanel(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.themeBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: context.themeShadow.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ci_aiDifficulty,
            style: TextStyle(
              color: context.themeTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDifficultyChip(l10n.ci_easy, AiDifficulty.easy),
              _buildDifficultyChip(l10n.ci_hard, AiDifficulty.hard),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.ci_playAs,
            style: TextStyle(
              color: context.themeTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildColorChip(l10n.ci_white, PieceColor.white),
              _buildColorChip(l10n.ci_black, PieceColor.black),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.ci_pieceStyle,
            style: TextStyle(
              color: context.themeTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStyleChip(l10n.ci_styleOutline, PieceStyle.outline),
              _buildStyleChip(l10n.ci_styleFilled, PieceStyle.filled),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.ci_importFen,
            style: TextStyle(
              color: context.themeTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ci_importFenDesc,
            style: TextStyle(
              color: context.themeTextSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _fenController,
                  style: TextStyle(
                    color: context.themeTextPrimary,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                  decoration: InputDecoration(
                    hintText: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
                    hintStyle: TextStyle(
                      color: context.themeDisabled,
                      fontSize: 11,
                    ),
                    filled: true,
                    fillColor: context.themeCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.themeBorder),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  maxLines: 2,
                  minLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _importFen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.themeAccent,
                  foregroundColor: context.themeOnAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                child: Text(l10n.ci_validate),
              ),
            ],
          ),
          if (_fenError != null) ...[
            const SizedBox(height: 8),
            Text(
              _fenError!,
              style: TextStyle(color: context.themeError, fontSize: 12),
            ),
          ],
          if (_importedFen != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: context.themeSuccess, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.ci_fenValid,
                    style: TextStyle(
                      color: context.themeSuccess,
                      fontSize: 12,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _importedFen = null;
                      _fenController.clear();
                      _fenError = null;
                    });
                  },
                  child: Icon(Icons.close, color: context.themeDisabled, size: 16),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String label, AiDifficulty difficulty) {
    final isSelected = _difficulty == difficulty;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _difficulty = difficulty;
          });
        }
      },
      selectedColor: context.themeSelectionColor,
      checkmarkColor: context.themeOnAccent,
      backgroundColor: context.themeCard,
      labelStyle: TextStyle(
        color: isSelected ? context.themeOnAccent : context.themeTextPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildColorChip(String label, PieceColor color) {
    final isSelected = _playerColor == color;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            color == PieceColor.white ? '\u2654' : '\u265A',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _playerColor = color;
          });
        }
      },
      selectedColor: context.themeSelectionColor,
      checkmarkColor: context.themeOnAccent,
      backgroundColor: context.themeCard,
      labelStyle: TextStyle(
        color: isSelected ? context.themeOnAccent : context.themeTextPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildStyleChip(String label, PieceStyle style) {
    final isSelected = _pieceStyle == style;
    final previewChar = style == PieceStyle.outline ? '\u2654' : '\u265A';
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(previewChar, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _pieceStyle = style;
          });
        }
      },
      selectedColor: context.themeSelectionColor,
      checkmarkColor: context.themeOnAccent,
      backgroundColor: context.themeCard,
      labelStyle: TextStyle(
        color: isSelected ? context.themeOnAccent : context.themeTextPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
