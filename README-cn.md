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

### 后续计划
- 小幅 UI 调整
- Bug 修复

## 猜排列
一款受推演类桌游启发的猜牌游戏。

### 描述
两位玩家各自从标准52张牌堆中抽取8张牌，牌面朝下按从小到大排列（A=1，K=13）。玩家轮流猜测对手的牌，猜测位置和点数。

**游戏规则：**
- 猜牌："第3张是7"（只猜点数，不猜花色）
- 猜对：翻开该牌，继续猜测，累计连击
- 猜错：回合交给对手，连击归零
- 胜利条件：先翻开对手所有牌的玩家获胜

**游戏模式：**
- **双人对战**：本地多人，回合切换与隐藏牌面
- **简单 AI**：随机猜测策略
- **中等 AI**：基于规则的推演，考虑位置关系
- **困难 AI**：启发式搜索，概率分析

### 特性
- 卡牌翻转动画效果
- 连击追踪系统
- AI 回合总结
- 游戏记录持久化

## 游艇骰子
游艇骰子灵感来自 Nintendo Switch 的《世界游戏大全51》中的游艇骰子。

<p align="center">
<img alt="游艇骰子" src="arts/dices.webp">
</p>

### 描述
这是一个互相投掷骰子凑出排列组合、竞争总分的游戏。如果凑出不错的组合，就双击对应分数用于确认分数，选过的排列组合不能再次选择。可以单击骰子，只保留点数不错的骰子再重新投掷。在重新投掷之后也可以改变保留的骰子。每轮都必须填到表格中，即使没有任何排列组合。最后总分高的人获胜！

### 后续计划
- 排行榜
- 人机对战
- 多人游戏

## 2048
经典滑块益智游戏。

### 描述
向四个方向滑动方块，合并相同数字的方块。当两个相同数字的方块碰撞时，它们会合并成一个数值翻倍的方块。尝试达到2048方块！

**游戏规则：**
- 上下左右滑动移动所有方块
- 相同数字的方块碰撞时会合并
- 每次移动后随机生成新方块（90%概率为2，10%概率为4）
- 无法移动时游戏结束

**计分系统：**
- 基础分数 = 合并后的方块数值（如两个4合并得8分）
- 单次滑动多个合并：×1.5 奖励
- 连续合并滑动：×2 奖励

**特性：**
- 方块滑动和生成动画效果
- 最多5个存档位
- 最高分记录
- 游戏计时器
- 明/暗主题支持

## 播棋
古老的播种策略游戏。

### 描述
在这款经典棋盘游戏中收集比对手更多的种子！每位玩家有6个小坑和1个大坑。从你的一个小坑中取出所有种子，逆时针播撒。

**游戏规则：**
- 从你一侧的一个小坑中取出所有种子
- 逆时针逐个播撒，跳过对手的大坑
- 落入你自己的大坑：再来一次！
- 落入你的空坑且对面有种子：捕获对面所有种子！
- 当一方小坑全部为空时游戏结束，剩余种子归其所有者
- 种子多者获胜

**游戏模式：**
- **双人对战**：本地多人
- **简单 AI**：随机选择
- **中等 AI**：基础启发式
- **困难 AI**：Minimax 算法带 Alpha-Beta 剪枝

**特性：**
- 种子播撒动画
- 回合指示器
- 分数追踪
- 游戏计时器

## 骰子对战 🚧 (开发中)
骰子对战游戏 - 敬请期待！

# 使用的库和素材
- [Flutter](https://flutter.dev)
- [Dart](https://dart.dev)
- [Flame](https://flame-engine.org)
- [Riverpod](https://riverpod.dev)
- [Drift](https://drift.simonbinder.eu)
- [flutter_intl](https://pub.dev/packages/flutter_intl)

# 技术栈

| 层级 | 技术 |
|-------|------------|
| UI/游戏引擎 | Flame 1.36+ |
| 状态管理 | Riverpod |
| 数据库 | Drift (SQLite) |
| 国际化 | flutter_intl |
| 框架 | Flutter 3.27+ |
| 语言 | Dart 3.6+ |

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