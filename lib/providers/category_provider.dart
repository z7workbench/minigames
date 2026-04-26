import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:minigames/models/game_category.dart';

part 'category_provider.g.dart';

enum SortMode { category, releaseTime }

class SortSettingsModel {
  final SortMode sortMode;
  final List<GameCategory> categoryOrder;
  
  const SortSettingsModel({
    required this.sortMode,
    required this.categoryOrder,
  });
  
  SortSettingsModel copyWith({
    SortMode? sortMode,
    List<GameCategory>? categoryOrder,
  }) {
    return SortSettingsModel(
      sortMode: sortMode ?? this.sortMode,
      categoryOrder: categoryOrder ?? this.categoryOrder,
    );
  }
}

@Riverpod(keepAlive: true)
class SortSettings extends _$SortSettings {
  @override
  SortSettingsModel build() {
    return SortSettingsModel(
      sortMode: SortMode.category,
      categoryOrder: GameCategory.values.toList(),
    );
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final sortModeStr = prefs.getString('sort_mode');
    final categoryOrderList = prefs.getStringList('category_order');
    
    // Match the enum name format (camelCase): "category" or "releaseTime"
    SortMode mode = sortModeStr == SortMode.releaseTime.name 
        ? SortMode.releaseTime 
        : SortMode.category;
    
    List<GameCategory> order;
    if (categoryOrderList != null) {
      order = categoryOrderList
          .map((name) => GameCategoryExtension.fromName(name))
          .whereType<GameCategory>()
          .toList();
      // Ensure all categories present (handle migration)
      if (order.length != GameCategory.values.length) {
        order = GameCategory.values.toList();
      }
    } else {
      order = GameCategory.values.toList();
    }
    
    state = SortSettingsModel(sortMode: mode, categoryOrder: order);
  }

  Future<void> setSortMode(SortMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(sortMode: mode);
    await prefs.setString('sort_mode', mode.name);
  }

  Future<void> reorderCategory(int oldIndex, int newIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final order = List<GameCategory>.from(state.categoryOrder);
    
    // Adjust newIndex for removal
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    final item = order.removeAt(oldIndex);
    order.insert(newIndex, item);
    
    state = state.copyWith(categoryOrder: order);
    await prefs.setStringList(
      'category_order', 
      order.map((c) => c.name).toList()
    );
  }
}
