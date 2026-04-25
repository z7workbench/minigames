/// Game status enumeration
enum GameStatus {
  idle, // Not started
  setup, // Setting up game parameters
  dealing, // Cards being dealt
  playing, // Active play phase
  challenge, // Challenge phase active
  reveal, // Revealing played cards
  roulette, // Russian roulette phase
  roundEnd, // Round completed
  gameOver, // Game ended
}

/// Game phase enumeration for Bluff Bar
enum GamePhase {
  setup, // Initial setup (player count, difficulty)
  deal, // Dealing cards to players
  play, // Active play (claiming and playing cards)
  challenge, // Challenge decision phase
  reveal, // Revealing played cards
  roulette, // Russian roulette execution
  roundEnd, // Round summary
  gameOver, // Final results
}

/// Challenge result enumeration
enum ChallengeResult {
  liarGuilty, // Claim was false, challenger wins
  liarInnocent, // Claim was true, challenger loses
  noChallenge, // No challenge occurred
}

/// AI difficulty levels (reused from other games)
enum AiDifficulty { easy, medium, hard }