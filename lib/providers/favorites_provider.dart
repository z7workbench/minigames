import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:minigames/models/game_type.dart';

part 'favorites_provider.g.dart';

@Riverpod(keepAlive: true)
class Favorites extends _$Favorites {
  @override
  Set<GameType> build() => {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('favorites') ?? [];
    state = list.map((e) => GameType.values[int.parse(e)]).toSet();
  }

  Future<void> toggleFavorite(GameType gameType) async {
    final prefs = await SharedPreferences.getInstance();
    final newFavorites = Set<GameType>.from(state);
    if (newFavorites.contains(gameType)) {
      newFavorites.remove(gameType);
    } else {
      newFavorites.add(gameType);
    }
    state = newFavorites;
    await prefs.setStringList(
      'favorites', 
      newFavorites.map((e) => e.index.toString()).toList()
    );
  }

  bool isFavorite(GameType gameType) => state.contains(gameType);
}
