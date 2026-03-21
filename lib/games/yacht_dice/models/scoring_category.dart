enum ScoringCategory {
  ones,
  twos,
  threes,
  fours,
  fives,
  sixes,
  allSelect,
  fullHouse,
  fourOfAKind,
  smallStraight,
  largeStraight,
  yacht,
}

extension ScoringCategoryExtension on ScoringCategory {
  String get displayName {
    switch (this) {
      case ScoringCategory.ones:
        return 'Ones';
      case ScoringCategory.twos:
        return 'Twos';
      case ScoringCategory.threes:
        return 'Threes';
      case ScoringCategory.fours:
        return 'Fours';
      case ScoringCategory.fives:
        return 'Fives';
      case ScoringCategory.sixes:
        return 'Sixes';
      case ScoringCategory.allSelect:
        return 'All of a Kind';
      case ScoringCategory.fullHouse:
        return 'Full House';
      case ScoringCategory.fourOfAKind:
        return 'Four of a Kind';
      case ScoringCategory.smallStraight:
        return 'Small Straight';
      case ScoringCategory.largeStraight:
        return 'Large Straight';
      case ScoringCategory.yacht:
        return 'Yacht';
    }
  }
}
