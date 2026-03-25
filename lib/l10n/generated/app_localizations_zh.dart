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
  String get game_2048 => '2048';

  @override
  String get t48_gameDescription => '合并方块，达到2048！';

  @override
  String get t48_instructions => '滑动移动方块。相同数字的方块相撞时会合并。尝试达到2048！';

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
}
