import 'package:hive/hive.dart';

class HnbLeaderboardItem extends HiveObject {
  int now;
  int usedTime;
  int count;

  HnbLeaderboardItem(
      {required this.now, required this.usedTime, required this.count});
}


class HnbLeaderboardAdapter extends TypeAdapter<HnbLeaderboardItem> {
  @override
  HnbLeaderboardItem read(BinaryReader reader) =>
      HnbLeaderboardItem(
          now: reader.read(), usedTime: reader.read(), count: reader.read());

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, HnbLeaderboardItem obj) {
    writer.write(obj.now);
    writer.write(obj.usedTime);
    writer.write(obj.count);
  }
}
