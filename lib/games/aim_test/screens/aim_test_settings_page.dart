import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../aim_test_provider.dart';
import '../models/aim_test_state.dart';

class AimTestSettingsPage extends ConsumerStatefulWidget {
  const AimTestSettingsPage({super.key});

  @override
  ConsumerState<AimTestSettingsPage> createState() =>
      _AimTestSettingsPageState();
}

class _AimTestSettingsPageState extends ConsumerState<AimTestSettingsPage> {
  late double _deadZonePercentage;
  late double _bubbleSize;
  late BubbleColor _selectedColor;
  late int _gameDuration;
  late bool _enableAppearAnimation;

  static const List<int> _durationOptions = [30, 40, 50, 60, 90, 120, 180];

  @override
  void initState() {
    super.initState();
    final config = ref.read(aimTestGameProvider).bubbleConfig;
    _deadZonePercentage = config.deadZonePercentage;
    _bubbleSize = (config.minSize + config.maxSize) / 2;
    _selectedColor = config.selectedColor;
    _gameDuration = config.gameDurationSeconds;
    _enableAppearAnimation = config.enableAppearAnimation;
  }

  Color _getBubbleColor(BubbleColor color) {
    switch (color) {
      case BubbleColor.random:
        return Colors.transparent;
      case BubbleColor.bubbleGumPink:
        return const Color(0xFFFF69B4);
      case BubbleColor.skyBlue:
        return const Color(0xFF87CEEB);
      case BubbleColor.mintGreen:
        return const Color(0xFF98FF98);
      case BubbleColor.lavender:
        return const Color(0xFFB57EDC);
      case BubbleColor.peach:
        return const Color(0xFFFFCBA4);
      case BubbleColor.coral:
        return const Color(0xFFFF7F50);
      case BubbleColor.turquoise:
        return const Color(0xFF40E0D0);
      case BubbleColor.lemonYellow:
        return const Color(0xFFFFEB3B);
    }
  }

