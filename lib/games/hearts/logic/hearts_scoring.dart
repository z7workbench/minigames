import '../models/hearts_state.dart';
import '../models/hearts_player.dart';
import '../models/trick.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../utils/card_utils.dart';

/// Hearts scoring system
class HeartsScoring {
  /// Calculate round scores for all players
  /// Returns Map<playerIndex, roundScore>
  static Map<int, int> calculateRoundScores(HeartsState state) {
    final scores = <int, int>{0: 0, 1: 0, 2: 0, 3: 0};

    // Tally penalty points from each completed trick
    for (final trick in state.completedTricks) {
      final winner = trick.winnerIndex;
      final penalty = calculateTrickPenalty(trick);
      scores[winner] = (scores[winner] ?? 0) + penalty;
    }

    // Check for Shoot the Moon
    return applyShootMoon(scores);
  }

  /// Calculate penalty points in a single trick
  static int calculateTrickPenalty(Trick trick) {
    return trick.cards.fold(
      0,
      (sum, card) => sum + CardUtils.getPenaltyPoints(card),
    );
  }

  /// Check if someone shot the moon and apply scoring
  static Map<int, int> applyShootMoon(Map<int, int> scores) {
    // Find if anyone has 26 points (all penalties)
    int? moonShooter;
    for (final entry in scores.entries) {
      if (entry.value == 26) {
        moonShooter = entry.key;
        break;
      }
    }

    if (moonShooter != null) {
      // Apply Shoot the Moon scoring
      final adjustedScores = <int, int>{};
      for (int i = 0; i < 4; i++) {
        adjustedScores[i] = (i == moonShooter) ? 0 : 26;
      }
      return adjustedScores;
    }

    return scores;
  }

  /// Detect if shooting the moon is possible for a player
  static bool canShootMoon(HeartsPlayer player) {
    // Player has all 13 hearts + Queen of Spades
    final hearts = player.tricksWon
        .where((c) => c.suit == CardSuit.hearts)
        .length;
    final hasQueenOfSpades = player.tricksWon.any(
      (c) => c.suit == CardSuit.spades && c.rank == CardRank.queen,
    );

    return hearts == 13 && hasQueenOfSpades;
  }

  /// Check if a player is attempting to shoot the moon
  /// (has taken most/all penalty cards so far)
  static bool isAttemptingMoon(HeartsState state, int playerIndex) {
    final player = state.players[playerIndex];
    final othersPenalty = _calculateOthersPenalty(state, playerIndex);

    // If player has taken 20+ points and others have very few
    return player.roundScore >= 20 && othersPenalty <= 6;
  }

  static int _calculateOthersPenalty(HeartsState state, int excludeIndex) {
    int total = 0;
    for (int i = 0; i < state.players.length; i++) {
      if (i != excludeIndex) {
        total += state.players[i].roundScore;
      }
    }
    return total;
  }

  /// Update player scores after a round
  static List<int> applyRoundScores(
    List<HeartsPlayer> players,
    Map<int, int> roundScores,
  ) {
    final newTotalScores = <int>[];

    for (int i = 0; i < players.length; i++) {
      newTotalScores.add(players[i].totalScore + (roundScores[i] ?? 0));
    }

    return newTotalScores;
  }

  /// Check if game should end (someone reached threshold)
  static bool shouldEndGame(List<HeartsPlayer> players, {int threshold = 100}) {
    return players.any((p) => p.totalScore >= threshold);
  }

  /// Find the winner (player with lowest score)
  static int findWinner(List<HeartsPlayer> players) {
    int winnerIndex = 0;
    int lowestScore = players[0].totalScore;

    for (int i = 1; i < players.length; i++) {
      if (players[i].totalScore < lowestScore) {
        lowestScore = players[i].totalScore;
        winnerIndex = i;
      }
    }

    return winnerIndex;
  }

  /// Get final standings (sorted by score, lowest first)
  static List<int> getStandings(List<HeartsPlayer> players) {
    final indices = List.generate(4, (i) => i);
    indices.sort(
      (a, b) => players[a].totalScore.compareTo(players[b].totalScore),
    );
    return indices;
  }

  /// Calculate game statistics for display
  static GameStats calculateGameStats(HeartsState state) {
    final roundScores = calculateRoundScores(state);
    final moonShot =
        roundScores.values.any((s) => s == 0) &&
        roundScores.values.where((s) => s == 26).length == 3;

    int? moonShooterIndex;
    if (moonShot) {
      moonShooterIndex = roundScores.entries
          .firstWhere((e) => e.value == 0)
          .key;
    }

    return GameStats(
      roundScores: roundScores,
      moonShot: moonShot,
      moonShooterIndex: moonShooterIndex,
      roundComplete: state.completedTricks.length == 13,
    );
  }
}

/// Game statistics for display
class GameStats {
  final Map<int, int> roundScores;
  final bool moonShot;
  final int? moonShooterIndex;
  final bool roundComplete;

  const GameStats({
    required this.roundScores,
    required this.moonShot,
    this.moonShooterIndex,
    required this.roundComplete,
  });

  int get maxRoundScore => roundScores.values.reduce((a, b) => a > b ? a : b);
  int get minRoundScore => roundScores.values.reduce((a, b) => a < b ? a : b);
}
