<p align="center"><img src="arts/minigames-main.webp"></p>

<p align="center">
    <a href="https://github.com/z7workbench/minigames/actions/workflows/android.yml"><img alt="Android 构建" src="https://github.com/z7workbench/minigames/actions/workflows/android.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/linux.yml"><img alt="Linux 构建" src="https://github.com/z7workbench/minigames/actions/workflows/linux.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/web.yml"><img alt="Web 构建" src="https://github.com/z7workbench/minigames/actions/workflows/web.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/windows.yml"><img alt="Windows 构建" src="https://github.com/z7workbench/minigames/actions/workflows/windows.yml/badge.svg"></a>
    <a href="https://github.com/z7workbench/minigames/actions/workflows/macios.yml"><img alt="macOS & iOS 构建" src="https://github.com/z7workbench/minigames/actions/workflows/macios.yml/badge.svg"></a>
</p>

<p align="center">
  <strong>小游戏合集</strong> - 基于 Flutter 的多游戏应用，灵感来自 Nintendo Switch 的《世界游戏大全51》
</p>

<p align="center">
  <a href="#游戏列表">游戏</a> •
  <a href="#安装指南">安装</a> •
  <a href="#技术栈">技术栈</a> •
  <a href="#贡献指南">贡献</a>
</p>

---

## 游戏列表

| 游戏 | 状态 | AI 难度 | 存档系统 |
|------|--------|----------|-------------|
| **猜数字 (Hit & Blow)** | ✅ 完成 | - | 排行榜 |
| **游艇骰子 (Yacht Dice)** | ✅ 完成 | 简单/中等/困难 | 5 个存档位 |
| **猜排列 (Guess Arrangement)** | ✅ 完成 | 简单/中等/困难 | 游戏记录 |
| **2048** | ✅ 完成 | - | 5 档位 + 自动存档 |
| **播棋 (Mancala)** | ✅ 完成 | 简单/中等/困难 | 5 个存档位 |
| **红心大战 (Hearts)** | ✅ 完成 | 简单/中等/困难 | 5 个存档位 |
| **吹牛酒吧 (Bluff Bar)** | ✅ 完成 | 简单/中等/困难 | 5 个存档位 |
| **骰子对战 (Dice Battle)** | 🚧 开发中 | 简单/中等/困难 | 游戏记录 |
| **反应力测试 (Reaction Test)** | ✅ 完成 | - | 排行榜 |
| **瞄准测试 (Aim Test)** | ✅ 完成 | - | 排行榜 |
| **国际象棋 (Chess)** | ✅ 完成 | 简单/困难 | 游戏记录 |
| **舒尔特方格 (Schulte Grid)** | ✅ 完成 | - | 排行榜（按尺寸） |

---

### 猜数字组合 (Hit & Blow)

猜数字组合灵感来自 Nintendo Switch 的《世界游戏大全51》中的猜数字。

**简介：**
猜出隐藏的 n 个数字和位置的游戏，默认 n 为 4。从 1-n 中选择数字放到位置上，按下"检查"即可检查对错：
- **Hit** (彩色对钩)：位置和数字都正确
- **Blow** (灰色对钩)：数字正确但位置错误

持续猜测直到全部正确！

**特性：**
- 两种难度：简单（4 位数字，1-6），困难（6 位数字，1-8）
- 最多 10 次尝试
- 猜测历史记录
- 计时器和游戏时长统计
- 按尝试次数排序的排行榜

---

### 游艇骰子 (Yacht Dice)

游艇骰子灵感来自 Nintendo Switch 的《世界游戏大全51》中的游艇骰子。

**简介：**
投掷骰子凑出排列组合来竞争总分！投掷后点击骰子"保留"好的骰子，重新投掷其余的。双击分数类别确认得分。每个类别每局只能选择一次。总分最高者获胜！

**游戏模式：**
- **双人模式**：本地多人对战
- **对战 AI**：简单（随机）、中等（规则策略）、困难（最优策略）

