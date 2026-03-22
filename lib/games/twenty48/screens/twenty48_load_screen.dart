import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/wooden_colors.dart';
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
  List<Twenty48Save> _saves = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSaves();
  }

  Future<void> _loadSaves() async {
    final saves = await ref.read(twenty48GameProvider.notifier).getAllSaves();
    if (mounted) {
      setState(() {
        _saves = saves;
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

  Future<void> _deleteSave(Twenty48Save save) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Save'),
        content: const Text('Are you sure you want to delete this save?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(twenty48GameProvider.notifier).deleteSave(save.slotIndex);
      _loadSaves();
    }
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? WoodenColors.darkBackground
        : WoodenColors.lightBackground;
    final surfaceColor = isDark
        ? WoodenColors.darkSurface
        : WoodenColors.lightSurface;
    final textPrimaryColor = isDark
        ? WoodenColors.darkTextPrimary
        : WoodenColors.lightTextPrimary;
    final textSecondaryColor = isDark
        ? WoodenColors.darkTextSecondary
        : WoodenColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.t48_loadGame),
        backgroundColor: isDark
            ? WoodenColors.darkPrimary
            : WoodenColors.lightPrimary,
        foregroundColor: isDark
            ? WoodenColors.darkOnPrimary
            : WoodenColors.lightOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: l10n.back,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _saves.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_off, size: 64, color: textSecondaryColor),
                  const SizedBox(height: 16),
                  Text(
                    l10n.t48_noSaves,
                    style: TextStyle(color: textSecondaryColor, fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _saves.length,
              itemBuilder: (context, index) {
                final save = _saves[index];
                final dateFormat = DateFormat.yMd().add_jm();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? WoodenColors.darkBorder
                          : WoodenColors.lightBorder,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? WoodenColors.darkShadow.withAlpha(100)
                            : WoodenColors.lightShadow.withAlpha(100),
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
                            // Max tile display
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? WoodenColors.darkCard
                                    : WoodenColors.lightCard,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${save.maxTile}',
                                  style: TextStyle(
                                    fontSize: save.maxTile >= 1000 ? 16 : 20,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimaryColor,
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
                                  Text(
                                    l10n.t48_saveSlot(save.slotIndex + 1),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${l10n.score}: ${save.score}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textSecondaryColor,
                                    ),
                                  ),
                                  Text(
                                    l10n.t48_savedAt(
                                      dateFormat.format(save.savedAt),
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delete button
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: isDark
                                    ? WoodenColors.darkError
                                    : WoodenColors.lightError,
                              ),
                              onPressed: () => _deleteSave(save),
                              tooltip: l10n.t48_delete,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
