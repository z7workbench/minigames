import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../ui/theme/theme_colors.dart';
import '../../ui/theme/theme_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Language Section
          _buildSectionCard(
            context: context,
            icon: Icons.language,
            title: l10n.language,
            child: _LanguageSetting(context),
          ),

          const SizedBox(height: 16),

          // Theme Section (merged with Color Scheme)
          _buildSectionCard(
            context: context,
            icon: Theme.of(context).brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode,
            title: l10n.theme,
            child: _ThemeAndColorSchemeSetting(context),
          ),

          const SizedBox(height: 16),

          // Sound Section
          _buildSectionCard(
            context: context,
            icon: Icons.volume_up,
            title: l10n.sound,
            child: _SoundSetting(context),
          ),

          const SizedBox(height: 16),

          // Fullscreen Section (Desktop only)
          if (_isDesktopPlatform) ...[
            _buildSectionCard(
              context: context,
              icon: Icons.fullscreen,
              title: l10n.fullscreen,
              child: _FullscreenSetting(context),
            ),
            const SizedBox(height: 16),
          ],

          // About Section
          _buildSectionCard(
            context: context,
            icon: Icons.info_outline,
            title: l10n.about,
            child: _AboutSetting(context),
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
    return Card(
      elevation: 4,
      shadowColor: context.themeShadow,
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
                      colors: [context.themePrimary, context.themeSecondary],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.themeBorder, width: 1.5),
                  ),
                  child: Icon(icon, color: context.themeSurface, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.themeTextPrimary,
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
  final BuildContext context;

  const _LanguageSetting(this.context);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.language,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: context.themeTextSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.themeBorder, width: 1.5),
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
                    style: TextStyle(color: context.themeTextPrimary),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(
                    l10n.english,
                    style: TextStyle(color: context.themeTextPrimary),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('zh'),
                  child: Text(
                    l10n.chinese,
                    style: TextStyle(color: context.themeTextPrimary),
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

/// Combined Theme and Color Scheme setting widget.
/// Groups dark mode toggle and color scheme selection in one card.
class _ThemeAndColorSchemeSetting extends ConsumerWidget {
  final BuildContext context;

  const _ThemeAndColorSchemeSetting(this.context);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeModeAsync = ref.watch(themeModeNotifierProvider);
    final colorSchemeAsync = ref.watch(colorSchemeNotifierProvider);

    return themeModeAsync.when(
      data: (themeMode) {
        return colorSchemeAsync.when(
          data: (colorScheme) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dark Mode row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.darkMode,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.themeTextSecondary,
                        ),
                      ),
                    ),
                    const ThemeToggle(size: 48),
                  ],
                ),
                const SizedBox(height: 12),
                // Theme mode segmented button
                _buildThemeSegmentedButton(context, ref, l10n, themeMode),
                const SizedBox(height: 20),
                // Divider
                Divider(color: context.themeDivider, height: 1),
                const SizedBox(height: 20),
                // Color Scheme label
                Text(
                  l10n.colorScheme,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.themeTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                // Color scheme segmented button
                _buildColorSchemeSegmentedButton(
                  context,
                  ref,
                  l10n,
                  colorScheme,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Text(l10n.error),
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
    return Container(
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.themeBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ThemeOption(
              context: context,
              label: l10n.lightTheme,
              icon: Icons.light_mode,
              isSelected: currentMode == ThemeMode.light,
              onTap: () => ref
                  .read(themeModeNotifierProvider.notifier)
                  .setTheme(ThemeMode.light),
            ),
          ),
          Container(width: 1, height: 40, color: context.themeDivider),
          Expanded(
            child: _ThemeOption(
              context: context,
              label: l10n.darkTheme,
              icon: Icons.dark_mode,
              isSelected: currentMode == ThemeMode.dark,
              onTap: () => ref
                  .read(themeModeNotifierProvider.notifier)
                  .setTheme(ThemeMode.dark),
            ),
          ),
          Container(width: 1, height: 40, color: context.themeDivider),
          Expanded(
            child: _ThemeOption(
              context: context,
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

  Widget _buildColorSchemeSegmentedButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ColorSchemeType colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.themeBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ColorSchemeOption(
              context: context,
              label: l10n.woodenScheme,
              icon: Icons.forest,
              isSelected: colorScheme == ColorSchemeType.wooden,
              onTap: () => ref
                  .read(colorSchemeNotifierProvider.notifier)
                  .setColorScheme(ColorSchemeType.wooden),
            ),
          ),
          Container(width: 1, height: 40, color: context.themeDivider),
          Expanded(
            child: _ColorSchemeOption(
              context: context,
              label: l10n.starlightScheme,
              icon: Icons.auto_awesome,
              isSelected: colorScheme == ColorSchemeType.starlight,
              onTap: () => ref
                  .read(colorSchemeNotifierProvider.notifier)
                  .setColorScheme(ColorSchemeType.starlight),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual theme option button for segmented control.
class _ThemeOption extends StatelessWidget {
  final BuildContext context;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.context,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = context.themeAccent;
    final unselectedColor = Theme.of(
      context,
    ).colorScheme.onSurface.withAlpha(128);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withAlpha(40) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? accentColor : unselectedColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? accentColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual color scheme option button.
class _ColorSchemeOption extends StatelessWidget {
  final BuildContext context;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSchemeOption({
    required this.context,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use themeAccent for consistent accent color regardless of color scheme
    final accentColor = context.themeAccent;
    final unselectedColor = Theme.of(
      context,
    ).colorScheme.onSurface.withAlpha(128);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withAlpha(40) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? accentColor : unselectedColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? accentColor : unselectedColor,
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
  final BuildContext context;

  const _SoundSetting(this.context);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sound,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.themeTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                settings.soundEnabled ? l10n.soundEnabled : l10n.soundDisabled,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.themeTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: settings.soundEnabled,
          onChanged: (_) => ref.read(settingsProvider.notifier).toggleSound(),
          activeThumbColor: context.themeAccent,
        ),
      ],
    );
  }
}

/// Fullscreen setting widget with toggle switch (desktop only).
class _FullscreenSetting extends ConsumerWidget {
  final BuildContext context;

  const _FullscreenSetting(this.context);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.fullscreen,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.themeTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                settings.fullscreen ? l10n.fullscreenEnabled : 'Fullscreen Off',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.themeTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: settings.fullscreen,
          onChanged: (_) =>
              ref.read(settingsProvider.notifier).toggleFullscreen(),
          activeThumbColor: context.themeAccent,
        ),
      ],
    );
  }
}

/// About setting widget displaying app information.
class _AboutSetting extends StatelessWidget {
  final BuildContext context;

  const _AboutSetting(this.context);

  Future<String> _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  colors: [context.themeAccent, context.themeAccentSecondary],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.themeBorder, width: 2),
              ),
              child: Icon(
                Icons.games,
                color: context.themeTextPrimary,
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.themeTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<String>(
                    future: _getVersion(),
                    builder: (context, snapshot) {
                      final version = snapshot.data ?? '...';
                      return Text(
                        '${l10n.version} $version',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.themeTextSecondary,
                        ),
                      );
                    },
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
            color: context.themeSurface.withAlpha(128),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.themeBorder.withAlpha(128),
              width: 1,
            ),
          ),
          child: Text(
            'A collection of classic board games brought to life with beautiful wooden aesthetics.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.themeTextSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
