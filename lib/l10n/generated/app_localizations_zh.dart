// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '小游戏合集';

  @override
  String get appName => '小游戏合集';

  @override
  String get home => '首页';

  @override
  String get settings => '设置';

  @override
  String get back => '返回';

  @override
  String get play => '开始';

  @override
  String get pause => '暂停';

  @override
  String get restart => '重新开始';

  @override
  String get quit => '退出';

  @override
  String get newGame => '新游戏';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get ok => '确定';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get loading => '加载中...';

  @override
  String get time => '时间';

  @override
  String get attempts => '尝试次数';

  @override
  String get score => '得分';

  @override
  String get highScore => '最高分';

  @override
  String get gameOver => '游戏结束';

  @override
  String get youWin => '你赢了！';

  @override
  String get youLose => '你输了';

  @override
  String get duration => '用时';

  @override
  String get seconds => '秒';

  @override
  String get game_hit_and_blow => '猜数字';

  @override
  String get hnb_gameDescription => '猜出隐藏的数字和它们的位置！';

  @override
  String get hnb_instructions => '选择数字并放入位置，然后点击检查。命中表示数字和位置都正确，擦伤表示数字正确但位置错误。';

  @override
  String get hnb_enterGuess => '输入你的猜测';

  @override
  String get hnb_check => '检查';

  @override
  String hnb_attempt(int n) {
    return '第$n次尝试';
  }

  @override
  String get hnb_hit => '命中';

  @override
  String get hnb_blow => '擦伤';

  @override
  String get hnb_attemptsRemaining => '剩余尝试次数';

  @override
  String get hnb_attemptsUsed => '已用尝试次数';

  @override
  String get hnb_outOfAttempts => '尝试次数已用尽！';

  @override
  String get hnb_selectDifficulty => '选择难度';

  @override
  String get hnb_easyMode => '简单模式';

  @override
  String get hnb_hardMode => '困难模式';

  @override
  String get hnb_simpleDescription => '4个位置，数字1-6';

  @override
  String get hnb_hardDescription => '6个位置，数字1-8';

  @override
  String get hnb_gameWon => '恭喜！你猜对了！';

  @override
  String get hnb_gameLost => '游戏结束！正确答案是：';

  @override
  String get hnb_newRecord => '新纪录！';

  @override
  String get hnb_guessHistory => '猜测历史';

  @override
  String get hnb_targetNumber => '目标数字';

  @override
  String get hnb_clear => '清除';

  @override
  String hnb_attemptsFormat(int current, int max) {
    return '尝试次数：$current / $max';
  }

  @override
  String get game_yacht_dice => '游艇骰子';

  @override
  String get yd_gameDescription => '掷骰子组合得分！';

  @override
  String get yd_instructions =>
      '掷骰子并选择计分类别。你可以保留好骰子并重新掷剩余的骰子，最多重掷3次。得分最高的玩家获胜！';

  @override
  String get yd_rollDice => '掷骰子';

  @override
  String yd_roll(int n) {
    return '第$n次掷骰';
  }

  @override
  String get yd_keepDice => '保留';

  @override
  String get yd_releaseDice => '释放';

  @override
  String get yd_rollsRemaining => '剩余掷骰次数';

  @override
  String get yd_rollsUsed => '已用掷骰次数';

  @override
  String get yd_selectCategory => '选择类别';

  @override
  String get yd_confirmScore => '确认得分';

  @override
  String yd_confirmScoreMessage(String category, int score) {
    return '选择$category获取$score分？';
  }

  @override
  String get yd_categoryAlreadyUsed => '该类别已使用';

  @override
  String get yd_playerTurn => '玩家回合';

  @override
  String yd_player(int n) {
    return '玩家$n';
  }

  @override
  String get yd_ai => '电脑';

  @override
  String get yd_selectPlayers => '选择玩家';

  @override
  String get yd_onePlayer => '1人游戏';

  @override
  String get yd_twoPlayers => '2人对战';

  @override
  String get yd_vsAI => '人机对战';

  @override
  String get yd_aiDifficulty => '电脑难度';

  @override
  String get yd_easyAI => '简单';

  @override
  String get yd_mediumAI => '中等';

  @override
  String get yd_hardAI => '困难';

  @override
  String get yd_bonus => '奖励分';

  @override
  String get yd_bonusThreshold => '63分获得奖励';

  @override
  String get yd_ones => '一点';

  @override
  String get yd_twos => '二点';

  @override
  String get yd_threes => '三点';

  @override
  String get yd_fours => '四点';

  @override
  String get yd_fives => '五点';

  @override
  String get yd_sixes => '六点';

  @override
  String get yd_allSelect => '全选';

  @override
  String get yd_fullHouse => '葫芦';

  @override
  String get yd_fourOfAKind => '四同';

  @override
  String get yd_smallStraight => '小顺';

  @override
  String get yd_largeStraight => '大顺';

  @override
  String get yd_yacht => '游艇';

  @override
  String get yd_onesDescription => '所有一点之和';

  @override
  String get yd_twosDescription => '所有二点之和';

  @override
  String get yd_threesDescription => '所有三点之和';

  @override
  String get yd_foursDescription => '所有四点之和';

  @override
  String get yd_fivesDescription => '所有五点之和';

  @override
  String get yd_sixesDescription => '所有六点之和';

  @override
  String get yd_allSelectDescription => '所有骰子点数之和';

  @override
  String get yd_fullHouseDescription => '三条加一对 - 25分';

  @override
  String get yd_fourOfAKindDescription => '四个骰子相同 - 所有骰子之和';

  @override
  String get yd_smallStraightDescription => '连续四个数字 - 15分';

  @override
  String get yd_largeStraightDescription => '连续五个数字 - 30分';

  @override
  String get yd_yachtDescription => '五个骰子相同 - 50分';

  @override
  String get yd_wins => '获胜！';

  @override
  String get yd_draw => '平局！';

  @override
  String get settingsTitle => '设置';

  @override
  String get language => '语言';

  @override
  String get english => '英文';

  @override
  String get chinese => '中文';

  @override
  String get theme => '主题';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightTheme => '浅色';

  @override
  String get darkTheme => '深色';

  @override
  String get systemTheme => '跟随系统';

  @override
  String get sound => '声音';

  @override
  String get soundEnabled => '开启';

  @override
  String get soundDisabled => '关闭';

  @override
  String get difficulty => '难度';

  @override
  String get easy => '简单';

  @override
  String get normal => '普通';

  @override
  String get hard => '困难';

  @override
  String get fullscreen => '全屏';

  @override
  String get fullscreenEnabled => '全屏开启';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get yd_exitTitle => '退出游戏';

  @override
  String get yd_exitMessage => '退出前是否保存游戏进度？';

  @override
  String get yd_exitWithoutSaving => '不保存退出';

  @override
  String get yd_saveAndExit => '保存并退出';

  @override
  String get yd_resumeTitle => '继续游戏？';

  @override
  String get yd_resumeMessage => '您有未完成的游戏。是否继续游戏或开始新游戏？';

  @override
  String get yd_resumeGame => '继续游戏';

  @override
  String get yd_startNewGame => '开始新游戏';

  @override
  String get yd_tapToKeep => '点击骰子保留/释放';

  @override
  String get game_guess_arrangement => '猜排列';

  @override
  String get ga_gameDescription => '猜测对手隐藏的牌面，考验你的推理能力！';

  @override
  String get ga_twoPlayers => '双人对战';

  @override
  String get ga_easyAI => '简单AI';

  @override
  String get ga_mediumAI => '中等AI';

  @override
  String get ga_hardAI => '困难AI';

  @override
  String get ga_howToPlay => '游戏规则';

  @override
  String get ga_correct => '猜对了！';

  @override
  String get ga_wrongGuess => '猜错了';

  @override
  String get ga_switchTurns => '交换回合';

  @override
  String get ga_readyToPlay => '准备好了';

  @override
  String get ga_youWin => '你赢了！';

  @override
  String get ga_aiWins => 'AI赢了！';

  @override
  String get ga_playAgain => '再玩一次';

  @override
  String get ga_exit => '退出';

  @override
  String get ga_round => '回合';

  @override
  String get ga_turn => '轮次';

  @override
  String get ga_combo => '连击';

  @override
  String get ga_dealing => '发牌中...';

  @override
  String get ga_aiThinking => 'AI思考中...';

  @override
  String get ga_position => '位置';

  @override
  String get ga_yourTurn => '你的回合！';

  @override
  String get ga_opponentTurn => '对手回合';

  @override
  String get ga_cardsRemaining => '剩余牌数';

  @override
  String get ga_selectGameMode => '选择游戏模式';

  @override
  String get ga_gotIt => '明白了！';

  @override
  String ga_playerCards(String name) {
    return '$name的牌';
  }

  @override
  String get ga_yourCards => '你的牌';

  @override
  String get ga_tapToGuess => '点击牌来猜测';

  @override
  String ga_positionSelected(int position) {
    return '已选择位置 $position - 请在下方选择数字';
  }

  @override
  String get ga_selectNumber => '选择数字 (A-K)';

  @override
  String ga_guessCorrect(String card) {
    return '猜对了！$card';
  }

  @override
  String ga_guessCorrectCombo(String card, int combo) {
    return '猜对了！$card 连击 x$combo';
  }

  @override
  String ga_comboLabel(int n) {
    return '连击 x$n';
  }

  @override
  String get ga_clearSelection => '清除选择';

  @override
  String get ga_endTurn => '结束回合';

  @override
  String get ga_exitGameTitle => '退出游戏？';

  @override
  String get ga_exitGameMessage => '确定要退出吗？当前进度将丢失。';

  @override
  String get ga_restartGameTitle => '重新开始？';

  @override
  String get ga_restartGameMessage => '确定要重新开始游戏吗？';

  @override
  String get ga_restart => '重新开始';

  @override
  String ga_aiGuessing(int position, String rank) {
    return 'AI猜测: 位置$position 是 $rank';
  }

  @override
  String get ga_rule1Title => '1. 发牌';

  @override
  String get ga_rule1Desc => '每位玩家从52张牌中抽取8张，按从小到大（A=1最小，K=13最大）面朝下排列。';

  @override
  String get ga_rule2Title => '2. 猜测';

  @override
  String get ga_rule2Desc => '双方轮流猜对方的牌。例如：\"第3张是7\"。只需猜数字，不用猜花色。';

  @override
  String get ga_rule3Title => '3. 猜对';

  @override
  String get ga_rule3Desc => '翻开对方的牌！你可以继续猜测，连击数+1。';

  @override
  String get ga_rule4Title => '4. 猜错';

  @override
  String get ga_rule4Desc => '轮到对方猜测。你的连击数重置。';

  @override
  String get ga_rule5Title => '5. 胜负';

  @override
  String get ga_rule5Desc => '谁的牌先被全部翻开，谁就输了！';

  @override
  String get ga_winnerPlayer => '你';

  @override
  String get ga_winnerOpponent => '对手';

  @override
  String get ga_aiWrongGuess => 'AI猜错了！';

  @override
  String get ga_wrongGuessTitle => '猜错了！';

  @override
  String get ga_turnToYou => '轮到你了！';

  @override
  String get ga_turnToOpponent => '换对方回合了。';

  @override
  String get ga_continue => '继续';

  @override
  String get ga_aiRoundEnd => 'AI回合结束';

  @override
  String ga_aiCorrectCount(int correct, int total) {
    return 'AI猜对了 $correct/$total 次';
  }

  @override
  String ga_positionLabel(int n) {
    return '位置$n';
  }

  @override
  String ga_switchTurnHint(String name) {
    return '请将设备交给$name。\n记得隐藏你的牌！';
  }

  @override
  String ga_winnerWins(String name) {
    return '$name赢了！';
  }

  @override
  String ga_winnerLoses(String name) {
    return '$name赢了...';
  }

  @override
  String get ga_correctGuessesLabel => '正确猜测';

  @override
  String get ga_maxComboLabel => '最高连击';

  @override
  String get ga_playDurationLabel => '用时';

  @override
  String get ga_playAgainButton => '再来一局';

  @override
  String ga_durationFormat(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String get game_2048 => '2048';

  @override
  String get t48_gameDescription => '合并方块，达到2048！';

  @override
  String get t48_instructions => '滑动或使用方向键/WASD移动方块。相同数字的方块相撞时会合并。尝试达到2048！';

  @override
  String get t48_newGame => '新游戏';

  @override
  String get t48_continue => '继续游戏';

  @override
  String get t48_loadGame => '读取游戏';

  @override
  String get t48_saveGame => '保存游戏';

  @override
  String t48_saveSlot(int n) {
    return '存档 $n';
  }

  @override
  String get t48_emptySlot => '空存档';

  @override
  String get t48_maxTile => '最大方块';

  @override
  String get t48_elapsedTime => '用时';

  @override
  String get t48_exitTitle => '退出游戏';

  @override
  String get t48_exitMessage => '退出前是否保存游戏进度？';

  @override
  String get t48_exitWithoutSaving => '不保存退出';

  @override
  String get t48_saveAndExit => '保存并退出';

  @override
  String get t48_gameOver => '游戏结束！';

  @override
  String get t48_youWon => '你赢了！';

  @override
  String get t48_playAgain => '再玩一次';

  @override
  String t48_savedAt(String time) {
    return '保存时间：$time';
  }

  @override
  String get t48_selectSlot => '选择存档位置';

  @override
  String get t48_noSaves => '没有存档';

  @override
  String get t48_delete => '删除';

  @override
  String get t48_overwrite => '覆盖';

  @override
  String get t48_autoSave => '自动保存';

  @override
  String get t48_overwriteConfirm => '该存档位已有存档，是否覆盖？';

  @override
  String get t48_savedSuccessfully => '游戏已保存！';

  @override
  String get t48_autoSaveInfo => '游戏进行时每3分钟自动保存';

  @override
  String get db_battleLog => '战斗日志';

  @override
  String get db_battleStarted => '战斗开始...';

  @override
  String get game_mancala => '播棋';

  @override
  String get mc_gameDescription => '在这个古老的策略游戏中收集比对手更多的种子！';

  @override
  String get mc_instructions =>
      '从你的一个坑中取出所有种子，逆时针播撒。落入你的大坑可再玩一次。落入你的空坑可捕获对面坑中的种子！';

  @override
  String get mc_twoPlayers => '双人对战';

  @override
  String get mc_easyAI => '简单AI';

  @override
  String get mc_mediumAI => '中等AI';

  @override
  String get mc_hardAI => '困难AI';

  @override
  String get mc_howToPlay => '游戏规则';

  @override
  String get mc_yourTurn => '你的回合';

  @override
  String get mc_opponentTurn => '对手回合';

  @override
  String get mc_playerStore => '你的大坑';

  @override
  String get mc_opponentStore => '对手大坑';

  @override
  String get mc_youWin => '你赢了！';

  @override
  String get mc_youLose => '你输了！';

  @override
  String get mc_aiWins => 'AI赢了！';

  @override
  String get mc_draw => '平局！';

  @override
  String get mc_playAgain => '再玩一次';

  @override
  String get mc_exit => '退出';

  @override
  String get mc_selectPit => '点击坑位播种';

  @override
  String get mc_gameSaved => '游戏已保存';

  @override
  String get mc_extraTurn => '再来一次！';

  @override
  String get mc_captured => '捕获！';

  @override
  String get colorScheme => '配色方案';

  @override
  String get woodenScheme => '木质风格';

  @override
  String get starlightScheme => '星空风格';

  @override
  String get forestScheme => '森林风格';

  @override
  String get game_dice_battle => '骰子对战';

  @override
  String get db_gameDescription => '投掷骰子，制定策略，击败对手！';

  @override
  String get db_set1Name => '平衡组合';

  @override
  String get db_set2Name => '进攻组合';

  @override
  String get db_set3Name => '防守组合';

  @override
  String get db_set4Name => '全能组合';

  @override
  String get db_set5Name => '混合组合';

  @override
  String get db_attack => '进攻';

  @override
  String get db_defense => '防守';

  @override
  String get db_rollDice => '投掷骰子';

  @override
  String get db_reroll => '重投';

  @override
  String get db_confirm => '确认';

  @override
  String get db_finishAttack => '完成进攻';

  @override
  String get db_finishDefense => '完成防守';

  @override
  String db_rerollsRemaining(int n) {
    return '剩余重投次数：$n';
  }

  @override
  String db_selectAttackDice(int n) {
    return '选择进攻骰子（最多$n个）';
  }

  @override
  String db_selectDefenseDice(int n) {
    return '选择防守骰子（最多$n个）';
  }

  @override
  String db_totalPoints(int n) {
    return '总点数：$n';
  }

  @override
  String db_damageDealt(int n) {
    return '造成$n点伤害！';
  }

  @override
  String get db_perfectBlock => '完美格挡！';

  @override
  String db_comboHit(int n) {
    return '连击！造成$n点额外伤害！';
  }

  @override
  String get db_keywordUpgrade => '升级';

  @override
  String get db_keywordInstant => '瞬发';

  @override
  String get db_keywordPerfectBlock => '完美格挡';

  @override
  String get db_keywordDisrupt => '扰乱';

  @override
  String get db_keywordCombo => '连击';

  @override
  String get db_keywordUpgradeDesc => '将一个骰子替换为一个高等级的骰子。例：升级一个四面骰=将四面骰更改为六面骰';

  @override
  String get db_keywordInstantDesc => '达成效果时，对敌方造成x点伤害。例：瞬发(3)=立即对敌方造成3点伤害';

  @override
  String get db_keywordPerfectBlockDesc => '投出的防御点数大于或等于进攻点数';

  @override
  String get db_keywordDisruptDesc =>
      '触发效果时，使得敌方的某一个大于2点的骰子降低为2点，如果对方没有高于2点的骰子，则无事发生。';

  @override
  String get db_keywordComboDesc => '如果造成了伤害，则再次造成上一次伤害的一半伤害，连击的伤害向上取整。';

  @override
  String get db_effectOddBonus => '奇数之力';

  @override
  String get db_effectOddBonusDesc => '进攻时，如果都为奇数，则+5点数';

  @override
  String get db_effectEvenBonus => '偶数之盾';

  @override
  String get db_effectEvenBonusDesc => '防守时，如果都为偶数，则+4点数';

  @override
  String get db_effectComboLow => '低伤连击';

  @override
  String get db_effectComboLowDesc => '如果最终造成的伤害小于10点，则**连击**';

  @override
  String get db_effectDiceUpgrade => '骰子升级';

  @override
  String get db_effectDiceUpgradeDesc => '回合开始时**升级**双方一个骰子';

  @override
  String get db_effectPerfectInstant => '格挡瞬发';

  @override
  String get db_effectPerfectInstantDesc => '如果**完美格挡**，则**瞬发**(5)';

  @override
  String get db_effectComboHigh => '高攻连击';

  @override
  String get db_effectComboHighDesc => '如果进攻方总点数大于20点，则进攻方拥有**连击**';

  @override
  String get db_effectLifeSync => '生命共鸣';

  @override
  String get db_effectLifeSyncDesc => '回合结束时如果防守方和进攻方生命值之和为42点，则防守方获得+10生命值';

  @override
  String db_roundNumber(int n) {
    return '第$n回合';
  }

  @override
  String db_playerTurn(String name) {
    return '$name的回合';
  }

  @override
  String get db_attacking => '进攻中';

  @override
  String get db_defending => '防守中';

  @override
  String get db_calculating => '计算伤害中...';

  @override
  String get db_roundStart => '回合开始';

  @override
  String get db_roundEnd => '回合结束';

  @override
  String get db_coinFlip => '决定先后手...';

  @override
  String db_goesFirst(String name) {
    return '$name先手！';
  }

  @override
  String db_victory(String name) {
    return '$name获胜！';
  }

  @override
  String get db_playAgain => '再玩一次';

  @override
  String get db_exit => '退出';

  @override
  String get db_twoPlayers => '双人对战';

  @override
  String get db_easyAI => '简单AI';

  @override
  String get db_mediumAI => '中等AI';

  @override
  String get db_hardAI => '困难AI';

  @override
  String get db_selectDiceSet => '选择骰子组合';

  @override
  String get db_player1Select => '玩家1选择组合';

  @override
  String get db_player2Select => '玩家2选择组合';

  @override
  String get db_gameRules => '游戏规则';

  @override
  String get db_attackPoints => '进攻点数';

  @override
  String get db_defensePoints => '防守点数';

  @override
  String get db_diceConfig => '骰子配置';

  @override
  String db_healthRemaining(int hp) {
    return '剩余生命：$hp';
  }

  @override
  String get db_fieldEffect => '场地效果';

  @override
  String get db_noActiveEffect => '无场地效果';

  @override
  String get hearts_game_hearts => '红心大战';

  @override
  String get hearts_description => '避开红心和黑桃皇后！';

  @override
  String get hearts_howToPlay => '游戏规则';

  @override
  String get hearts_startGame => '开始游戏';

  @override
  String get hearts_playAgain => '再来一局';

  @override
  String get hearts_dealing => '发牌中...';

  @override
  String get hearts_passing => '传牌阶段';

  @override
  String get hearts_playing => '游戏中';

  @override
  String get hearts_roundEnd => '本局结束';

  @override
  String get hearts_gameOver => '游戏结束';

  @override
  String get hearts_aiThinking => 'AI思考中...';

  @override
  String get hearts_passDirection => '传牌方向';

  @override
  String get hearts_passLeft => '向左传';

  @override
  String get hearts_passRight => '向右传';

  @override
  String get hearts_passAcross => '向对面传';

  @override
  String get hearts_passHold => '不传牌';

  @override
  String hearts_selectCardsToPass(int n) {
    return '选择$n张牌传递';
  }

  @override
  String hearts_passTimer(int s) {
    return '剩余时间: $s秒';
  }

  @override
  String get hearts_confirmPass => '确认传牌';

  @override
  String get hearts_timerUnlimited => '无限时';

  @override
  String get hearts_timer15s => '15秒';

  @override
  String get hearts_timer20s => '20秒';

  @override
  String get hearts_timer30s => '30秒';

  @override
  String get hearts_yourTurn => '你的回合！';

  @override
  String get hearts_waitTurn => '等待对手...';

  @override
  String get hearts_heartsBroken => '红心已破！';

  @override
  String get hearts_firstTrick => '第一墩 - 梅花2先出';

  @override
  String hearts_trickWon(String player) {
    return '$player赢得此墩';
  }

  @override
  String get hearts_roundScores => '本局得分';

  @override
  String get hearts_totalScores => '总得分';

  @override
  String get hearts_pointsTaken => '得分';

  @override
  String hearts_heartsCount(int n) {
    return '红心: $n张';
  }

  @override
  String get hearts_shootMoon => '全收！';

  @override
  String get hearts_shootMoonSuccess => '成功全收！';

  @override
  String get hearts_announceMoonOption => '声明全收意图';

  @override
  String get hearts_hideMoonOption => '隐藏全收意图';

  @override
  String hearts_player(int n) {
    return '玩家$n';
  }

  @override
  String get hearts_you => '你';

  @override
  String get hearts_winner => '获胜者';

  @override
  String get hearts_finalResults => '最终结果';

  @override
  String get hearts_rule1Title => '1. 目标';

  @override
  String get hearts_rule1Desc => '避开红心（每张♥=1分）和黑桃皇后（♠Q=13分）。得分最低者获胜！';

  @override
  String get hearts_rule2Title => '2. 传牌';

  @override
  String get hearts_rule2Desc => '每局开始前传3张牌：左→右→对面→不传，每4局循环一次。';

  @override
  String get hearts_rule3Title => '3. 出牌';

  @override
  String get hearts_rule3Desc => '拥有梅花2的玩家先出。必须跟花色（如有）。红心未破前不能先出红心。';

  @override
  String get hearts_rule4Title => '4. 计分';

  @override
  String get hearts_rule4Desc => '收集全部14张罚分牌=全收（你得0分，其他各得26分）。任一玩家达到100分时游戏结束。';

  @override
  String get hearts_rule5Title => '5. 胜利';

  @override
  String get hearts_rule5Desc => '游戏结束时总得分最低者获胜！';

  @override
  String get hearts_resume => '继续';

  @override
  String get hearts_saveGame => '保存游戏';

  @override
  String get hearts_loadGame => '加载游戏';

  @override
  String get hearts_newGame => '新游戏';

  @override
  String get hearts_exitGame => '退出';

  @override
  String get hearts_aiDifficulty => 'AI难度';

  @override
  String get hearts_randomPosition => '随机玩家位置';

  @override
  String get hearts_passTimerSetting => '传牌计时';

  @override
  String get hearts_passComplete => '传牌完成';

  @override
  String get hearts_receivedCards => '你收到了这些牌：';

  @override
  String get hearts_continuePlaying => '继续';

  @override
  String get comingSoon => '即将推出';

  @override
  String get game_bluff_bar => '吹牛酒吧';

  @override
  String get bb_game_title => '吹牛酒吧';

  @override
  String get bb_game_subtitle => '虚张声势，挑战，生存';

  @override
  String get bb_gameDescription => '扑克风格的虚张声势游戏，带有俄罗斯轮盘淘汰机制';

  @override
  String get bb_phase_setup => '设置阶段';

  @override
  String get bb_phase_deal => '发牌阶段';

  @override
  String get bb_phase_play => '出牌阶段';

  @override
  String get bb_phase_challenge => '质疑阶段';

  @override
  String get bb_phase_reveal => '翻牌阶段';

  @override
  String get bb_phase_roulette => '俄罗斯轮盘';

  @override
  String get bb_phase_roundEnd => '本轮结束';

  @override
  String get bb_phase_gameOver => '游戏结束';

  @override
  String get bb_target_card => '目标牌';

  @override
  String get bb_target_jacks => '本轮目标：J';

  @override
  String get bb_target_queens => '本轮目标：Q';

  @override
  String get bb_target_kings => '本轮目标：K';

  @override
  String get bb_target_aces => '本轮目标：A';

  @override
  String get bb_play_cards => '出牌';

  @override
  String get bb_challenge => '质疑！';

  @override
  String get bb_pass => '跳过';

  @override
  String get bb_select_cards => '选择牌';

  @override
  String get bb_claim => '声称';

  @override
  String bb_claiming(int count, String rank) {
    return '$count张$rank';
  }

  @override
  String bb_cards_played(int count) {
    return '已出$count张牌';
  }

  @override
  String get bb_challenge_successful => '质疑成功！';

  @override
  String get bb_challenge_failed => '质疑失败';

  @override
  String get bb_liar_guilty => '抓到骗子！';

  @override
  String get bb_liar_innocent => '真诚出牌！';

  @override
  String get bb_roulette_draw => '翻开轮盘牌';

  @override
  String get bb_roulette_survived => '生存！';

  @override
  String get bb_roulette_eliminated => '淘汰！';

  @override
  String bb_roulette_remaining(int count) {
    return '剩余$count张牌';
  }

  @override
  String get bb_your_turn => '你的回合';

  @override
  String get bb_opponent_turn => '对手回合';

  @override
  String bb_cards_in_hand(int count) {
    return '手中有$count张牌';
  }

  @override
  String get bb_eliminated_player => '已淘汰';

  @override
  String get bb_ai_thinking => 'AI思考中...';

  @override
  String get bb_ai_playing => 'AI出牌...';

  @override
  String get bb_ai_challenging => 'AI质疑！';

  @override
  String bb_winner(String name) {
    return '$name获胜！';
  }

  @override
  String get bb_last_survivor => '最后幸存者';

  @override
  String get bb_play_again => '再来一次';

  @override
  String get bb_exit => '退出';

  @override
  String get bb_ai_difficulty => 'AI难度';

  @override
  String get bb_easy => '简单';

  @override
  String get bb_medium => '中等';

  @override
  String get bb_hard => '困难';

  @override
  String get bb_start_game => '开始游戏';

  @override
  String get bb_how_to_play => '游戏规则';

  @override
  String get bb_rule1_title => '1. 目标牌';

  @override
  String get bb_rule1_desc => '每轮随机指定J/Q/K/A为目标牌，该牌及Joker视为\"真牌\"';

  @override
  String get bb_rule2_title => '2. 出牌';

  @override
  String get bb_rule2_desc => '每回合打出1-5张牌背面朝上，声称是目标牌';

  @override
  String get bb_rule3_title => '3. 质疑';

  @override
  String get bb_rule3_desc => '喊\"骗子\"质疑上家，翻开验证：假牌则上家输，真牌则质疑者输';

  @override
  String get bb_rule4_title => '4. 淘汰';

  @override
  String get bb_rule4_desc => '输家触发俄罗斯轮盘：翻一张牌，实弹则淘汰';

  @override
  String get bb_rule5_title => '5. 胜利';

  @override
  String get bb_rule5_desc => '成为最后存活的玩家';

  @override
  String get bb_got_it => '明白了！';

  @override
  String get bb_two_players => '双人对战';

  @override
  String get bb_vs_ai => '人机对战';

  @override
  String get bb_eliminated => '已淘汰';

  @override
  String get bb_survived => '生存！';

  @override
  String get bb_draw_card => '翻开轮盘牌';

  @override
  String get bb_drawing => '正在翻开...';

  @override
  String bb_cards_remaining(int count) {
    return '剩余 $count 张牌';
  }

  @override
  String get bb_no_cards_played => '尚未出牌';

  @override
  String bb_cards_played_total(int count) {
    return '已出 $count 张牌';
  }

  @override
  String get bb_no_cards => '无手牌';

  @override
  String get bb_one_player_three_ai => '1名玩家 + 3名AI';

  @override
  String get bb_exit_confirm => '确定退出吗？游戏进度将丢失。';

  @override
  String bb_round(int number) {
    return '第 $number 轮';
  }

  @override
  String bb_round_ranking(int number) {
    return '第 $number 轮排名';
  }

  @override
  String get bb_roulette_shots => '已开枪';

  @override
  String get bb_select_claim => '选择声称的点数';

  @override
  String get bb_your_hand => '你的手牌';

  @override
  String bb_waiting_for(String name) {
    return '等待 $name...';
  }

  @override
  String get bb_game_screen_coming => '游戏页面即将推出！';

  @override
  String get bb_position_north => '北';

  @override
  String get bb_position_south => '南';

  @override
  String get bb_position_east => '东';

  @override
  String get bb_position_west => '西';

  @override
  String bb_challenge_title(String challenger, String challenged) {
    return '$challenger 质疑 $challenged';
  }

  @override
  String get bb_revealed_cards => '翻开的牌';

  @override
  String get bb_liar => '骗子！';

  @override
  String get bb_honest => '真诚！';

  @override
  String get bb_face_roulette => '开枪';

  @override
  String get bb_victory => '胜利';

  @override
  String get bb_defeat => '失败';

  @override
  String get bb_ranking => '排名';

  @override
  String bb_rounds_survived(int count) {
    return '存活 $count 轮';
  }
}
