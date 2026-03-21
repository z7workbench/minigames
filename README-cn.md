<p align="center"><img src="arts/minigames-main.webp"></p>

<p align="center">
    <a href="https://github.com/z7workbench/minigames/actions/workflows/android.yml"><img alt="Android build" src="https://github.com/z7workbench/minigames/actions/workflows/android.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/linux.yml"><img alt="Linux build" src="https://github.com/z7workbench/minigames/actions/workflows/linux.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/web.yml"><img alt="Web build" src="https://github.com/z7workbench/minigames/actions/workflows/web.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/windows.yml"><img alt="Windows build" src="https://github.com/z7workbench/minigames/actions/workflows/windows.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/macios.yml"><img alt="macOS & iOS build" src="https://github.com/z7workbench/minigames/actions/workflows/macios.yml/badge.svg"></a>
</p>

使用 Dart 和 Flutter 编写的迷你游戏合集！

# 游戏
## 猜数字组合
猜数字组合灵感来自 Nintendo Switch 的《世界游戏大全51》中的猜数字。

<p align="center">
<img alt="猜数字组合" src="arts/hnb.webp">
</p>

### 描述
这是一个猜出隐藏的n个数字和位置的游戏，默认n为4。从1-n中选择n-2个数字放到位置上，按下"检查"即可检查对错。每个位置会被判定为"全对"（用彩色对钩表示）或"半对"（用灰色对钩表示），前者为位置和数字都正确，后者为选取的数字正确。如果判定失败则再来一次，直到判断正确！

### 排行榜
猜数字组合目前有排行榜。包含完成时间、游戏用时和尝试次数，按尝试次数排序。

<p align="center">
<img alt="猜数字排行榜" src="arts/hnb_leaderboard.webp">
</p>

## 游艇骰子
游艇骰子灵感来自 Nintendo Switch 的《世界游戏大全51》中的游艇骰子。

<p align="center">
<img alt="游艇骰子" src="arts/dices.webp">
</p>

### 描述
这是一个互相投掷骰子凑出排列组合、竞争总分的游戏。如果凑出不错的组合，就双击对应分数用于确认分数，选过的排列组合不能再次选择。可以单击骰子，只保留点数不错的骰子再重新投掷。在重新投掷之后也可以改变保留的骰子。每轮都必须填到表格中，即使没有任何排列组合。最后总分高的人获胜！

## 四子棋
四子棋灵感来自 Nintendo Switch 的《世界游戏大全51》中的四子棋。

<p align="center">
<img alt="四子棋" src="arts/connect_four.webp">
</p>

### 描述
第一个玩家通过将其中一个圆盘放入空游戏板的中心列来启动连接四。然后两个玩家交替轮流将他们的一个圆盘一次放入一个未填充的列中，直到其中一个玩家拿着圆盘，连续获得对角线四个，并赢得比赛。如果棋盘在任一玩家连续四次之前填满，则游戏为平局。

# 技术栈

| 层级 | 技术 |
|-------|------------|
| UI/游戏引擎 | Flame 1.36+ |
| 状态管理 | Riverpod |
| 数据库 | Drift (SQLite) |
| 国际化 | flutter_intl |
| 框架 | Flutter 3.27+ |
| 语言 | Dart 3.6+ |

# 构建命令

```bash
# 获取依赖
flutter pub get

# 生成代码（Drift, Riverpod）
dart run build_runner build --delete-conflicting-outputs

# 运行应用
flutter run

# 构建特定平台
flutter build apk           # Android
flutter build ios           # iOS
flutter build web           # Web
flutter build linux         # Linux
flutter build windows       # Windows
flutter build macos         # macOS
```

# 平台支持

| 平台 | 状态 |
|----------|--------|
| Android | ✅ 支持 |
| iOS | ✅ 支持 |
| Web | ✅ 支持 |
| Windows | ✅ 支持 |
| Linux | ✅ 支持 |
| macOS | ✅ 支持 |

所有游戏都可以离线运行，无需网络连接。

# 使用的库和素材
- [Flutter](https://flutter.dev)
- [Dart](https://dart.dev)
- [Flame](https://flame-engine.org)
- [Riverpod](https://riverpod.dev)
- [Drift](https://drift.simonbinder.eu)
- [flutter_intl](https://pub.dev/packages/flutter_intl)