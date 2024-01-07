import 'package:hive_flutter/hive_flutter.dart';
import 'package:minigames/constants.dart';
import 'package:minigames/games/hnb/hnb_leaderboard.dart';

class HiveUtil {
  late Box hnbLeaderboardBox;

  HiveUtil._internal() {
    install();
  }

  factory HiveUtil() => _instance;
  static final HiveUtil _instance = HiveUtil._internal();

  install() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HnbLeaderboardAdapter());
    hnbLeaderboardBox = await Hive.openBox(hnb_hive);
  }
}