  Widget _buildColorButton(BubbleColor color, bool isSelected) {
    if (color == BubbleColor.random) {
      return GestureDetector(
        onTap: () {
          setState(() => _selectedColor = color);
          ref.read(aimTestGameProvider.notifier).updateSelectedColor(color);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const SweepGradient(
              colors: [
                Color(0xFFFF69B4),
                Color(0xFF87CEEB),
                Color(0xFF98FF98),
                Color(0xFFB57EDC),
                Color(0xFFFFCBA4),
                Color(0xFFFF7F50),
                Color(0xFF40E0D0),
                Color(0xFFFFEB3B),
                Color(0xFFFF69B4),
              ],
            ),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withAlpha(50),
              width: isSelected ? 3 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.white.withAlpha(100),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? const Icon(Icons.shuffle, color: Colors.white, size: 20)
              : null,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _selectedColor = color);
        ref.read(aimTestGameProvider.notifier).updateSelectedColor(color);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getBubbleColor(color),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withAlpha(50),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withAlpha(100),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    final screenSize = MediaQuery.of(context).size;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    // Use EXACTLY same calculation as game screen
    final gameAreaTop = safeAreaTop;
    final gameAreaHeight = screenSize.height - safeAreaTop - safeAreaBottom;
    final deadZone = _deadZonePercentage;

    final activeLeft = screenSize.width * deadZone;
    final activeRight = screenSize.width * (1 - deadZone);
    final activeTop = gameAreaTop + gameAreaHeight * deadZone;
    final activeBottom = gameAreaTop + gameAreaHeight * (1 - deadZone);
    final activeWidth = activeRight - activeLeft;
    final activeHeight = activeBottom - activeTop;

    final previewColor = _selectedColor == BubbleColor.random
        ? BubbleConfig.allColors[0]
        : _selectedColor;

    return Scaffold(
      backgroundColor: themeColors.background,
      body: Stack(
        children: [
          // Full-screen preview - EXACTLY same as game screen
          Container(color: themeColors.background),

          // Dead zone overlays - EXACTLY same positions as game screen
          // Left dead zone
          Positioned(
            left: 0,
            top: gameAreaTop,
            width: activeLeft,
            height: gameAreaHeight,
            child: Container(color: Colors.black.withAlpha(100)),
          ),
          // Right dead zone
          Positioned(
            right: 0,
            top: gameAreaTop,
            width: screenSize.width - activeRight,
            height: gameAreaHeight,
            child: Container(color: Colors.black.withAlpha(100)),
          ),
          // Top dead zone
          Positioned(
            left: activeLeft,
            top: gameAreaTop,
            width: activeWidth,
            height: activeTop - gameAreaTop,
            child: Container(color: Colors.black.withAlpha(100)),
          ),
          // Bottom dead zone
          Positioned(
            left: activeLeft,
            top: activeBottom,
            width: activeWidth,
            height: gameAreaHeight - (activeBottom - gameAreaTop),
            child: Container(color: Colors.black.withAlpha(100)),
          ),

          // Active area border
          Positioned(
            left: activeLeft,
            top: activeTop,
            width: activeWidth,
            height: activeHeight,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: themeColors.accent.withAlpha(100),
                  width: 2,
                ),
              ),
            ),
          ),

          // Preview bubble at center
          Positioned(
            left: activeLeft + activeWidth / 2 - _bubbleSize / 2,
            top: activeTop + activeHeight / 2 - _bubbleSize / 2,
            child: Container(
              width: _bubbleSize,
              height: _bubbleSize,
              decoration: BoxDecoration(
                color: _getBubbleColor(previewColor),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getBubbleColor(previewColor).withAlpha(100),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: _selectedColor == BubbleColor.random
                  ? Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Color(0xFFFF69B4),
                            Color(0xFF87CEEB),
                            Color(0xFF98FF98),
                            Color(0xFFFFEB3B),
                            Color(0xFFFF69B4),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          ),

          // Back button (top-left)
          Positioned(
            left: 16,
            top: safeAreaTop + 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(150),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: themeColors.accent.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: themeColors.onPrimary,
                  size: 24,
                ),
              ),
            ),
          ),

          // Title (top-center)
          Positioned(
            left: 0,
            right: 0,
            top: safeAreaTop + 16,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(180),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeColors.accent.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: Text(
                  l10n.at_settings,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Draggable bottom panel
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.7,
            snap: true,
            snapSizes: [0.2, 0.4, 0.7],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(220),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(
                    color: themeColors.accent.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(100),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(20, 16, 20, safeAreaBottom + 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Game Duration selector
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: themeColors.onPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.at_gameDuration,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _durationOptions.map((duration) {
                                final isSelected = _gameDuration == duration;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => _gameDuration = duration);
                                    ref
                                        .read(aimTestGameProvider.notifier)
                                        .updateGameDuration(duration);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? themeColors.accent
                                          : Colors.white.withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white.withAlpha(50),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '${duration}s',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white.withAlpha(200),
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),

                            // Dead Zone slider
                            Row(
                              children: [
                                Icon(
                                  Icons.crop_free,
                                  color: themeColors.onPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${l10n.at_deadZone}: ${l10n.at_deadZonePercent((_deadZonePercentage * 100).toInt())}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _deadZonePercentage,
                              min: 0,
                              max: 0.4,
                              divisions: 8,
                              activeColor: themeColors.accent,
                              inactiveColor: themeColors.accent.withAlpha(50),
                              onChanged: (value) {
                                setState(() => _deadZonePercentage = value);
                                ref
                                    .read(aimTestGameProvider.notifier)
                                    .updateDeadZonePercentage(value);
                              },
                            ),
                            const SizedBox(height: 12),

                            // Bubble Size slider
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: themeColors.onPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${l10n.at_bubbleSize}: ${_bubbleSize.toInt()}dp',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _bubbleSize,
                              min: 40,
                              max: 100,
                              divisions: 12,
                              activeColor: themeColors.accent,
                              inactiveColor: themeColors.accent.withAlpha(50),
                              onChanged: (value) {
                                setState(() => _bubbleSize = value);
                                ref
                                    .read(aimTestGameProvider.notifier)
                                    .updateBubbleSize(value);
                              },
                            ),
                            const SizedBox(height: 16),

                            // Bubble Color picker
                            Row(
                              children: [
                                Icon(
                                  Icons.palette,
                                  color: themeColors.onPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.at_bubbleColor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: BubbleColor.values.map((color) {
                                final isSelected = _selectedColor == color;
                                return _buildColorButton(color, isSelected);
                              }).toList(),
                            ),
                            const SizedBox(height: 16),

                            // Appear Animation toggle
                            Row(
                              children: [
                                Icon(
                                  Icons.animation,
                                  color: themeColors.onPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.at_appearAnimation,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _enableAppearAnimation,
                                  activeTrackColor: themeColors.accent.withAlpha(150),
                                  thumbColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return themeColors.accent;
                                    }
                                    return Colors.grey;
                                  }),
                                  onChanged: (value) {
                                    setState(() => _enableAppearAnimation = value);
                                    ref
                                        .read(aimTestGameProvider.notifier)
                                        .updateEnableAppearAnimation(value);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}