/// Keywords that define special mechanics in battle effects.
/// Each keyword represents a specific type of game rule or ability.
enum Keyword {
  /// Upgrade: Replace one dice with a higher-level dice.
  upgrade,

  /// Instant: Immediately deal X damage.
  instant,

  /// Perfect Block: Defense value >= Attack value, block all damage.
  perfectBlock,

  /// Disrupt: Reduce enemy dice values greater than 2 to 2.
  disrupt,

  /// Combo: After dealing damage, deal half damage again.
  combo,
}

extension KeywordExtension on Keyword {
  /// Display name for the keyword (Chinese).
  String get displayName {
    switch (this) {
      case Keyword.upgrade:
        return '升级';
      case Keyword.instant:
        return '瞬发';
      case Keyword.perfectBlock:
        return '完美格挡';
      case Keyword.disrupt:
        return '扰乱';
      case Keyword.combo:
        return '连击';
    }
  }

  /// English display name for the keyword.
  String get englishName {
    switch (this) {
      case Keyword.upgrade:
        return 'Upgrade';
      case Keyword.instant:
        return 'Instant';
      case Keyword.perfectBlock:
        return 'Perfect Block';
      case Keyword.disrupt:
        return 'Disrupt';
      case Keyword.combo:
        return 'Combo';
    }
  }

  /// Chinese display name for the keyword (alias for displayName).
  String get displayNameZh => displayName;

  /// English display name for the keyword (alias for englishName).
  String get displayNameEn => englishName;

  /// Detailed description of what the keyword does (Chinese).
  String get description {
    switch (this) {
      case Keyword.upgrade:
        return '将一个骰子替换为高等级骰子（D4→D6→D8→D12→D16）';
      case Keyword.instant:
        return '在伤害计算前立即造成X点伤害';
      case Keyword.perfectBlock:
        return '当防御值>=进攻值时，完全格挡所有伤害';
      case Keyword.disrupt:
        return '将敌方骰子中大于2的值降为2';
      case Keyword.combo:
        return '造成伤害后，再造成一半伤害';
    }
  }

  /// Detailed description of what the keyword does (English).
  String get descriptionEn {
    switch (this) {
      case Keyword.upgrade:
        return 'Replace one dice with a higher-level dice (D4→D6→D8→D12→D16)';
      case Keyword.instant:
        return 'Immediately deal X damage before damage calculation';
      case Keyword.perfectBlock:
        return 'When defense >= attack, block all damage completely';
      case Keyword.disrupt:
        return 'Reduce any enemy dice value > 2 to 2';
      case Keyword.combo:
        return 'After dealing damage, deal half the damage again';
    }
  }

  /// Chinese description for the keyword (alias for description).
  String get descriptionZh => description;

  /// Short example of how the keyword works (Chinese).
  String get example {
    switch (this) {
      case Keyword.upgrade:
        return '例：D4变为D6';
      case Keyword.instant:
        return '例：瞬发(5)立即造成5点伤害';
      case Keyword.perfectBlock:
        return '例：防御15 vs 进攻12 = 0伤害';
      case Keyword.disrupt:
        return '例：敌方骰子[4, 6, 3] → [2, 2, 2]';
      case Keyword.combo:
        return '例：12伤害 + 6额外 = 18总伤害';
    }
  }

  /// Short example of how the keyword works (English).
  String get exampleEn {
    switch (this) {
      case Keyword.upgrade:
        return 'E.g., D4 becomes D6';
      case Keyword.instant:
        return 'E.g., Instant(5) deals 5 damage immediately';
      case Keyword.perfectBlock:
        return 'E.g., Defense 15 vs Attack 12 = 0 damage';
      case Keyword.disrupt:
        return 'E.g., Enemy dice [4, 6, 3] → [2, 2, 2]';
      case Keyword.combo:
        return 'E.g., 12 damage + 6 bonus = 18 total';
    }
  }

  /// Chinese example for the keyword (alias for example).
  String get exampleZh => example;
}