**特性：**
- 骰子滚动动画
- 有效类别高亮的分数预览
- 保留和重投机制（每回合最多 3 次投掷）
- 保存/恢复游戏功能
- 全部 13 个 Yahtzee 类别

---

### 猜排列 (Guess Arrangement)

受推演类桌游启发的猜牌游戏。

**简介：**
两位玩家各自抽取 8 张牌，牌面朝下按从小到大排列（A=1，K=13）。轮流猜测对手的牌，猜测位置和点数。猜对翻开该牌并累计连击！

**游戏规则：**
- 猜牌："第 3 张是 7"（只猜点数，不猜花色）
- 猜对：翻开该牌，继续猜测，累计连击
- 猜错：回合交给对手，连击归零
- 胜利条件：先翻开对手所有牌的玩家获胜

**游戏模式：**
- **双人对战**：本地多人，隐藏牌面
- **对战 AI**：简单（随机）、中等（位置规则）、困难（概率分析）

**特性：**
- 卡牌翻转动画效果
- 连击追踪系统
- 位置推演（牌按升序排列）
- AI 回合总结对话框
- 游戏记录持久化

---

### 2048

经典滑块益智游戏。

**简介：**
向四个方向滑动方块，合并相同数字的方块。当两个相同数字的方块碰撞时，它们会合并成一个数值翻倍的方块。尝试达到 2048 方块！

**游戏规则：**
- 上下左右滑动移动所有方块
- 相同数字的方块碰撞时会合并
- 每次移动后随机生成新方块（90% 概率为 2，10% 概率为 4）
- 无法移动时游戏结束

**计分系统：**
- 基础分数：合并后的方块数值（如两个 4 合并得 8 分）
- 多重合并奖励：×1.5
- 连续合并奖励：×2.0

**特性：**
- 方块滑动和生成动画
- 每 3 分钟自动存档
- 5 个存档位（1 自动 + 4 手动）
- 最高分记录
- 游戏计时器
- 明/暗主题支持

---

### 播棋 (Mancala)

古老的播种策略游戏。

**简介：**
收集比对手更多的种子！每位玩家有 6 个小坑和 1 个大坑。从你的一个小坑中取出所有种子，逆时针播撒。

**游戏规则：**
- 从你一侧的一个小坑中取出所有种子
- 逆时针逐个播撒，跳过对手的大坑
- 落入你自己的大坑：再来一次！
- 落入你的空坑且对面有种子：捕获对面所有种子！
- 当一方小坑全部为空时游戏结束，剩余种子归其所有者
- 种子多者获胜

**游戏模式：**
- **双人对战**：本地多人
- **对战 AI**：简单（随机）、中等（启发式）、困难（Minimax + Alpha-Beta剪枝）

**特性：**
- 种子播撒动画
- 回合指示器
- 再来一次逻辑
- 捕获动画
- 5 个存档位
- 游戏计时器

---

### 红心大战 (Hearts)

经典轮次卡牌游戏 - 避免收集红心和黑桃皇后！

**简介：**
四人红心大战，包含换牌阶段和全收月亮机制。避免收集分数（红心 = 每张 1 分，Q♠ = 13 分）。先达到 100 分的玩家输掉游戏！

**游戏规则：**
- **换牌阶段**：选择 3 张牌传递（左 → 右 → 对面 → 不换，循环）
- **轮次出牌**：尽可能跟牌，最大的牌赢得该轮
- **计分**：红心 = 每张 1 分，黑桃皇后 = 13 分
- **全收月亮**：收集全部 26 分 = 对手各得 26 分！
- 首位达到 100 分触发游戏结束 - 分数最低者获胜

**游戏模式：**
- **玩家对战 3 AI**：人类玩家对抗 AI 对手
- **AI 难度**：简单（避免分数）、中等（策略性）、困难（卡牌追踪 + 全收月亮）

