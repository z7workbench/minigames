/// Game status enumeration
enum GameStatus {
  idle, // Not started
  dealing, // Cards being dealt
  passing, // Pass phase active
  passComplete, // Pass completed, showing received cards
  playing, // Trick-taking phase
  trickEnd, // Trick completed, waiting for next
  roundEnd, // Round completed, showing scores
  gameOver, // Game ended (someone reached 100)
}

/// Card passing direction (cycles every 4 rounds)
enum PassDirection {
  left, // Pass to left neighbor
  right, // Pass to right neighbor
  across, // Pass to opposite player
  none, // No passing this round
}

/// Pass timer options
enum TimerOption {
  unlimited, // No timer
  seconds15, // 15 seconds
  seconds20, // 20 seconds
  seconds30, // 30 seconds
}

/// Moon announcement visibility option
enum MoonAnnouncementOption {
  hidden, // Don't announce moon attempts
  announced, // Show moon attempt notification
}

/// AI difficulty levels
enum AiDifficulty { easy, medium, hard }
