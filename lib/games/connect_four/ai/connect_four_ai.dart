import '../models/connect_four_state.dart';

abstract class ConnectFourAi {
  Future<int?> findBestMove(
    ConnectFourState state, {
    Duration? timeLimit,
    bool Function()? isCancelled,
  });

  int getRandomDelay() => 300 + (DateTime.now().microsecond % 700);
}
