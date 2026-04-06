# AGENTS.md - MiniGames 项目协作指南

## 项目概述

**小游戏合集 (MiniGames)** 是一个基于 Flutter + Flame 的多游戏合集应用，类似于《世界游戏大全51》。

### 应用信息
- **包名**: `top.z7workbench.minigames`
- **应用名称**: 小游戏合集 (minigames)
- **目标平台**: iOS, Android, Windows, macOS, Linux, Web

## 技术栈

| 层级 | 技术 | 版本 | 用途 |
|------|------|------|------|
| **底层** | Drift | ^2.32.0 | 跨平台数据库 |
| **底层** | path_provider | ^2.1.5 | 跨平台文件路径 |
| **底层** | shared_preferences | ^2.2.3 | 轻量配置存储 |
| **中层** | Flame | ^1.19.0 | 游戏引擎 |
| **中层** | flame_audio | ^2.10.0 | 游戏音效 |
| **上层** | Flutter | Latest | UI框架 |
| **上层** | flutter_riverpod | ^2.5.1 | 状态管理 |
| **上层** | riverpod_annotation | ^2.3.5 | 代码生成 |
| **上层** | flutter_localizations | SDK | 多语言支持 |

### Dev Dependencies
- `build_runner` - 代码生成
- `riverpod_generator` - Riverpod代码生成
- `riverpod_lint` - Riverpod代码检查
- `drift_dev` - Drift代码生成
- `custom_lint` - 自定义lint规则

## 项目架构

### 三层架构

```
lib/
├── data/                      # 底层：数据层
│   ├── database.dart          # Drift数据库主类
│   ├── tables/                # 表定义
│   │   ├── game_records.dart
│   │   ├── game_settings.dart
│   │   ├── user_progress.dart
│   │   ├── yacht_dice_saves.dart
│   │   └── twenty48_saves.dart
│   ├── daos/                  # DAO层
│   │   ├── game_records_dao.dart
│   │   ├── game_settings_dao.dart
│   │   ├── user_progress_dao.dart
│   │   ├── yacht_dice_saves_dao.dart
│   │   └── twenty48_saves_dao.dart
│   └── providers/             # 数据层Providers
│       └── database_provider.dart
│
├── games/                     # 中层：游戏逻辑层
│   ├── base/                  # 游戏基类
│   │   ├── base_game.dart     # FlameGame基类
│   │   ├── base_world.dart    # World基类
│   │   ├── base_scene.dart    # Scene基类
│   │   └── game_router.dart   # 游戏路由
│   ├── components/            # 共享组件
│   │   ├── wooden_button.dart
│   │   ├── game_dialog.dart
│   │   ├── dice_component.dart
│   │   └── number_selector.dart
│   ├── hit_and_blow/          # 猜数字游戏
│   │   ├── hit_and_blow_game.dart
│   │   ├── components/
│   │   └── models/
│   ├── yacht_dice/            # 游艇骰子游戏
│   │   ├── yacht_dice_game.dart
│   │   ├── ai/                # AI系统
│   │   ├── components/
│   │   └── models/
│   └── guess_arrangement/     # 猜排列游戏
│       ├── models/            # 数据模型
│       │   ├── playing_card.dart      # 扑克牌模型
│       │   └── guess_arrangement_state.dart  # 游戏状态
│       ├── components/        # UI组件
│       │   ├── card_display.dart      # 卡牌显示(带翻牌动画)
│       │   ├── card_slot.dart         # 卡牌位置槽
│       │   └── result_dialog.dart     # 结果对话框
│       ├── ai/                # AI系统
│       │   ├── guess_ai.dart          # AI基类
│       │   ├── easy_ai.dart           # 随机猜测
│       │   ├── medium_ai.dart         # 规则匹配
│       │   └── hard_ai.dart           # 启发式搜索
│       ├── screens/           # 游戏页面
│       │   └── start_screen.dart      # 开始页面
│       ├── guess_arrangement_provider.dart  # Riverpod Provider
│       └── guess_arrangement_screen.dart    # 主游戏界面
│
│   └── twenty48/              # 2048游戏
│       ├── models/            # 数据模型
│       │   ├── twenty48_tile.dart     # 方块模型
│       │   └── twenty48_state.dart    # 游戏状态
│       ├── components/        # UI组件
│       │   ├── tile_widget.dart       # 方块组件(带动画)
│       │   └── grid_widget.dart       # 4x4网格容器
│       ├── screens/           # 游戏页面
│       │   ├── twenty48_start_screen.dart  # 开始页面
│       │   └── twenty48_load_screen.dart   # 存档页面
│       ├── twenty48_provider.dart     # Riverpod Provider
│       └── twenty48_screen.dart       # 主游戏界面
│
├── ui/                        # 上层：UI层
│   ├── screens/               # 页面
│   │   ├── home_screen.dart
│   │   ├── settings_screen.dart
│   │   └── game_screen.dart
│   ├── widgets/               # 共享Widget
│   │   ├── game_card.dart
│   │   ├── wooden_app_bar.dart
│   │   └── theme_toggle.dart
│   └── theme/                 # 主题系统
│       ├── app_theme.dart
│       ├── wooden_colors.dart
│       └── theme_provider.dart
│
├── providers/                 # 全局Providers
│   ├── app_providers.dart     # 统一导出
│   ├── settings_provider.dart
│   └── locale_provider.dart
│
├── l10n/                      # 国际化
│   ├── app_en.arb
│   └── app_zh.arb
│
├── models/                    # 共享模型
│   ├── game_type.dart
│   └── player.dart
│
├── utils/                     # 工具类
│   ├── extensions.dart
│   └── constants.dart
│
├── app.dart                   # 应用根Widget
└── main.dart                  # 应用入口
```