**特性：**
- 4 方向换牌循环
- 卡牌追踪系统（AI 记忆已出的牌）
- 全收月亮检测和计分
- 换牌计时器选项（15秒、30秒、60秒、无）
- 月亮公告设置（隐藏/显示）
- 5 个存档位保存完整游戏状态
- 计分板和轮次历史
- 规则验证和计分逻辑

---

### 吹牛酒吧 (Bluff Bar)

虚张声势的扑克牌游戏，带有俄罗斯轮盘淘汰机制 - 喊"骗子！"来质疑！

**简介：**
四人吹牛酒吧游戏，你将牌背面朝上打出并声称它们匹配目标牌（J/Q/K/A）。其他人可以质疑你的声称。输家将面对俄罗斯轮盘（1颗子弹 + 5颗空白）！成为最后的幸存者即可获胜！

**游戏规则：**
- **目标牌**：每轮有一个目标牌（J/Q/K/A），显示在中央
- **出牌**：选择1-5张牌背面朝上打出，声称它们匹配目标牌
- **质疑**：喊"骗子！"翻开上家的牌
  - 发现假牌 → 质疑者获胜，吹牛者面对轮盘
  - 全是真牌 → 吹牛者获胜，质疑者面对轮盘
- **俄罗斯轮盘**：1颗子弹 + 5颗空白随机排列。翻开一张 - 子弹 = 淘汰！
- **赖子牌（Joker）**：万能牌，可作为任意目标牌
- **胜利条件**：成为最后存活的玩家

**游戏模式：**
- **玩家 vs 3 AI**：人类（南位）对战AI对手（东位、西位、北位）
- **AI 难度**：简单（随机）、中等（基本策略）、困难（概率分析 + 吹牛检测）

**特性：**
- 24张牌组：5×J/Q/K/A + 4张赖子牌
- 手牌中目标牌和赖子牌高亮显示
- 顺时针轮次顺序：南 → 东 → 北 → 西
- 累计开枪次数追踪（X/6）
- 质疑翻牌覆盖层带卡牌翻转动画
- 俄罗斯轮盘开枪动画和结果显示
- 5个存档位保存完整游戏状态

---

### 骰子对战 (Dice Battle) 🚧 开发中

策略骰子战斗游戏，包含攻击/防御阶段和特殊效果！

**简介：**
回合制骰子对战游戏，玩家投掷骰子进行攻击和防御。在攻击和防御阶段交替，选择骰子以最大化伤害或防御。

**游戏规则：**
- **准备阶段**：每位玩家选择具有独特攻击/防御值的骰子组合
- **硬币翻转**：随机决定先手
- **攻击阶段**：投掷骰子，选择攻击骰子，最多重投 2 次
- **防御阶段**：防守方投掷并选择防御骰子
- **伤害计算**：攻击总值 - 防御总值 = 造成伤害
- **效果**：特殊场地效果从第 2 回合开始激活
- 当玩家 HP 为 0 时游戏结束

**游戏模式：**
- **双人对战**：本地多人
- **对战 AI**：简单（随机）、中等（基本策略）、困难（最优选择 + 重投）

**注意：** 此游戏目前处于开发阶段。核心机制已实现，但可能有未完成的功能或视觉打磨。

**特性（已实现）：**
- 6 种独特骰子类型（标准、攻击、防御等）
- 8 种场地效果（奇数加成、偶数加成、连击、双倍伤害等）
- 骰子重投系统（每次攻击最多 2 次）
- 生命条可视化
- 战斗日志与回合历史
- 伤害显示动画
- 骰子选择和确认界面

---

### 国际象棋 (Chess)

经典国际象棋对弈 AI，支持 FEN 导入和 PGN 导出。

**简介：**
完整的国际象棋实现，包含完整规则引擎、两种 AI 难度和标准记谱支持。可选择执白或执黑对战 AI，通过 FEN 导入自定义局面，以 PGN 格式导出对局记录。

