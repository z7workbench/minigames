// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mini Games';

  @override
  String get appName => 'Mini Games';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get restart => 'Restart';

  @override
  String get quit => 'Quit';

  @override
  String get newGame => 'New Game';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get time => 'Time';

  @override
  String get attempts => 'Attempts';

  @override
  String get score => 'Score';

  @override
  String get highScore => 'High Score';

  @override
  String get gameOver => 'Game Over';

  @override
  String get youWin => 'You Win!';

  @override
  String get youLose => 'You Lose';

  @override
  String get duration => 'Duration';

  @override
  String get seconds => 'seconds';

  @override
  String get game_hit_and_blow => 'Hit & Blow';

  @override
  String get hnb_gameDescription =>
      'Guess the hidden numbers and their positions!';

  @override
  String get hnb_instructions =>
      'Select numbers and place them in positions, then press Check to see if they\'re correct. A Hit means correct number in correct position. A Blow means correct number in wrong position.';

  @override
  String get hnb_enterGuess => 'Enter your guess';

  @override
  String get hnb_check => 'Check';

  @override
  String hnb_attempt(int n) {
    return 'Attempt $n';
  }

  @override
  String get hnb_hit => 'Hit';

  @override
  String get hnb_blow => 'Blow';

  @override
  String get hnb_attemptsRemaining => 'Attempts Remaining';

  @override
  String get hnb_attemptsUsed => 'Attempts Used';

  @override
  String get hnb_outOfAttempts => 'Out of attempts!';

  @override
  String get hnb_selectDifficulty => 'Select Difficulty';

  @override
  String get hnb_easyMode => 'Easy Mode';

  @override
  String get hnb_hardMode => 'Hard Mode';

  @override
  String get hnb_simpleDescription => '4 positions, digits 1-6';

  @override
  String get hnb_hardDescription => '6 positions, digits 1-8';

  @override
  String get hnb_gameWon => 'Congratulations! You guessed the number!';

  @override
  String get hnb_gameLost => 'Game Over! The correct number was: ';

  @override
  String get hnb_newRecord => 'New Record!';

  @override
  String get hnb_guessHistory => 'Guess History';

  @override
  String get hnb_targetNumber => 'Target Number';

  @override
  String get hnb_clear => 'Clear';

  @override
  String hnb_attemptsFormat(int current, int max) {
    return 'Attempts: $current / $max';
  }

  @override
  String get game_yacht_dice => 'Yacht Dice';

  @override
  String get yd_gameDescription =>
      'Roll dice to make combinations and score points!';

  @override
  String get yd_instructions =>
      'Roll the dice and select scoring categories. You can re-roll up to 2 times by keeping good dice. The player with the highest score wins!';

  @override
  String get yd_rollDice => 'Roll Dice';

  @override
  String yd_roll(int n) {
    return 'Roll $n';
  }

  @override
  String get yd_keepDice => 'Keep';

  @override
  String get yd_releaseDice => 'Release';

  @override
  String get yd_rollsRemaining => 'Rolls Remaining';

  @override
  String get yd_rollsUsed => 'Rolls Used';

  @override
  String get yd_selectCategory => 'Select Category';

  @override
  String get yd_confirmScore => 'Confirm Score';

  @override
  String yd_confirmScoreMessage(String category, int score) {
    return 'Select $category for $score points?';
  }

  @override
  String get yd_categoryAlreadyUsed => 'Category already used';

  @override
  String get yd_playerTurn => 'Player\'s Turn';

  @override
  String yd_player(int n) {
    return 'Player $n';
  }

  @override
  String get yd_ai => 'Computer';

  @override
  String get yd_selectPlayers => 'Select Players';

  @override
  String get yd_onePlayer => '1 Player';

  @override
  String get yd_twoPlayers => '2 Players';

  @override
  String get yd_vsAI => 'VS Computer';

  @override
  String get yd_aiDifficulty => 'AI Difficulty';

  @override
  String get yd_easyAI => 'Easy';

  @override
  String get yd_mediumAI => 'Medium';

  @override
  String get yd_hardAI => 'Hard';

  @override
  String get yd_bonus => 'Bonus';

  @override
  String get yd_bonusThreshold => 'Bonus at 63 points';

  @override
  String get yd_ones => 'Ones';

  @override
  String get yd_twos => 'Twos';

  @override
  String get yd_threes => 'Threes';

  @override
  String get yd_fours => 'Fours';

  @override
  String get yd_fives => 'Fives';

  @override
  String get yd_sixes => 'Sixes';

  @override
  String get yd_allSelect => 'Chance';

  @override
  String get yd_fullHouse => 'Full House';

  @override
  String get yd_fourOfAKind => 'Four of a Kind';

  @override
  String get yd_smallStraight => 'Small Straight';

  @override
  String get yd_largeStraight => 'Large Straight';

  @override
  String get yd_yacht => 'Yacht';

  @override
  String get yd_onesDescription => 'Sum of all ones';

  @override
  String get yd_twosDescription => 'Sum of all twos';

  @override
  String get yd_threesDescription => 'Sum of all threes';

  @override
  String get yd_foursDescription => 'Sum of all fours';

  @override
  String get yd_fivesDescription => 'Sum of all fives';

  @override
  String get yd_sixesDescription => 'Sum of all sixes';

  @override
  String get yd_allSelectDescription => 'Sum of all dice';

  @override
  String get yd_fullHouseDescription =>
      'Three of a kind and a pair - 25 points';

  @override
  String get yd_fourOfAKindDescription =>
      'Four dice showing the same face - sum of all dice';

  @override
  String get yd_smallStraightDescription => 'Sequence of four - 15 points';

  @override
  String get yd_largeStraightDescription => 'Sequence of five - 30 points';

  @override
  String get yd_yachtDescription => 'Five of a kind - 50 points';

  @override
  String get yd_wins => 'wins!';

  @override
  String get yd_draw => 'It\'s a draw!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System Default';

  @override
  String get sound => 'Sound';

  @override
  String get soundEnabled => 'Sound On';

  @override
  String get soundDisabled => 'Sound Off';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get normal => 'Normal';

  @override
  String get hard => 'Hard';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get fullscreenEnabled => 'Fullscreen On';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get yd_exitTitle => 'Exit Game';

  @override
  String get yd_exitMessage =>
      'Do you want to save your progress before exiting?';

  @override
  String get yd_exitWithoutSaving => 'Exit Without Saving';

  @override
  String get yd_saveAndExit => 'Save & Exit';

  @override
  String get yd_resumeTitle => 'Resume Game?';

  @override
  String get yd_resumeMessage =>
      'You have a saved game. Would you like to resume or start a new game?';

  @override
  String get yd_resumeGame => 'Resume Game';

  @override
  String get yd_startNewGame => 'Start New Game';

  @override
  String get yd_tapToKeep => 'Tap dice to keep/release';

  @override
  String get game_guess_arrangement => 'Guess Arrangement';

  @override
  String get ga_gameDescription =>
      'Guess your opponent\'s hidden cards in this card guessing game!';

  @override
  String get ga_twoPlayers => '2 Players';

  @override
  String get ga_easyAI => 'Easy AI';

  @override
  String get ga_mediumAI => 'Medium AI';

  @override
  String get ga_hardAI => 'Hard AI';

  @override
  String get ga_howToPlay => 'How to Play';

  @override
  String get ga_correct => 'CORRECT!';

  @override
  String get ga_wrongGuess => 'Wrong Guess';

  @override
  String get ga_switchTurns => 'Switch Turns';

  @override
  String get ga_readyToPlay => 'Ready to Play';

  @override
  String get ga_youWin => 'You Win!';

  @override
  String get ga_aiWins => 'AI Wins!';

  @override
  String get ga_playAgain => 'Play Again';

  @override
  String get ga_exit => 'Exit';

  @override
  String get game_2048 => '2048';

  @override
  String get t48_gameDescription => 'Combine tiles to reach 2048!';

  @override
  String get t48_instructions =>
      'Swipe to move tiles. When two tiles with the same number touch, they merge into one. Try to reach 2048!';

  @override
  String get t48_newGame => 'New Game';

  @override
  String get t48_continue => 'Continue';

  @override
  String get t48_loadGame => 'Load Game';

  @override
  String get t48_saveGame => 'Save Game';

  @override
  String t48_saveSlot(int n) {
    return 'Save Slot $n';
  }

  @override
  String get t48_emptySlot => 'Empty Slot';

  @override
  String get t48_maxTile => 'Max Tile';

  @override
  String get t48_elapsedTime => 'Time';

  @override
  String get t48_exitTitle => 'Exit Game';

  @override
  String get t48_exitMessage =>
      'Do you want to save your progress before exiting?';

  @override
  String get t48_exitWithoutSaving => 'Exit Without Saving';

  @override
  String get t48_saveAndExit => 'Save & Exit';

  @override
  String get t48_gameOver => 'Game Over!';

  @override
  String get t48_youWon => 'You Won!';

  @override
  String get t48_playAgain => 'Play Again';

  @override
  String t48_savedAt(String time) {
    return 'Saved: $time';
  }

  @override
  String get t48_selectSlot => 'Select a save slot';

  @override
  String get t48_noSaves => 'No saved games';

  @override
  String get t48_delete => 'Delete';

  @override
  String get t48_overwrite => 'Overwrite';
}
