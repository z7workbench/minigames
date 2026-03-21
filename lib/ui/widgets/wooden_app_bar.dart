import 'package:flutter/material.dart';
import '../theme/wooden_colors.dart';

/// A reusable wooden-styled app bar for the minigames app.
///
/// Uses wooden colors from the theme and provides a consistent
/// board game aesthetic across all screens.
class WoodenAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title widget to display in the app bar.
  final Widget? title;

  /// The title text string (alternative to title widget).
  final String? titleText;

  /// Optional actions to display on the right side of the app bar.
  final List<Widget>? actions;

  /// Whether to show a back button.
  final bool automaticallyImplyLeading;

  /// Optional leading widget to display on the left side.
  final Widget? leading;

  /// The elevation of the app bar shadow.
  final double elevation;

  /// Creates a wooden-styled app bar.
  const WoodenAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.elevation = 4.0,
  }) : assert(
         title != null || titleText != null,
         'Either title or titleText must be provided',
       );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? WoodenColors.darkPrimary
        : WoodenColors.lightPrimary;
    final foregroundColor = isDark
        ? WoodenColors.darkOnPrimary
        : WoodenColors.lightOnPrimary;
    final shadowColor = isDark
        ? WoodenColors.darkShadow
        : WoodenColors.lightShadow;

    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      centerTitle: true,
      shadowColor: shadowColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title:
          title ??
          Text(
            titleText!,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
      actions: actions,
      iconTheme: IconThemeData(color: foregroundColor, size: 24),
    );
  }
}
