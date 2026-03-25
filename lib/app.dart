import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/generated/app_localizations.dart';
import 'providers/app_providers.dart';
import 'ui/screens/home_screen.dart';
import 'ui/theme/app_theme.dart';
import 'ui/theme/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeNotifierProvider);
    final colorSchemeAsync = ref.watch(colorSchemeNotifierProvider);
    final settings = ref.watch(settingsProvider);

    final colorScheme = colorSchemeAsync.valueOrNull ?? ColorSchemeType.wooden;

    return MaterialApp(
      title: 'Mini Games',
      debugShowCheckedModeBanner: false,
      themeMode: themeModeAsync.valueOrNull ?? ThemeMode.system,
      theme: AppTheme.lightTheme(colorScheme),
      darkTheme: AppTheme.darkTheme(colorScheme),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('zh')],
      locale: settings.locale,
      home: const HomeScreen(),
    );
  }
}
