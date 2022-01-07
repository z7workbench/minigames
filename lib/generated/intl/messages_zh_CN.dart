// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app": MessageLookupByLibrary.simpleMessage("迷你游戏合集"),
        "check": MessageLookupByLibrary.simpleMessage("检查"),
        "description": MessageLookupByLibrary.simpleMessage("游戏简介"),
        "hnb_answer": MessageLookupByLibrary.simpleMessage("正确答案"),
        "hnb_desc": MessageLookupByLibrary.simpleMessage(
            "这是一个猜出隐藏的n个数字和位置的游戏，默认n为4。从1-n中选择n-2个数字放到位置上，按下“检查”即可检查对错。每个位置会被判定为“全对”（用彩色对钩表示）或“半对”（用灰色对钩表示），前者为位置和数字都正确，后者为选取的数字正确。如果判定失败则再来一次，直到判断正确！"),
        "hnb_title": MessageLookupByLibrary.simpleMessage("猜数字组合"),
        "leaderboard": MessageLookupByLibrary.simpleMessage("排行榜"),
        "minesweeper_desc": MessageLookupByLibrary.simpleMessage(
            "网上或者看到软件查看，新闻我们发生主题包括工具其实，为什您的新闻看到只是都是下载。任何语言这里更多，帮助人民不能工程经济操作。欢迎新闻具有游戏，发布之间其实一个。"),
        "minesweeper_title": MessageLookupByLibrary.simpleMessage("扫雷"),
        "restart_game": MessageLookupByLibrary.simpleMessage("重开游戏"),
        "start_game": MessageLookupByLibrary.simpleMessage("开始游戏")
      };
}
