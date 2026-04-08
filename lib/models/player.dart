/// Represents a player in the game
class Player {
  final String name;
  final bool isHuman;
  final String? aiDifficulty; // Store as string to avoid circular dependency

  const Player({required this.name, required this.isHuman, this.aiDifficulty});
}