**游戏规则：**
- 点击棋子查看合法走法高亮显示
- 点击高亮格子进行移动（包括王车易位、吃过路兵、升变）
- AI 在你走棋后自动响应
- 游戏检测将军、将杀、逼和及和棋条件

**游戏模式：**
- **对战 AI**：简单（贪心+随机），困难（Alpha-Beta 剪枝 + 迭代加深）

**特性：**
- 完整规则引擎（王车易位、吃过路兵、兵升变、50 步规则、三次重复局面、子力不足）
- FEN 局面导入与验证
- PGN 导出（标准记谱含头部信息）
- 走棋记录显示（代数记谱法）
- 被吃棋子追踪与子力优势显示
- 两种棋子风格：空心和实心
- 竖屏和横屏布局
- 悔棋支持
- 将军/将杀/逼和/和棋检测

---

### 舒尔特方格 (Schulte Grid)

经典舒尔特方格专注力训练工具。

**简介：**
在随机打乱的方格中，按 1 到 N 的升序尽快点击数字。点击 1 时开始计时，点击最后一个数字时停止。训练你的专注力和周边视野！

**网格尺寸：**
- **4×4**：16 个数字（1-16）
- **5×5**：25 个数字（1-25）
- **6×6**：36 个数字（1-36）

**特性：**
- 毫秒级精度计时器（MM:SS.ms 格式）
- 点击错误视觉反馈（红色闪烁）不重置计时器
- 按网格尺寸独立排行榜（前 10 名记录）
- 新纪录检测
- 应用后台时计时暂停，返回时恢复
- 竖屏和横屏布局
- 响应式网格适配屏幕尺寸

---

## 截图预览

### 已有截图

| 游戏 | 截图文件 |
|------|------------|
| 猜数字组合 | `arts/hnb.webp`, `arts/hnb_leaderboard.webp` |
| 游艇骰子 | `arts/dices.webp` |

### 缺失截图（即将添加）
- 猜排列
- 2048
- 播棋
- 红心大战
- 吹牛酒吧
- 骰子对战

---

## 安装指南

### 系统要求

