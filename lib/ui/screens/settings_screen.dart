import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../ui/theme/theme_provider.dart';
import '../../ui/theme/wooden_colors.dart';
import '../widgets/theme_toggle.dart';

/// Settings screen for managing app preferences.
///
/// This screen provides a wooden-styled interface for configuring:
/// - Language (English/Chinese)
/// - Dark Mode (Light/Dark/System)
/// - Sound (On/Off)
/// - Fullscreen (Desktop only)
/// - About (App version and name)
///
/// All settings persist across sessions using SharedPreferences.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await ref.read(settingsProvider.notifier).load();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Language Section
                _buildSectionCard(
                  context: context,
                  icon: Icons.language,
                  title: l10n.language,
                  child: _LanguageSetting(),
                ),

                const SizedBox(height: 16),

                // Theme Section
                _buildSectionCard(
                  context: context,
                  icon: isDark ? Icons.dark_mode : Icons.light_mode,
                  title: l10n.darkMode,
                  child: _ThemeSetting(),
                ),

                const SizedBox(height: 16),

                // Sound Section
                _buildSectionCard(
                  context: context,
                  icon: Icons.volume_up,
                  title: l10n.sound,
                  child: _SoundSetting(),
                ),

                const SizedBox(height: 16),

                // Fullscreen Section (Desktop only)
                if (_isDesktopPlatform) ...[
                  _buildSectionCard(
                    context: context,
                    icon: Icons.fullscreen,
                    title: l10n.fullscreen,
                    child: _FullscreenSetting(),
                  ),
                  const SizedBox(height: 16),
                ],

                // About Section
                _buildSectionCard(
                  context: context,
                  icon: Icons.info_outline,
                  title: l10n.about,
                  child: _AboutSetting(),
                ),

                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shadowColor: isDark ? WoodenColors.darkShadow : WoodenColors.lightShadow,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              WoodenColors.darkPrimary,
                              WoodenColors.darkSecondary,
                            ]
                          : [
                              WoodenColors.lightPrimary,
                              WoodenColors.lightSecondary,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? WoodenColors.darkBorder
                          : WoodenColors.lightBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isDark
                        ? WoodenColors.darkOnPrimary
                        : WoodenColors.lightOnPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? WoodenColors.darkTextPrimary
                        : WoodenColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  bool get _isDesktopPlatform {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
}

/// Language setting widget with dropdown selection.
class _LanguageSetting extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.language,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? WoodenColors.darkTextSecondary
                : WoodenColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark
                  ? WoodenColors.darkBorder
                  : WoodenColors.lightBorder,
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Locale?>(
              value: settings.locale,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              borderRadius: BorderRadius.circular(8),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(
                    l10n.systemTheme,
                    style: TextStyle(
                      color: isDark
                          ? WoodenColors.darkTextPrimary
                          : WoodenColors.lightTextPrimary,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(
                    l10n.english,
                    style: TextStyle(
                      color: isDark
                          ? WoodenColors.darkTextPrimary
                          : WoodenColors.lightTextPrimary,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('zh'),
                  child: Text(
                    l10n.chinese,
                    style: TextStyle(
                      color: isDark
                          ? WoodenColors.darkTextPrimary
                          : WoodenColors.lightTextPrimary,
                    ),
                  ),
                ),
              ],
              onChanged: (locale) {
                ref.read(settingsProvider.notifier).setLocale(locale);
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Theme setting widget with animated toggle and segmented options.
class _ThemeSetting extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeModeAsync = ref.watch(themeModeNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return themeModeAsync.when(
      data: (themeMode) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.theme,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? WoodenColors.darkTextSecondary
                          : WoodenColors.lightTextSecondary,
                    ),
                  ),
                ),
                // Theme toggle button
                const ThemeToggle(size: 48),
              ],
            ),
            const SizedBox(height: 12),
            // Theme mode segmented button
            _buildThemeSegmentedButton(context, ref, l10n, themeMode),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text(l10n.error),
    );
  }

  Widget _buildThemeSegmentedButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeMode currentMode,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? WoodenColors.darkSurface : WoodenColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ThemeOption(
              label: l10n.lightTheme,
              icon: Icons.light_mode,
              isSelected: currentMode == ThemeMode.light,
              onTap: () => ref
                  .read(themeModeNotifierProvider.notifier)
                  .setTheme(ThemeMode.light),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: isDark
                ? WoodenColors.darkDivider
                : WoodenColors.lightDivider,
          ),
          Expanded(
            child: _ThemeOption(
              label: l10n.darkTheme,
              icon: Icons.dark_mode,
              isSelected: currentMode == ThemeMode.dark,
              onTap: () => ref
                  .read(themeModeNotifierProvider.notifier)
                  .setTheme(ThemeMode.dark),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: isDark
                ? WoodenColors.darkDivider
                : WoodenColors.lightDivider,
          ),
          Expanded(
            child: _ThemeOption(
              label: l10n.systemTheme,
              icon: Icons.settings_suggest,
              isSelected: currentMode == ThemeMode.system,
              onTap: () => ref
                  .read(themeModeNotifierProvider.notifier)
                  .setTheme(ThemeMode.system),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual theme option button for segmented control.
class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? WoodenColors.accentAmber.withAlpha(40)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? WoodenColors.accentAmber
                  : theme.colorScheme.onSurface.withAlpha(128),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? WoodenColors.accentAmber
                    : theme.colorScheme.onSurface.withAlpha(128),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sound setting widget with toggle switch.
class _SoundSetting extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sound,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? WoodenColors.darkTextSecondary
                      : WoodenColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                settings.soundEnabled ? l10n.soundEnabled : l10n.soundDisabled,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? WoodenColors.darkTextSecondary
                      : WoodenColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: settings.soundEnabled,
          onChanged: (_) => ref.read(settingsProvider.notifier).toggleSound(),
          activeThumbColor: isDark
              ? WoodenColors.accentAmber
              : WoodenColors.lightPrimary,
        ),
      ],
    );
  }
}

/// Fullscreen setting widget with toggle switch (desktop only).
class _FullscreenSetting extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.fullscreen,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? WoodenColors.darkTextSecondary
                      : WoodenColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                settings.fullscreen ? l10n.fullscreenEnabled : 'Fullscreen Off',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? WoodenColors.darkTextSecondary
                      : WoodenColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: settings.fullscreen,
          onChanged: (_) =>
              ref.read(settingsProvider.notifier).toggleFullscreen(),
          activeThumbColor: isDark
              ? WoodenColors.accentAmber
              : WoodenColors.lightPrimary,
        ),
      ],
    );
  }
}

/// About setting widget displaying app information.
class _AboutSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [WoodenColors.accentAmber, WoodenColors.accentCopper]
                      : [
                          WoodenColors.lightPrimary,
                          WoodenColors.lightSecondary,
                        ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? WoodenColors.darkBorder
                      : WoodenColors.lightBorder,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.games,
                color: isDark
                    ? WoodenColors.darkTextPrimary
                    : WoodenColors.lightOnPrimary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? WoodenColors.darkTextPrimary
                          : WoodenColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.version} 4.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? WoodenColors.darkTextSecondary
                          : WoodenColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? WoodenColors.darkSurface.withAlpha(128)
                : WoodenColors.lightSurface.withAlpha(128),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark
                  ? WoodenColors.darkBorder.withAlpha(128)
                  : WoodenColors.lightBorder.withAlpha(128),
              width: 1,
            ),
          ),
          child: Text(
            'A collection of classic board games brought to life with beautiful wooden aesthetics.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? WoodenColors.darkTextSecondary
                  : WoodenColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
