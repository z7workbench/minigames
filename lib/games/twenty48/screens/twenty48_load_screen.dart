import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../twenty48_provider.dart';
import '../twenty48_screen.dart';
import '../models/twenty48_state.dart';

/// Screen for loading saved games.
class Twenty48LoadScreen extends ConsumerStatefulWidget {
  /// Creates the load screen.
  const Twenty48LoadScreen({super.key});

  @override
  ConsumerState<Twenty48LoadScreen> createState() => _Twenty48LoadScreenState();
}

class _Twenty48LoadScreenState extends ConsumerState<Twenty48LoadScreen> {
  Twenty48Save? _autoSave;
  List<Twenty48Save> _manualSaves = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSaves();
  }

  Future<void> _loadSaves() async {
    final autoSave = await ref
        .read(twenty48GameProvider.notifier)
        .getAutoSave();
    final manualSaves = await ref
        .read(twenty48GameProvider.notifier)
        .getManualSaves();
    if (mounted) {
      setState(() {
        _autoSave = autoSave;
        _manualSaves = manualSaves;
        _isLoading = false;
      });
    }
  }

  void _loadSave(Twenty48Save save) {
    final state = Twenty48State.fromJson(
      Map<String, dynamic>.from(
        const JsonCodec().decode(save.gameStateJson) as Map,
      ),
    );
    ref.read(twenty48GameProvider.notifier).loadGame(state);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Twenty48Screen()),
    );
  }

  Future<void> _deleteSave(Twenty48Save save, bool isAutoSave) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t48_delete),
        content: Text(
          isAutoSave
              ? '${l10n.t48_autoSave} - ${l10n.t48_delete}?'
              : '${l10n.t48_saveSlot(save.slotIndex)} - ${l10n.t48_delete}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.t48_delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(twenty48GameProvider.notifier).deleteSave(save.slotIndex);
      _loadSaves();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    final dateFormat = DateFormat.yMd().add_jm();

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        title: Text(l10n.t48_loadGame),
        backgroundColor: themeColors.primary,
        foregroundColor: themeColors.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: l10n.back,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_autoSave == null && _manualSaves.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_off,
                    size: 64,
                    color: themeColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.t48_noSaves,
                    style: TextStyle(
                      color: themeColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Auto-save section (if exists)
                if (_autoSave != null)
                  _buildSaveCard(
                    context,
                    _autoSave!,
                    l10n,
                    dateFormat,
                    themeColors,
                    isAutoSave: true,
                  ),

                // Divider between auto-save and manual saves
                if (_autoSave != null && _manualSaves.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: themeColors.divider),
                  ),

                // Manual saves
                ..._manualSaves.map(
                  (save) => _buildSaveCard(
                    context,
                    save,
                    l10n,
                    dateFormat,
                    themeColors,
                    isAutoSave: false,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSaveCard(
    BuildContext context,
    Twenty48Save save,
    AppLocalizations l10n,
    DateFormat dateFormat,
    dynamic themeColors, {
    required bool isAutoSave,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAutoSave ? themeColors.accent : themeColors.border,
          width: isAutoSave ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeColors.shadow.withAlpha(100),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _loadSave(save),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon/Max tile display
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isAutoSave
                        ? themeColors.accent.withAlpha(30)
                        : themeColors.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: isAutoSave
                        ? Icon(
                            Icons.history,
                            size: 32,
                            color: themeColors.accent,
                          )
                        : Text(
                            '${save.maxTile}',
                            style: TextStyle(
                              fontSize: save.maxTile >= 1000 ? 16 : 20,
                              fontWeight: FontWeight.bold,
                              color: themeColors.textPrimary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Save info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isAutoSave
                                ? l10n.t48_autoSave
                                : l10n.t48_saveSlot(save.slotIndex),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: themeColors.textPrimary,
                            ),
                          ),
                          if (isAutoSave)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.info_outline,
                                size: 16,
                                color: themeColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.score}: ${save.score}',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeColors.textSecondary,
                        ),
                      ),
                      if (!isAutoSave)
                        Text(
                          '${l10n.t48_maxTile}: ${save.maxTile}',
                          style: TextStyle(
                            fontSize: 12,
                            color: themeColors.textSecondary,
                          ),
                        ),
                      Text(
                        l10n.t48_savedAt(dateFormat.format(save.savedAt)),
                        style: TextStyle(
                          fontSize: 12,
                          color: themeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  icon: Icon(Icons.delete_outline, color: themeColors.error),
                  onPressed: () => _deleteSave(save, isAutoSave),
                  tooltip: l10n.t48_delete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
