import 'dart:math';
import 'package:minigames/games/pokers/poker.dart';

class PokerPopEngine {
  late PokerDeck pokers;
  int size = 24;

  PokerPopEngine({this.size = 24}) {
    PokerDeck deck = PokerFunctions.getRandomPokers(size ~/ 2);
    pokers = deck + deck;
    Random random = Random.secure();
    pokers.shuffle(random);
  }
}