- **Flutter SDK**: 3.27+ ([安装 Flutter](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: 3.11+ (随 Flutter 安装)
- **平台特定要求**:
  - Android: Android SDK, Java 17
  - iOS/macOS: Xcode 15+
  - Windows/Linux: Visual Studio Build Tools / Clang

### 快速开始

1. **克隆仓库**
   ```bash
   git clone https://github.com/z7workbench/minigames.git
   cd minigames
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **生成代码** (Riverpod 和 Drift 必需)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **运行应用**
   ```bash
   flutter run
   ```

### 平台构建

```bash
# Android
flutter build apk
flutter build appbundle  # 用于 Play Store

# iOS
flutter build ios
flutter build ipa        # 用于分发

# Web
flutter build web        # 输出: build/web/

# Windows
flutter build windows

# Linux
flutter build linux

# macOS
flutter build macos
```

### 开发流程

```bash
# 代码生成监视模式（持续运行）
flutter pub run build_runner watch --delete-conflicting-outputs

# 在特定设备运行
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d macos
flutter run -d linux
flutter run -d chrome    # Web

# 运行测试
flutter analyze
flutter test
```

---

## 技术栈

| 类别 | 技术 | 版本 | 用途 |
|----------|------------|---------|---------|
| **框架** | Flutter | 3.27+ | 跨平台 UI |
| **语言** | Dart | 3.11+ | 应用代码 |
| **游戏引擎** | Flame | 1.19+ | 游戏渲染与逻辑 |
| **音频** | flame_audio | 2.10+ | 音效 |
| **状态管理** | Riverpod | 2.5+ | 响应式状态 |
| **数据库** | Drift | 2.28+ | SQLite 持久化 |
| **国际化** | flutter_localizations | SDK | i18n 支持 |
| **存储** | shared_preferences | 2.2+ | 设置持久化 |

---

## 平台支持

| 平台 | 状态 | CI/CD |
|----------|--------|-------|
| Android | ✅ 完全支持 | GitHub Actions |
| iOS | ✅ 完全支持 | GitHub Actions |
| Web | ✅ 完全支持 | GitHub Actions |
| Windows | ✅ 完全支持 | GitHub Actions |
| Linux | ✅ 完全支持 | GitHub Actions |
| macOS | ✅ 完全支持 | GitHub Actions |

**所有游戏均可离线运行** - 无需网络连接。

---

## 项目结构

```
lib/
├── data/                      # 数据层 (Drift 数据库)
│   ├── database.dart          # 主数据库类
│   ├── tables/                # 表定义
│   │   ├── game_records.dart
│   │   ├── game_settings.dart
│   │   ├── user_progress.dart
│   │   ├── yacht_dice_saves.dart
│   │   ├── twenty48_saves.dart
│   │   ├── hearts_saves.dart
│   │   ├── mancala_saves.dart
│   │   └── bluff_bar_saves.dart
│   ├── daos/                  # 数据访问对象
│   └── providers/             # 数据库 providers
│
├── games/                     # 游戏实现
│   ├── hit_and_blow/          # 猜数字游戏
│   ├── yacht_dice/            # 游艇骰子游戏
│   ├── guess_arrangement/     # 猜排列游戏
│   ├── twenty48/              # 2048 益智游戏
│   ├── mancala/               # 播棋游戏
│   ├── hearts/                # 红心大战卡牌游戏
│   ├── bluff_bar/             # 吹牛酒吧卡牌游戏
│   └── dice_battle/           # 骰子对战 RPG
│
├── ui/                        # 共享 UI 层
│   ├── screens/               # 应用页面 (首页、设置)
│   ├── widgets/               # 可复用组件
│   │   ├── game_card.dart
│   │   ├── wooden_button.dart
│   │   └── wooden_app_bar.dart
│   └── theme/                 # 主题系统
│       ├── app_theme.dart
│       ├── wooden_colors.dart
│       ├── starlight_colors.dart
│       ├── forest_colors.dart
│       ├── theme_colors.dart  # 主题感知扩展
│       └── theme_provider.dart
│
├── l10n/                      # 国际化
│   ├── app_en.arb             # 英文
│   ├── app_zh.arb             # 中文
│   └── generated/             # 生成的本地化文件
│
├── providers/                 # 全局状态 providers
├── models/                    # 共享数据模型
├── utils/                     # 工具类
└── main.dart                  # 应用入口
```

### 架构设计

**三层架构：**
- **数据层** (`data/`): Drift 数据库、表、DAO 用于持久化
- **游戏层** (`games/`): Flame 引擎、游戏逻辑、AI 系统
- **UI层** (`ui/`): Flutter 组件、页面、主题系统

---

## 主题系统

本应用支持 **3 种配色方案 × 2 种亮度模式 = 6 种主题组合**：

| 配色方案 | 浅色模式 | 深色模式 |
|--------------|------------|-----------|
| **木质 (Wooden)** | 暖木色调（卡其色、棕色） | 深胡桃色（深棕、乌木） |
| **星空 (Starlight)** | 柔和紫色、天蓝色 | 深紫色、深蓝色 |
| **森林 (Forest)** | 柔和绿色、薄荷色 | 墨绿色（深森林色） |

### 主题感知颜色使用

开发组件时，**务必使用主题感知颜色**，通过 `context.theme*` 扩展访问：

```dart
import 'package:flutter/material.dart';
import '../../ui/theme/theme_colors.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ 正确：自动适配木质/星空/森林 + 深色/浅色
      color: context.themeBackground,
      child: Text(
        '你好',
        style: TextStyle(color: context.themeTextPrimary),
      ),
    );
  }
}
```

### 可用的主题颜色

| 扩展属性 | 用途 |
|-----------|-------|
| `context.themePrimary` | 主色（AppBar、主要按钮） |
| `context.themeBackground` | 背景色（Scaffold） |
| `context.themeSurface` | 表面色（卡片、容器） |
| `context.themeCard` | 卡片背景 |
| `context.themeAccent` | 强调色（图标、高亮） |
| `context.themeTextPrimary` | 主要文字 |
| `context.themeTextSecondary` | 次要文字 |
| `context.themeBorder` | 边框色 |
| `context.themeOnPrimary` | 主色上的文字/图标（AppBar 图标） |
| `context.themeSuccess` | 成功/正面颜色 |
| `context.themeError` | 错误/负面颜色 |
| `context.themeWarning` | 警告颜色 |

### ❌ 绝对禁止硬编码颜色

```dart
// ❌ 错误：这会破坏星空/森林主题
Icon(Icons.settings, color: WoodenColors.accentAmber),

