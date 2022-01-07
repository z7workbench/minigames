// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app": MessageLookupByLibrary.simpleMessage("Mini Games"),
        "check": MessageLookupByLibrary.simpleMessage("Check"),
        "description": MessageLookupByLibrary.simpleMessage("Game info"),
        "hnb_answer": MessageLookupByLibrary.simpleMessage("Correct answer"),
        "hnb_desc": MessageLookupByLibrary.simpleMessage(
            "This is a game of guessing the hidden n numbers and positions, with the default n being 4. Select n-2 numbers from 1 to n and place them in the positions, then press \"Check\" to check for correctness. Each position will be judged as \"all correct\" (indicated by colored check marks) or \"half correct\" (indicated by grey check marks), the number of former is the number of correct positions and numbers, the number of latter is the number of correct numbers. If it fails, you can try again until you get it right! "),
        "hnb_title": MessageLookupByLibrary.simpleMessage("Hit and Blow"),
        "leaderboard": MessageLookupByLibrary.simpleMessage("Leaderboard"),
        "minesweeper_desc": MessageLookupByLibrary.simpleMessage(
            "Get ask reduce skin. Child never forget less herself reveal. City example similar service billion store large. Book term although believe. Religious out opportunity upon note."),
        "minesweeper_title":
            MessageLookupByLibrary.simpleMessage("Minesweeper"),
        "restart_game": MessageLookupByLibrary.simpleMessage("Restart Game"),
        "start_game": MessageLookupByLibrary.simpleMessage("Start Game")
      };
}