## 代码规范

### 命名规范
- **文件**: snake_case (e.g., `game_records_dao.dart`)
- **类**: PascalCase (e.g., `GameRecordsDao`)
- **方法/变量**: camelCase (e.g., `getHighScore`)
- **常量**: ALL_CAPS_WITH_UNDERSCORES (e.g., `MAX_ATTEMPTS`)
- **私有成员**: _prefix (e.g., `_database`)

### Riverpod代码生成

使用`@riverpod`注解，类必须继承`_$ClassName`:

```dart
@riverpod
class GameState extends _$GameState {
  @override
  GameStateModel build() {
    return GameStateModel.initial();
  }

  void startGame() {
    state = state.copyWith(status: GameStatus.playing);
  }
}
```

### Drift表定义

```dart
@DataClassName('GameRecord')
class GameRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get gameType => text().withLength(min: 1, max: 50)();
  IntColumn get score => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### Flame组件

```dart
class MyComponent extends PositionComponent 
    with RiverpodComponentMixin, HasGameReference<MyGame> {
  
  @override
  void onMount() {
    addToGameWidgetBuild(() {
      ref.listen(gameStateProvider, (prev, next) {
        // 响应状态变化
      });
    });
    super.onMount();
  }
}
```

## 提交规范

使用[Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

Types:
- feat: 新功能
- fix: Bug修复
- chore: 构建/配置更改
- docs: 文档更新
- test: 添加测试
- refactor: 代码重构

Scopes:
- data: 数据库/数据层
- game: 游戏引擎/游戏
- ui: Flutter UI组件
- i18n: 国际化
- theme: 主题/样式
- deps: 依赖项
```

示例:
- `feat(game): add Hit & Blow game logic`
- `fix(data): correct high score calculation`
- `chore(deps): add Flame, Riverpod, Drift dependencies`

## 构建命令

```bash
# 代码生成（必须运行）
flutter pub run build_runner build --delete-conflicting-outputs

# 持续监听生成（开发时）
flutter pub run build_runner watch --delete-conflicting-outputs

# 运行应用
flutter run

# 代码检查
flutter analyze

# 运行测试
flutter test
```

## 多语言支持

### ARB文件位置
- `lib/l10n/app_en.arb` - 英文
- `lib/l10n/app_zh.arb` - 简体中文

### 添加新字符串

```json
// app_en.arb
{
  "@@locale": "en",
  "appTitle": "Mini Games",
  "@appTitle": {
    "description": "应用标题"
  }
}
```

