import 'dart:math';

import '../../guess_arrangement/models/playing_card.dart';
import '../models/bluff_bar_state.dart';
import '../models/bluff_bar_player.dart';
import '../models/enums.dart';

/// Utility function to check if a card is a Joker
bool isJoker(PlayingCard card) {
  return card.isJoker;
}

/// Bluff Bar game rules validator and logic
class BluffBarRules {
  /// Create main deck: 24 standard cards (5xJ/Q/K/A) + 4 Jokers = 24 cards
  static List<PlayingCard> createMainDeck() {
    final cards = <PlayingCard>[];
    
    // 5 Jacks (Spades)
    for (int i = 0; i < 5; i++) {
      cards.add(const PlayingCard(suit: CardSuit.spades, rank: CardRank.jack));
    }
    
    // 5 Queens (Diamonds)
    for (int i = 0; i < 5; i++) {
      cards.add(const PlayingCard(suit: CardSuit.diamonds, rank: CardRank.queen));
    }
    
    // 5 Kings (Clubs)
    for (int i = 0; i < 5; i++) {
      cards.add(const PlayingCard(suit: CardSuit.clubs, rank: CardRank.king));
    }
    
    // 5 Aces (Hearts)
    for (int i = 0; i < 5; i++) {
      cards.add(const PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace));
    }
    
    // 4 Jokers
    for (int i = 0; i < 4; i++) {
      cards.add(const PlayingCard(suit: CardSuit.hearts, rank: CardRank.king, isJoker: true));
    }
    
