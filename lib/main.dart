import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'providers/app_providers.dart';
import 'providers/favorites_provider.dart';
import 'providers/category_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  // Create a temporary ProviderContainer to load settings before app starts
  final container = ProviderContainer();

  // Pre-load settings and theme preferences in parallel
  await Future.wait([
    container.read(settingsProvider.notifier).load(),
    container.read(themeModeNotifierProvider.future),
    container.read(colorSchemeNotifierProvider.future),
    container.read(favoritesProvider.notifier).load(),
    container.read(sortSettingsProvider.notifier).load(),
  ]);

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