```json
// app_zh.arb
{
  "@@locale": "zh",
  "appTitle": "小游戏合集"
}
```

### 在代码中使用

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.appTitle)
```

## 主题系统

### ⚠️ 重要：多主题适配规范

本项目支持 **2 种配色方案 × 2 种亮度模式 = 4 种主题组合**：

| 配色方案 | 浅色模式 | 深色模式 |
|---------|---------|---------|
| **木质 (Wooden)** | 暖木色调（卡其色、棕色） | 深胡桃色（深棕、乌木） |
| **星空 (Starlight)** | 柔和紫色、天蓝色 | 深紫色、深蓝色 |

**🚨 组件开发必须适配所有 4 种主题组合！**

### 主题感知颜色使用指南

#### ✅ 正确做法：使用 `context.theme*` 扩展

```dart
import '../../ui/theme/theme_colors.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ 背景色 - 自动适配木质/星空 + 深色/浅色
      color: context.themeBackground,
      
      // ✅ 主要文字颜色
      child: Text(
        'Hello',
        style: TextStyle(color: context.themeTextPrimary),
      ),
    );
  }
}
```

#### ❌ 错误做法：硬编码颜色

```dart
// ❌ 绝对禁止！这会导致星空主题下仍显示木质颜色
Container(
  color: isDark ? WoodenColors.darkBackground : WoodenColors.lightBackground,
)

// ❌ 绝对禁止！硬编码主题特定颜色
Icon(Icons.settings, color: WoodenColors.accentAmber),
```

### 可用的主题感知颜色

通过 `BuildContext` 扩展访问：

| 扩展属性 | 用途 | 说明 |
|---------|------|------|
| `context.themePrimary` | 主色 | AppBar、主要按钮背景 |
| `context.themeSecondary` | 次要色 | 次要元素 |
| `context.themeBackground` | 背景色 | Scaffold 背景 |
| `context.themeSurface` | 表面色 | 卡片、容器背景 |
| `context.themeCard` | 卡片色 | 卡片背景 |
| `context.themeAccent` | 强调色 | 图标、按钮、高亮（木质=琥珀色，星空=紫色） |
| `context.themeAccentSecondary` | 次强调色 | 渐变、次要强调 |
| `context.themeTextPrimary` | 主要文字 | 标题、重要文字 |
| `context.themeTextSecondary` | 次要文字 | 描述、辅助文字 |
| `context.themeBorder` | 边框色 | 边框、分隔线 |
| `context.themeShadow` | 阴影色 | 阴影效果 |
| `context.themeOnPrimary` | 主色上的文字 | AppBar 上的图标/文字 |
| `context.themeOnAccent` | 强调色上的文字 | 强调按钮上的文字 |
| `context.themeDisabled` | 禁用色 | 禁用状态 |
| `context.themeDivider` | 分隔线色 | Divider |

### 特殊场景颜色

| 场景 | 推荐做法 |
|------|---------|
| **AppBar 上的图标** | `context.themeOnPrimary`（不是 `themeAccent`！） |
| **AppBar 上的文字** | `context.themeOnPrimary` |
| **游戏卡片的图标** | `context.themeAccent` |
| **按钮渐变** | `[context.themeAccent, context.themeAccentSecondary]` |
| **成功/错误/警告色** | `context.themeSuccess` / `context.themeError` / `context.themeWarning` |

### 配色方案定义位置

- **木质主题**: `lib/ui/theme/wooden_colors.dart`
- **星空主题**: `lib/ui/theme/starlight_colors.dart`
- **主题感知扩展**: `lib/ui/theme/theme_colors.dart`
- **主题应用**: `lib/ui/theme/app_theme.dart`
- **主题 Provider**: `lib/ui/theme/theme_provider.dart`

### 切换主题

```dart
// 切换深色/浅色模式
ref.read(themeModeNotifierProvider.notifier).toggleTheme();