    return cards;
  }

  /// Create table deck: 1J + 1Q + 1K + 1A for target selection
  static List<PlayingCard> createTableDeck() {
    return [
      const PlayingCard(suit: CardSuit.spades, rank: CardRank.jack),
      const PlayingCard(suit: CardSuit.diamonds, rank: CardRank.queen),
      const PlayingCard(suit: CardSuit.clubs, rank: CardRank.king),
      const PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace),
    ];
  }

  /// Check if a card is valid for a given claim (target card + Joker are valid)
  static bool isValidCard(PlayingCard card, PlayingCard targetCard, bool isJokerWild) {
    if (isJokerWild && isJoker(card)) return true;
    return card.rank == targetCard.rank && card.suit == targetCard.suit;
  }

  /// Check if play contains any fake cards
  static bool containsFakeCards(List<PlayingCard> cards, PlayingCard targetCard) {
    return cards.any((c) => !isValidCard(c, targetCard, true));
  }

  /// Resolve challenge: return ChallengeResult
  /// Simplified version using just claimed rank
  static ChallengeResult resolveChallenge(
    List<PlayingCard> actualCards,
    CardRank claimedRank,
  ) {
    // Check if all cards match the claimed rank (jokers are wild)
    final hasFakeCards = actualCards.any((c) =>
        c.rank != claimedRank && !isJoker(c));
    return hasFakeCards ? ChallengeResult.liarGuilty : ChallengeResult.liarInnocent;
  }

  /// Resolve challenge with full card info (alternative version)
  static ChallengeResult resolveChallengeWithTarget(
    List<PlayingCard> actualCards,
    PlayingCard claimedCard,
    PlayingCard targetCard,
  ) {
    final hasFakeCards = actualCards.any((c) => !isValidCard(c, targetCard, true));
    return hasFakeCards ? ChallengeResult.liarGuilty : ChallengeResult.liarInnocent;
  }

  /// Check if player can play (must have cards and not eliminated)
  static bool canPlay(BluffBarPlayer player, BluffBarState state) {
    return !player.isEliminated && player.hand.isNotEmpty;
  }

  /// Clockwise order: South(0) → East(1) → North(3) → West(2)
  static const _clockwiseOrder = [0, 1, 3, 2];

  /// Get next non-eliminated player (clockwise)
  static int getNextPlayer(int currentIndex, List<BluffBarPlayer> players) {
    final currentPos = _clockwiseOrder.indexOf(currentIndex);
    for (int i = 1; i <= 4; i++) {
      final nextPos = (currentPos + i) % 4;
      final nextIndex = _clockwiseOrder[nextPos];
      if (!players[nextIndex].isEliminated) {
        return nextIndex;
      }
    }
    return currentIndex; // All others eliminated
  }

  /// Get next active player (not eliminated and has cards)
  /// Alias for getNextPlayer for provider compatibility
  static int getNextActivePlayer(int currentIndex, List<BluffBarPlayer> players) {
    final currentPos = _clockwiseOrder.indexOf(currentIndex);
    for (int i = 1; i <= 4; i++) {
      final nextPos = (currentPos + i) % 4;
      final nextIndex = _clockwiseOrder[nextPos];
      final player = players[nextIndex];
      if (!player.isEliminated && player.hand.isNotEmpty) {
        return nextIndex;
      }
    }
    return currentIndex; // No other active player
  }

  /// Check if a play is legal
  static bool isLegalPlay(
    List<int> cardIndices,
    CardRank claimedRank,
    BluffBarPlayer player,
    BluffBarState state,
  ) {
    // Validate indices
    if (cardIndices.isEmpty) return false;
    if (cardIndices.any((i) => i < 0 || i >= player.hand.length)) return false;
    if (cardIndices.length > 4) return false; // Max 4 cards per play

    // Player must be active
    if (player.isEliminated) return false;

    return true;
  }

  /// Get all playable cards for current player
  static List<PlayingCard> getPlayableCards(
    BluffBarPlayer player,
    BluffBarState state,
  ) {
    if (player.isEliminated || player.hand.isEmpty) return [];
    return player.hand;
  }

  /// Check if round should end (only 1 active player)
  static bool shouldEndRound(List<BluffBarPlayer> players) {
    final active = players.where((p) => !p.isEliminated && p.hand.isNotEmpty);
    return active.length <= 1;
  }

  /// Check if game should end (only 1 survivor)
  static bool shouldEndGame(List<BluffBarPlayer> players) {
    final survivors = players.where((p) => !p.isEliminated);
    return survivors.length <= 1;
  }

  /// Validate play action
  static bool isValidPlay(
    List<PlayingCard> selectedCards,
    PlayingCard claimedCard,
    BluffBarPlayer player,
    BluffBarState state,
  ) {
    if (selectedCards.isEmpty) return false;
    if (selectedCards.length > 5) return false;
    
    // Check if all selected cards are in player's hand
    for (var card in selectedCards) {
      bool found = false;
      for (var handCard in player.hand) {
        if (handCard.hasSameValue(card)) {
          found = true;
          break;
        }
      }
      if (!found) return false;
    }
    
    return true;
  }

  /// Validate if claimed card matches target suit (for legal claims)
  static bool isValidClaim(PlayingCard claimedCard, PlayingCard targetCard) {
    return claimedCard.rank == targetCard.rank && claimedCard.suit == targetCard.suit;
  }

  /// Count valid cards in hand for current target
  static int countValidCards(
    List<PlayingCard> hand, 
    PlayingCard targetCard, 
    bool jokersWild,
  ) {
    return hand.where((c) => isValidCard(c, targetCard, jokersWild)).length;
  }

  /// Count jokers in hand
  static int countJokers(List<PlayingCard> hand) {
    return hand.where((c) => isJoker(c)).length;
  }

  /// Shuffle deck using Fisher-Yates algorithm
  static List<PlayingCard> shuffleDeck(
    List<PlayingCard> deck, 
    Random random,
  ) {
    final shuffled = List<PlayingCard>.from(deck);
    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }

  /// Deal cards to players equally from deck
  static Map<String, dynamic> dealCards(
    List<PlayingCard> deck,
    List<BluffBarPlayer> players,
    Random random,
  ) {
    final shuffledDeck = shuffleDeck(deck, random);
    final cardsPerPlayer = shuffledDeck.length ~/ players.length;
    final dealtPlayers = <BluffBarPlayer>[];
    int cardIndex = 0;

    for (var player in players) {
      final hand = shuffledDeck.sublist(
        cardIndex,
        cardIndex + cardsPerPlayer,
      );
      dealtPlayers.add(player.copyWith(hand: hand));
      cardIndex += cardsPerPlayer;
    }

    // Remaining cards go back to deck
    final remainingDeck = shuffledDeck.sublist(cardIndex);
    return {
      'players': dealtPlayers,
      'remainingDeck': remainingDeck,
    };
  }

  /// Validate if challenge can be made
  static bool canChallenge(
    int challengerIndex,
    int lastPlayerIndex,
    BluffBarPlayer challenger,
  ) {
    return challengerIndex != lastPlayerIndex && 
           !challenger.isEliminated;
  }
}