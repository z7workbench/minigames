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
  String get category_dice => 'Dice';

  @override
  String get category_cards => 'Cards';

  @override
  String get category_board => 'Board';

  @override
  String get category_reaction => 'Reaction';

  @override
  String get category_casual => 'Casual';

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
  String get hnb_start_game => 'Start Game';

  @override
  String get hnb_how_to_play => 'How to Play';

  @override
  String get hnb_rule1_title => 'Goal';

  @override
  String get hnb_rule1_desc =>
      'Guess the hidden number sequence. Each digit is unique and its position matters.';

  @override
  String get hnb_rule2_title => 'Hit';

  @override
  String get hnb_rule2_desc =>
      'A Hit means a digit is correct AND in the right position.';

  @override
  String get hnb_rule3_title => 'Blow';

  @override
  String get hnb_rule3_desc =>
      'A Blow means the digit exists in the target but is in the wrong position.';

  @override
  String get hnb_rule4_title => 'Winning';

  @override
  String get hnb_rule4_desc =>
      'Get all Hits to win! You have 10 attempts to crack the code.';

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
  String get darkMode => 'Dark Mode';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'Default';

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
  String get appDescription =>
      'Classic games for everyone - board, dice, cards and puzzles.';

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
  String get ga_round => 'Round';

  @override
  String get ga_turn => 'Turn';

  @override
  String get ga_combo => 'Combo';

  @override
  String get ga_dealing => 'Dealing cards...';

  @override
  String get ga_aiThinking => 'AI Thinking...';

  @override
  String get ga_position => 'Position';

  @override
  String get ga_yourTurn => 'Your Turn!';

  @override
  String get ga_opponentTurn => 'Opponent\'s Turn';

  @override
  String get ga_cardsRemaining => 'Cards Remaining';

  @override
  String get ga_selectGameMode => 'Select Game Mode';

  @override
  String get ga_gotIt => 'Got it!';

  @override
  String ga_playerCards(String name) {
    return '$name\'s Cards';
  }

  @override
  String get ga_yourCards => 'Your Cards';

  @override
  String get ga_tapToGuess => 'Tap a card to guess';

  @override
  String ga_positionSelected(int position) {
    return 'Position $position selected - Choose a number below';
  }

  @override
  String get ga_selectNumber => 'Select Number (A-K)';

  @override
  String ga_guessCorrect(String card) {
    return 'Correct! $card';
  }

  @override
  String ga_guessCorrectCombo(String card, int combo) {
    return 'Correct! $card Combo x$combo';
  }

  @override
  String ga_comboLabel(int n) {
    return 'Combo x$n';
  }

  @override
  String get ga_clearSelection => 'Clear Selection';

  @override
  String get ga_endTurn => 'End Turn';

  @override
  String get ga_exitGameTitle => 'Exit Game?';

  @override
  String get ga_exitGameMessage =>
      'Are you sure you want to exit? Current progress will be lost.';

  @override
  String get ga_restartGameTitle => 'Restart?';

  @override
  String get ga_restartGameMessage =>
      'Are you sure you want to restart the game?';

  @override
  String get ga_restart => 'Restart';

  @override
  String ga_aiGuessing(int position, String rank) {
    return 'AI Guessing: Position $position is $rank';
  }

  @override
  String get ga_rule1Title => '1. Dealing';

  @override
  String get ga_rule1Desc =>
      'Each player draws 8 cards from a 52-card deck, arranged face-down from low to high (A=1 lowest, K=13 highest).';

  @override
  String get ga_rule2Title => '2. Guessing';

  @override
  String get ga_rule2Desc =>
      'Players take turns guessing each other\'s cards. For example: \"Position 3 is a 7\". Guess the rank only, not the suit.';

  @override
  String get ga_rule3Title => '3. Correct Guess';

  @override
  String get ga_rule3Desc =>
      'Reveal opponent\'s card! You can continue guessing, combo +1.';

  @override
  String get ga_rule4Title => '4. Wrong Guess';

  @override
  String get ga_rule4Desc => 'Turn passes to opponent. Your combo resets.';

  @override
  String get ga_rule5Title => '5. Win Condition';

  @override
  String get ga_rule5Desc =>
      'The player whose cards are all revealed first loses!';

  @override
  String get ga_winnerPlayer => 'You';

  @override
  String get ga_winnerOpponent => 'Opponent';

  @override
  String get ga_aiWrongGuess => 'AI guessed wrong!';

  @override
  String get ga_wrongGuessTitle => 'Wrong Guess!';

  @override
  String get ga_turnToYou => 'Your turn now!';

  @override
  String get ga_turnToOpponent => 'Opponent\'s turn now.';

  @override
  String get ga_continue => 'Continue';

  @override
  String get ga_aiRoundEnd => 'AI Round End';

  @override
  String ga_aiCorrectCount(int correct, int total) {
    return 'AI guessed correctly $correct/$total times';
  }

  @override
  String ga_positionLabel(int n) {
    return 'Position $n';
  }

  @override
  String ga_switchTurnHint(String name) {
    return 'Please hand the device to $name.\nRemember to hide your cards!';
  }

  @override
  String ga_winnerWins(String name) {
    return '$name Wins!';
  }

  @override
  String ga_winnerLoses(String name) {
    return '$name Wins...';
  }

  @override
  String get ga_correctGuessesLabel => 'Correct Guesses';

  @override
  String get ga_maxComboLabel => 'Max Combo';

  @override
  String get ga_playDurationLabel => 'Duration';

  @override
  String get ga_playAgainButton => 'Play Again';

  @override
  String ga_durationFormat(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String get game_2048 => '2048';

  @override
  String get t48_gameDescription => 'Combine tiles to reach 2048!';

  @override
  String get t48_instructions =>
      'Swipe or use Arrow keys/WASD to move tiles. When two tiles with the same number touch, they merge into one. Try to reach 2048!';

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

  @override
  String get t48_autoSave => 'Auto Save';

  @override
  String get t48_overwriteConfirm =>
      'This slot already has a save. Overwrite it?';

  @override
  String get t48_savedSuccessfully => 'Game saved!';

  @override
  String get t48_autoSaveInfo => 'Auto-saved every 3 minutes during gameplay';

  @override
  String get db_battleLog => 'Battle Log';

  @override
  String get db_battleStarted => 'Battle started...';

  @override
  String get game_mancala => 'Mancala';

  @override
  String get mc_gameDescription =>
      'Capture more seeds than your opponent in this ancient strategy game!';

  @override
  String get mc_instructions =>
      'Pick up all seeds from one of your pits and sow them counter-clockwise. Land in your store for an extra turn. Land in your empty pit to capture seeds from the opposite pit!';

  @override
  String get mc_twoPlayers => '2 Players';

  @override
  String get mc_easyAI => 'Easy AI';

  @override
  String get mc_mediumAI => 'Medium AI';

  @override
  String get mc_hardAI => 'Hard AI';

  @override
  String get mc_howToPlay => 'How to Play';

  @override
  String get mc_yourTurn => 'Your Turn';

  @override
  String get mc_opponentTurn => 'Opponent\'s Turn';

  @override
  String get mc_playerStore => 'Your Store';

  @override
  String get mc_opponentStore => 'Opponent\'s Store';

  @override
  String get mc_youWin => 'You Win!';

  @override
  String get mc_youLose => 'You Lose!';

  @override
  String get mc_aiWins => 'AI Wins!';

  @override
  String get mc_draw => 'It\'s a Draw!';

  @override
  String get mc_playAgain => 'Play Again';

  @override
  String get mc_exit => 'Exit';

  @override
  String get mc_selectPit => 'Tap a pit to sow seeds';

  @override
  String get mc_gameSaved => 'Game Saved';

  @override
  String get mc_extraTurn => 'Extra Turn!';

  @override
  String get mc_captured => 'Captured!';

  @override
  String get colorScheme => 'Color Scheme';

  @override
  String get woodenScheme => 'Wooden';

  @override
  String get starlightScheme => 'Starlight';

  @override
  String get forestScheme => 'Forest';

  @override
  String get volcanoScheme => 'Volcano';

  @override
  String get game_dice_battle => 'Dice Battle';

  @override
  String get db_gameDescription =>
      'Roll the dice, devise strategies, and defeat your opponent!';

  @override
  String get db_set1Name => 'Balanced Set';

  @override
  String get db_set2Name => 'Offensive Set';

  @override
  String get db_set3Name => 'Defensive Set';

  @override
  String get db_set4Name => 'All-Rounder Set';

  @override
  String get db_set5Name => 'Mixed Set';

  @override
  String get db_attack => 'Attack';

  @override
  String get db_defense => 'Defense';

  @override
  String get db_rollDice => 'Roll Dice';

  @override
  String get db_reroll => 'Reroll';

  @override
  String get db_confirm => 'Confirm';

  @override
  String get db_finishAttack => 'Finish Attack';

  @override
  String get db_finishDefense => 'Finish Defense';

  @override
  String db_rerollsRemaining(int n) {
    return 'Rerolls Remaining: $n';
  }

  @override
  String db_selectAttackDice(int n) {
    return 'Select Attack Dice (up to $n)';
  }

  @override
  String db_selectDefenseDice(int n) {
    return 'Select Defense Dice (up to $n)';
  }

  @override
  String db_totalPoints(int n) {
    return 'Total Points: $n';
  }

  @override
  String db_damageDealt(int n) {
    return 'Dealt $n damage!';
  }

  @override
  String get db_perfectBlock => 'Perfect Block!';

  @override
  String db_comboHit(int n) {
    return 'Combo! Dealt $n bonus damage!';
  }

  @override
  String get db_keywordUpgrade => 'Upgrade';

  @override
  String get db_keywordInstant => 'Instant';

  @override
  String get db_keywordPerfectBlock => 'Perfect Block';

  @override
  String get db_keywordDisrupt => 'Disrupt';

  @override
  String get db_keywordCombo => 'Combo';

  @override
  String get db_keywordUpgradeDesc =>
      'Replace a die with a higher-tier die. Example: Upgrading a d4 changes it to a d6';

  @override
  String get db_keywordInstantDesc =>
      'Deal x damage to the enemy when triggered. Example: Instant(3) = Deal 3 damage immediately';

  @override
  String get db_keywordPerfectBlockDesc =>
      'Defense points rolled are greater than or equal to attack points';

  @override
  String get db_keywordDisruptDesc =>
      'When triggered, reduce one of the opponent\'s dice higher than 2 to 2. If the opponent has no dice higher than 2, nothing happens.';

  @override
  String get db_keywordComboDesc =>
      'If damage was dealt, deal half the previous damage again. Combo damage rounds up.';

  @override
  String get db_effectOddBonus => 'Odd Power';

  @override
  String get db_effectOddBonusDesc =>
      'If all attack dice show odd numbers, +5 points';

  @override
  String get db_effectEvenBonus => 'Even Shield';

  @override
  String get db_effectEvenBonusDesc =>
      'If all defense dice show even numbers, +4 points';

  @override
  String get db_effectComboLow => 'Low Damage Combo';

  @override
  String get db_effectComboLowDesc =>
      'If total damage dealt is less than 10, **Combo**';

  @override
  String get db_effectDiceUpgrade => 'Dice Upgrade';

  @override
  String get db_effectDiceUpgradeDesc =>
      'At the start of the round, **Upgrade** one die for both players';

  @override
  String get db_effectPerfectInstant => 'Block Instant';

  @override
  String get db_effectPerfectInstantDesc =>
      'If **Perfect Block**, then **Instant**(5)';

  @override
  String get db_effectComboHigh => 'High Attack Combo';

  @override
  String get db_effectComboHighDesc =>
      'If attacker\'s total points exceed 20, attacker gains **Combo**';

  @override
  String get db_effectLifeSync => 'Life Sync';

  @override
  String get db_effectLifeSyncDesc =>
      'At round end, if the sum of both players\' health equals 42, defender gains +10 health';

  @override
  String db_roundNumber(int n) {
    return 'Round $n';
  }

  @override
  String db_playerTurn(String name) {
    return '$name\'s Turn';
  }

  @override
  String get db_attacking => 'Attacking';

  @override
  String get db_defending => 'Defending';

  @override
  String get db_calculating => 'Calculating damage...';

  @override
  String get db_roundStart => 'Round Start';

  @override
  String get db_roundEnd => 'Round End';

  @override
  String get db_coinFlip => 'Deciding first player...';

  @override
  String db_goesFirst(String name) {
    return '$name goes first!';
  }

  @override
  String db_victory(String name) {
    return '$name Wins!';
  }

  @override
  String get db_playAgain => 'Play Again';

  @override
  String get db_exit => 'Exit';

  @override
  String get db_twoPlayers => 'Two Players';

  @override
  String get db_easyAI => 'Easy AI';

  @override
  String get db_mediumAI => 'Medium AI';

  @override
  String get db_hardAI => 'Hard AI';

  @override
  String get db_selectDiceSet => 'Select Dice Set';

  @override
  String get db_player1Select => 'Player 1 Select Set';

  @override
  String get db_player2Select => 'Player 2 Select Set';

  @override
  String get db_gameRules => 'Game Rules';

  @override
  String get db_attackPoints => 'Attack Points';

  @override
  String get db_defensePoints => 'Defense Points';

  @override
  String get db_diceConfig => 'Dice Configuration';

  @override
  String db_healthRemaining(int hp) {
    return 'Health Remaining: $hp';
  }

  @override
  String get db_fieldEffect => 'Field Effect';

  @override
  String get db_noActiveEffect => 'No Active Effect';

  @override
  String get hearts_game_hearts => 'Hearts';

  @override
  String get hearts_description => 'Avoid hearts and Queen of Spades!';

  @override
  String get hearts_howToPlay => 'How to Play';

  @override
  String get hearts_startGame => 'Start Game';

  @override
  String get hearts_playAgain => 'Play Again';

  @override
  String get hearts_dealing => 'Dealing cards...';

  @override
  String get hearts_passing => 'Pass Phase';

  @override
  String get hearts_playing => 'Playing';

  @override
  String get hearts_roundEnd => 'Round End';

  @override
  String get hearts_gameOver => 'Game Over';

  @override
  String get hearts_aiThinking => 'AI is thinking...';

  @override
  String get hearts_passDirection => 'Pass Direction';

  @override
  String get hearts_passLeft => 'Pass Left';

  @override
  String get hearts_passRight => 'Pass Right';

  @override
  String get hearts_passAcross => 'Pass Across';

  @override
  String get hearts_passHold => 'Hold (No Pass)';

  @override
  String hearts_selectCardsToPass(int n) {
    return 'Select $n cards to pass';
  }

  @override
  String hearts_passTimer(int s) {
    return 'Time remaining: ${s}s';
  }

  @override
  String get hearts_confirmPass => 'Confirm Pass';

  @override
  String get hearts_timerUnlimited => 'Unlimited';

  @override
  String get hearts_timer15s => '15 seconds';

  @override
  String get hearts_timer20s => '20 seconds';

  @override
  String get hearts_timer30s => '30 seconds';

  @override
  String get hearts_yourTurn => 'Your turn!';

  @override
  String get hearts_waitTurn => 'Waiting for opponent...';

  @override
  String get hearts_heartsBroken => 'Hearts Broken!';

  @override
  String get hearts_firstTrick => 'First trick - 2♣ leads';

  @override
  String hearts_trickWon(String player) {
    return 'Trick won by $player';
  }

  @override
  String get hearts_roundScores => 'Round Scores';

  @override
  String get hearts_totalScores => 'Total Scores';

  @override
  String get hearts_pointsTaken => 'Points taken';

  @override
  String hearts_heartsCount(int n) {
    return 'Hearts: $n';
  }

  @override
  String get hearts_shootMoon => 'Shoot the Moon!';

  @override
  String get hearts_shootMoonSuccess => 'Successfully shot the moon!';

  @override
  String get hearts_announceMoonOption => 'Announce moon attempt';

  @override
  String get hearts_hideMoonOption => 'Hide moon attempt';

  @override
  String hearts_player(int n) {
    return 'Player $n';
  }

  @override
  String get hearts_you => 'You';

  @override
  String get hearts_winner => 'Winner';

  @override
  String get hearts_finalResults => 'Final Results';

  @override
  String get hearts_rule1Title => '1. Goal';

  @override
  String get hearts_rule1Desc =>
      'Avoid collecting hearts (♥ = 1 point each) and Queen of Spades (♠Q = 13 points). Lowest score wins!';

  @override
  String get hearts_rule2Title => '2. Passing';

  @override
  String get hearts_rule2Desc =>
      'Before each round, pass 3 cards: left→right→across→hold, cycling every 4 rounds.';

  @override
  String get hearts_rule3Title => '3. Playing';

  @override
  String get hearts_rule3Desc =>
      'Player with 2♣ leads first trick. Must follow suit if possible. Hearts can\'t lead until \"broken\".';

  @override
  String get hearts_rule4Title => '4. Scoring';

  @override
  String get hearts_rule4Desc =>
      'Collect all 14 penalty cards = Shoot the Moon (you get 0, others get 26). Game ends at 100 points.';

  @override
  String get hearts_rule5Title => '5. Winning';

  @override
  String get hearts_rule5Desc => 'Lowest total score wins when game ends!';

  @override
  String get hearts_resume => 'Resume';

  @override
  String get hearts_saveGame => 'Save Game';

  @override
  String get hearts_loadGame => 'Load Game';

  @override
  String get hearts_newGame => 'New Game';

  @override
  String get hearts_exitGame => 'Exit';

  @override
  String get hearts_aiDifficulty => 'AI Difficulty';

  @override
  String get hearts_randomPosition => 'Random player position';

  @override
  String get hearts_passTimerSetting => 'Pass timer';

  @override
  String get hearts_passComplete => 'Pass Complete';

  @override
  String get hearts_receivedCards => 'You received these cards:';

  @override
  String get hearts_continuePlaying => 'Continue';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get game_bluff_bar => 'Bluff Bar';

  @override
  String get bb_game_title => 'Bluff Bar';

  @override
  String get bb_game_subtitle => 'Bluff, Challenge, Survive';

  @override
  String get bb_gameDescription =>
      'A poker-style bluffing game with Russian roulette elimination';

  @override
  String get bb_phase_setup => 'Setup Phase';

  @override
  String get bb_phase_deal => 'Dealing Phase';

  @override
  String get bb_phase_play => 'Play Phase';

  @override
  String get bb_phase_challenge => 'Challenge Phase';

  @override
  String get bb_phase_reveal => 'Reveal Phase';

  @override
  String get bb_phase_roulette => 'Russian Roulette';

  @override
  String get bb_phase_roundEnd => 'Round End';

  @override
  String get bb_phase_gameOver => 'Game Over';

  @override
  String get bb_target_card => 'Target Card';

  @override
  String get bb_target_jacks => 'Target: J';

  @override
  String get bb_target_queens => 'Target: Q';

  @override
  String get bb_target_kings => 'Target: K';

  @override
  String get bb_target_aces => 'Target: A';

  @override
  String get bb_play_cards => 'Play Cards';

  @override
  String get bb_challenge => 'Challenge!';

  @override
  String get bb_pass => 'Pass';

  @override
  String get bb_select_cards => 'Select Cards';

  @override
  String get bb_claim => 'Claim';

  @override
  String bb_claiming(int count, String rank) {
    return '$count ${rank}s';
  }

  @override
  String bb_cards_played(int count) {
    return '$count cards played';
  }

  @override
  String get bb_challenge_successful => 'Challenge Successful!';

  @override
  String get bb_challenge_failed => 'Challenge Failed';

  @override
  String get bb_liar_guilty => 'Caught the Liar!';

  @override
  String get bb_liar_innocent => 'Honest Play!';

  @override
  String get bb_roulette_draw => 'Draw Roulette Card';

  @override
  String get bb_roulette_survived => 'Survived!';

  @override
  String get bb_roulette_eliminated => 'Eliminated!';

  @override
  String bb_roulette_remaining(int count) {
    return '$count cards remaining';
  }

  @override
  String get bb_your_turn => 'Your Turn';

  @override
  String get bb_opponent_turn => 'Opponent\'s Turn';

  @override
  String bb_cards_in_hand(int count) {
    return '$count cards in hand';
  }

  @override
  String get bb_eliminated_player => 'Eliminated';

  @override
  String get bb_ai_thinking => 'AI Thinking...';

  @override
  String get bb_ai_playing => 'AI Playing...';

  @override
  String get bb_ai_challenging => 'AI Challenges!';

  @override
  String bb_winner(String name) {
    return '$name Wins!';
  }

  @override
  String get bb_last_survivor => 'Last Survivor';

  @override
  String get bb_play_again => 'Play Again';

  @override
  String get bb_exit => 'Exit';

  @override
  String get bb_ai_difficulty => 'AI Difficulty';

  @override
  String get bb_easy => 'Easy';

  @override
  String get bb_medium => 'Medium';

  @override
  String get bb_hard => 'Hard';

  @override
  String get bb_start_game => 'Start Game';

  @override
  String get bb_how_to_play => 'How to Play';

  @override
  String get bb_rule1_title => '1. Target Card';

  @override
  String get bb_rule1_desc =>
      'Each round randomly designates J/Q/K/A as the target card. That card and Joker count as \"real cards\".';

  @override
  String get bb_rule2_title => '2. Playing Cards';

  @override
  String get bb_rule2_desc =>
      'Each turn, play 1-5 cards face-down and claim they are target cards.';

  @override
  String get bb_rule3_title => '3. Challenge';

  @override
  String get bb_rule3_desc =>
      'Call \"Liar!\" to challenge the previous player. Flip cards to verify: fake cards = challenger wins, real cards = challenger loses.';

  @override
  String get bb_rule4_title => '4. Elimination';

  @override
  String get bb_rule4_desc =>
      'The loser triggers Russian roulette: draw a card. Live bullet = eliminated.';

  @override
  String get bb_rule5_title => '5. Victory';

  @override
  String get bb_rule5_desc => 'Become the last surviving player to win!';

  @override
  String get bb_got_it => 'Got it!';

  @override
  String get bb_two_players => '2 Players';

  @override
  String get bb_vs_ai => 'VS AI';

  @override
  String get bb_eliminated => 'ELIMINATED';

  @override
  String get bb_survived => 'SURVIVED!';

  @override
  String get bb_draw_card => 'Draw Card';

  @override
  String get bb_drawing => 'Drawing...';

  @override
  String bb_cards_remaining(int count) {
    return '$count cards remaining';
  }

  @override
  String get bb_no_cards_played => 'No cards played yet';

  @override
  String bb_cards_played_total(int count) {
    return '$count cards played';
  }

  @override
  String get bb_no_cards => 'No cards';

  @override
  String get bb_one_player_three_ai => '1 Player + 3 AI';

  @override
  String get bb_exit_confirm =>
      'Are you sure you want to exit? Progress will be lost.';

  @override
  String bb_round(int number) {
    return 'Round $number';
  }

  @override
  String bb_round_ranking(int number) {
    return 'Round $number Rankings';
  }

  @override
  String get bb_roulette_shots => 'Shots fired';

  @override
  String get bb_select_claim => 'Select claim rank';

  @override
  String get bb_your_hand => 'Your Hand';

  @override
  String bb_waiting_for(String name) {
    return 'Waiting for $name...';
  }

  @override
  String get bb_game_screen_coming => 'Game screen coming soon!';

  @override
  String get bb_position_north => 'North';

  @override
  String get bb_position_south => 'South';

  @override
  String get bb_position_east => 'East';

  @override
  String get bb_position_west => 'West';

  @override
  String bb_challenge_title(String challenger, String challenged) {
    return '$challenger challenges $challenged';
  }

  @override
  String get bb_revealed_cards => 'Revealed Cards';

  @override
  String get bb_liar => 'Liar!';

  @override
  String get bb_honest => 'Honest!';

  @override
  String get bb_face_roulette => 'faces Roulette';

  @override
  String get bb_victory => 'VICTORY';

  @override
  String get bb_defeat => 'DEFEAT';

  @override
  String get bb_ranking => 'Rankings';

  @override
  String bb_rounds_survived(int count) {
    return '$count rounds';
  }

  @override
  String get game_reaction_test => 'Reaction Test';

  @override
  String get rt_gameDescription =>
      'Test your reflexes! Tap as fast as you can when colors change.';

  @override
  String get rt_instructions =>
      'Wait for the background color to change, then tap as fast as you can!';

  @override
  String get rt_selectPreset => 'Select Color Scheme';

  @override
  String get rt_redGreenColorblind => 'Red-Green Colorblind';

  @override
  String get rt_blueYellowColorblind => 'Blue-Yellow Colorblind';

  @override
  String get rt_monochromacy => 'Monochromacy';

  @override
  String get rt_custom => 'Custom';

  @override
  String get rt_beforeColor => 'Before Color';

  @override
  String get rt_afterColor => 'After Color';

  @override
  String get rt_sameColorWarning =>
      'Before and After colors cannot be the same!';

  @override
  String rt_testNumber(int current, int total) {
    return 'Test $current of $total';
  }

  @override
  String get rt_waitForIt => 'Wait for it...';

  @override
  String get rt_tapNow => 'TAP NOW!';

  @override
  String rt_reactionTime(int time) {
    return '$time ms';
  }

  @override
  String get rt_results => 'Results';

  @override
  String get rt_average => 'Average';

  @override
  String get rt_best => 'Best';

  @override
  String get rt_worst => 'Worst';

  @override
  String get rt_tooEarly => 'Too early! Wait for the color to change.';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get rt_leaderboardSubtitle => 'Fastest reaction times';

  @override
  String get rt_noRecords => 'No records yet. Play to set your first record!';

  @override
  String get close => 'Close';

  @override
  String get game_aim_test => 'Aim Test';

  @override
  String get at_gameDescription =>
      'Test your aim! Click the bubbles as fast as you can in 30 seconds.';

  @override
  String get at_instructions =>
      'Click the bubbles before they disappear! You have 30 seconds.';

  @override
  String get at_settings => 'Settings';

  @override
  String get at_deadZone => 'Dead Zone';

  @override
  String at_deadZonePercent(int percent) {
    return '$percent% dead zone';
  }

  @override
  String get at_bubbleColor => 'Bubble Color';

  @override
  String get at_gameDuration => 'Game Duration';

  @override
  String get at_misses => 'Misses';

  @override
  String get at_appearAnimation => 'Bubble Animation';

  @override
  String get at_bubbleSize => 'Bubble Size';

  @override
  String get at_preview => 'Preview';

  @override
  String get at_hits => 'Hits';

  @override
  String get at_accuracy => 'Accuracy';

  @override
  String get at_gameOver => 'Game Over!';

  @override
  String get at_finalScore => 'Final Score';

  @override
  String get at_bubblesSpawned => 'Bubbles Spawned';

  @override
  String get at_timeUp => 'Time\'s Up!';

  @override
  String get at_playAgain => 'Play Again';

  @override
  String get at_startGame => 'Start Game';

  @override
  String get at_countdown3 => '3';

  @override
  String get at_countdown2 => '2';

  @override
  String get at_countdown1 => '1';

  @override
  String get at_countdownGo => 'GO!';

  @override
  String get category_favorites => 'Favorites';

  @override
  String favorites_count(int count) {
    return '$count games';
  }

  @override
  String get sort_by_category => 'By Category';

  @override
  String get sort_by_release_time => 'By Release Time';

  @override
  String get sort_by_creator => 'By Creator';

  @override
  String get creator_glm => 'GLM-5 + qwen3.5-plus';

  @override
  String get creator_minimax => 'MiniMax-M2.7';

  @override
  String get creator_mimo => 'mimo-v2.5-pro';

  @override
  String get category_recent => 'Recent Releases';

  @override
  String recent_count(int count) {
    return '$count new games';
  }

  @override
  String get category_all_games => 'Other Games';

  @override
  String get ci_gameTitle => 'Chess';

  @override
  String get ci_gameDescription =>
      'Classic chess vs AI with FEN import and PGN export';

  @override
  String get ci_startGame => 'Start Game';

  @override
  String get ci_howToPlay => 'How to Play';

  @override
  String get ci_aiDifficulty => 'AI Difficulty';

  @override
  String get ci_easy => 'Easy';

  @override
  String get ci_hard => 'Hard';

  @override
  String get ci_playAs => 'Play As';

  @override
  String get ci_white => 'White';

  @override
  String get ci_black => 'Black';

  @override
  String get ci_importFen => 'Import Position (FEN)';

  @override
  String get ci_importFenDesc =>
      'Paste a FEN string to start from a specific position';

  @override
  String get ci_validate => 'Validate';

  @override
  String get ci_fenValid => 'FEN is valid! Position will be imported.';

  @override
  String get ci_newGame => 'New Game';

  @override
  String get ci_undo => 'Undo';

  @override
  String get ci_copyFen => 'Copy FEN';

  @override
  String get ci_exportPgn => 'Export PGN';

  @override
  String get ci_exitGame => 'Exit Game';

  @override
  String get ci_exitConfirm =>
      'Are you sure you want to exit? Current progress will be lost.';

  @override
  String get ci_restartConfirm =>
      'Are you sure you want to restart? Current progress will be lost.';

  @override
  String get ci_fenCopied => 'FEN copied to clipboard';

  @override
  String get ci_pgnCopied => 'PGN copied to clipboard';

  @override
  String get ci_copyPgn => 'Copy PGN';

  @override
  String get ci_moveHistory => 'Move History';

  @override
  String get ci_noMovesYet => 'No moves yet';

  @override
  String get ci_preparing => 'Preparing...';

  @override
  String get ci_yourTurn => 'Your turn';

  @override
  String get ci_aiTurn => 'AI thinking...';

  @override
  String get ci_youAreInCheck => 'You are in check!';

  @override
  String get ci_aiInCheck => 'AI is in check';

  @override
  String get ci_youWin => 'You win!';

  @override
  String get ci_aiWins => 'AI wins';

  @override
  String get ci_stalemate => 'Stalemate - Draw';

  @override
  String get ci_draw => 'Draw';

  @override
  String get ci_choosePromotion => 'Choose promotion piece';

  @override
  String get ci_thinking => 'Thinking...';

  @override
  String get ci_you => 'You';

  @override
  String get ci_rule1Title => 'Objective';

  @override
  String get ci_rule1Desc =>
      'Checkmate the opponent\'s king. The game ends when the king is under attack and cannot escape.';

  @override
  String get ci_rule2Title => 'Movement';

  @override
  String get ci_rule2Desc =>
      'Tap a piece to see legal moves highlighted. Tap a highlighted square to move. Each piece type moves differently.';

  @override
  String get ci_rule3Title => 'Special Moves';

  @override
  String get ci_rule3Desc =>
      'Castling: King moves 2 squares toward a rook. En passant: Pawn captures an adjacent pawn that just moved 2 squares. Promotion: Pawn reaching the last rank becomes a queen, rook, bishop, or knight.';

  @override
  String get ci_rule4Title => 'Draw Conditions';

  @override
  String get ci_rule4Desc =>
      'The game is a draw by stalemate, 50-move rule (no captures or pawn moves), threefold repetition, or insufficient material.';

  @override
  String get ci_rule5Title => 'FEN & PGN';

  @override
  String get ci_rule5Desc =>
      'Import positions using FEN notation. Export your games in PGN format from the menu.';

  @override
  String get ci_pieceStyle => 'Piece Style';

  @override
  String get ci_styleOutline => 'Outline';

  @override
  String get ci_styleFilled => 'Filled';

  @override
  String get sg_gameTitle => 'Schulte Grid';

  @override
  String get sg_gameDescription =>
      'Train your focus! Tap numbers 1 to N in order as fast as you can.';

  @override
  String get sg_instructions =>
      'Choose a grid size to start. Tap numbers from 1 to N in ascending order. The timer starts when you tap 1.';

  @override
  String sg_sizeLabel(int size, int total) {
    return '${size}x$size Grid ($total numbers)';
  }

  @override
  String get sg_bestTime => 'Best';

  @override
  String get sg_noRecord => 'No record yet';

  @override
  String get sg_tapToStart => 'Tap 1 to start the timer';

  @override
  String get sg_paused => 'Paused';

  @override
  String get sg_next => 'Next';

  @override
  String get sg_completed => 'Completed!';

  @override
  String get sg_newBest => 'New Personal Best!';

  @override
  String get sg_leaderboard => 'Leaderboard';

  @override
  String get sg_noRecords =>
      'No records yet.\nComplete a training to set your first record!';

  @override
  String get sg_clearLeaderboard => 'Clear Leaderboard';

  @override
  String get sg_clearConfirm =>
      'Are you sure you want to clear all records for this grid size?';

  @override
  String get createdByGlm => 'Created by GLM-5 + qwen3.5-plus';

  @override
  String get createdByMinimax => 'Created by MiniMax-M2.7';

  @override
  String get createdByMimo => 'Created by mimo-v2.5-pro';
}