// ✅ 正确：适用于所有主题
Icon(Icons.settings, color: context.themeOnPrimary),
```

### 已适配主题的共享组件

以下组件已正确适配多主题：
- `WoodenButton` - 按钮（primary、secondary、accent、ghost 变体）
- `WoodenAppBar` - 应用栏
- `GameCard` - 游戏卡片
- `ThemeToggle` - 主题切换控件

---

## 贡献指南

欢迎贡献代码！请遵循以下指南。

### 开发环境设置

1. Fork 仓库
2. 创建功能分支: `git checkout -b feature/amazing-feature`
3. 按照现有模式进行修改
4. 运行测试和检查: `flutter analyze && flutter test`
5. 使用 [Conventional Commits](https://www.conventionalcommits.org/) 提交
6. 推送: `git push origin feature/amazing-feature`
7. 创建 Pull Request

### 代码规范

- **文件命名**: `snake_case` (如 `game_records_dao.dart`)
- **类命名**: `PascalCase` (如 `GameRecordsDao`)
- **方法/变量**: `camelCase` (如 `getHighScore`)
- **私有成员**: `_prefix` (如 `_database`)
- 提交前运行 `flutter format .`

### 提交信息格式

```
<类型>(<范围>): <描述>

类型: feat, fix, docs, refactor, test, chore
范围: game, ui, data, i18n, theme, deps

示例:
- feat(game): 添加红心大战 AI 困难难度
- fix(data): 修正最高分计算
- docs(readme): 添加安装章节
- refactor(ui): 将主题颜色提取为扩展方法
```

### 添加新游戏

1. 创建游戏文件夹: `lib/games/<game_name>/`
2. 实现:
   - Provider (Riverpod 状态管理)
   - Screen (主游戏 UI)
   - Models (游戏状态、数据结构)
   - Components (可复用组件)
   - AI (如需要: easy、medium、hard)
3. 在 `lib/models/game_type.dart` 的 `GameType` 枚举中添加
4. 更新 `lib/ui/screens/home_screen.dart` 导航
5. 在 `lib/l10n/app_en.arb` 和 `app_zh.arb` 添加本地化字符串
6. 如需存档系统则创建数据库表
7. 更新此 README

---

## 使用的库和素材

- [Flutter](https://flutter.dev) - 跨平台框架
- [Dart](https://dart.dev) - 编程语言
- [Flame](https://flame-engine.org) - 游戏引擎
- [Riverpod](https://riverpod.dev) - 状态管理
- [Drift](https://drift.simonbinder.eu) - 数据库
- [flutter_localizations](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization) - 国际化

---

## 许可证

本项目采用 MIT 许可证 - 详情见 [LICENSE](LICENSE) 文件。

版权所有 (c) 2021 ZeroGo Yoosee

---

## 致谢

- 灵感来自 Nintendo Switch 的《世界游戏大全51》
- 使用出色的 Flame 游戏引擎构建
- 感谢 Flutter 和 Dart 社区
- AI 算法改编自经典博弈论实现

---

<p align="center">
  用 Flutter & Flame 以 ❤️ 制作
</p>