// 设置配色方案
ref.read(colorSchemeNotifierProvider.notifier).setColorScheme(ColorSchemeType.starlight);
```

### 组件开发检查清单

开发新组件时，必须验证：

- [ ] 使用 `context.theme*` 扩展，而非 `WoodenColors.*` 直接引用
- [ ] 已导入 `theme_colors.dart`
- [ ] 在 **深色+木质** 主题下测试
- [ ] 在 **深色+星空** 主题下测试
- [ ] 在 **浅色+木质** 主题下测试
- [ ] 在 **浅色+星空** 主题下测试
- [ ] AppBar 上的图标/文字使用 `themeOnPrimary`
- [ ] 按钮使用 `WoodenButton` 组件（已适配主题）

### 已适配主题的共享组件

以下组件已正确适配多主题，可直接使用：

- `WoodenButton` - 按钮（支持 primary, secondary, accent, ghost 变体）
- `WoodenAppBar` - 应用栏
- `GameCard` - 游戏卡片
- `ThemeToggle` - 主题切换开关

## 游戏实现指南

### 1. 创建新游戏

1. 在`lib/games/`下创建新文件夹
2. 继承`BaseMiniGame`创建游戏类
3. 实现必需的方法: `onLoad`, `onGameStart`, `onGameEnd`
4. 在`GameType`枚举中添加新游戏类型
5. 更新`HomeScreen`中的游戏列表

### 2. 游戏状态管理

使用`flame_riverpod`集成:

```dart
class MyGame extends FlameGame with RiverpodGameMixin {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(MyComponent());
  }
}

class MyComponent extends Component with RiverpodComponentMixin {
  @override
  void onMount() {
    addToGameWidgetBuild(() {
      ref.listen(myProvider, (prev, next) {
        // 响应Provider变化
      });
    });
    super.onMount();
  }
}
```

### 3. 游戏数据持久化

```dart
// 保存记录
final dao = ref.read(gameRecordsDaoProvider);
await dao.insertRecord(
  GameRecordsCompanion.insert(
    gameType: 'hit_and_blow',
    score: Value(score),
    durationSeconds: duration.inSeconds,
  ),
);
```

## AI实现指南

### 游艇骰子AI

AI位于`lib/games/yacht_dice/ai/`:
- `yacht_ai.dart` - AI基类
- `easy_ai.dart` - 简单难度
- `hard_ai.dart` - 困难难度（Expectimax算法）

AI决策流程:
1. 分析当前骰子状态
2. 计算每个可能动作的期望值
3. 选择最优动作
4. 返回保留哪些骰子 + 选择哪个计分类别

### 猜排列AI

AI位于`lib/games/guess_arrangement/ai/`:
- `guess_ai.dart` - AI基类 + AiDecision数据类
- `easy_ai.dart` - 随机猜测
- `medium_ai.dart` - 规则匹配（基于位置推断）
- `hard_ai.dart` - 启发式搜索（概率分析）

AI决策流程:
1. 分析对手已翻开的牌和猜测历史
2. 根据位置推断可能的牌面（牌按大小排序）
3. 计算每个猜测的期望收益
4. 返回猜测位置 + 猜测点数

**AI难度差异:**
- **Easy**: 完全随机选择位置和点数
- **Medium**: 基于位置上下文推断（相邻已翻开牌提供边界）
- **Hard**: 完整概率分布计算 + 剩余牌统计 + 位置邻接分析

## 常见问题

### Q: 如何添加新平台支持？
**A**: 更新`pubspec.yaml`中的平台配置，确保Drift和path_provider支持目标平台。

### Q: 如何调试游戏？
**A**: 使用Flutter DevTools，Flame提供了游戏叠加层显示调试信息。

### Q: 如何添加音效？
**A**: 使用`flame_audio`包，预加载音频资源，在游戏中调用`AudioPlayer.play()`。

### Q: 如何优化性能？
**A**: 
- 使用`select`监听Provider的特定字段
- 避免在`update`中创建新对象
- 使用`Query`系统高效查找组件
- 在`onRemove`中清理资源

## 参考资源

- [Flame官方文档](https://docs.flame-engine.org/latest/)
- [Drift官方文档](https://drift.simonbinder.eu/)
- [Riverpod官方文档](https://riverpod.dev/)
- [Flutter国际化](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)

## 贡献指南

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'feat(game): add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request

---

**最后更新**: 2026年3月
**项目状态**: 活跃开发中
