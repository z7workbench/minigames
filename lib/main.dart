import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create a temporary ProviderContainer to load settings before app starts
  final container = ProviderContainer();

  // Pre-load settings and theme preferences in parallel
  await Future.wait([
    container.read(settingsProvider.notifier).load(),
    container.read(themeModeNotifierProvider.future),
    container.read(colorSchemeNotifierProvider.future),
  ]);

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
