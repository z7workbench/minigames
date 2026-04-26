import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Mini Games'**
  String get appTitle;

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Mini Games'**
  String get appName;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Settings navigation label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Back button label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Play button label
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Pause button label
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Restart button label
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// Quit button label
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// New game button label
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Yes button label
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button label
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Attempts label
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attempts;

  /// Score label
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// High score label
  ///
  /// In en, this message translates to:
  /// **'High Score'**
  String get highScore;

  /// Game over message
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// Victory message
  ///
  /// In en, this message translates to:
  /// **'You Win!'**
  String get youWin;

  /// Defeat message
  ///
  /// In en, this message translates to:
  /// **'You Lose'**
  String get youLose;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Seconds unit label
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// Hit & Blow game title
  ///
  /// In en, this message translates to:
  /// **'Hit & Blow'**
  String get game_hit_and_blow;

  /// Hit & Blow game description
  ///
  /// In en, this message translates to:
  /// **'Guess the hidden numbers and their positions!'**
  String get hnb_gameDescription;

  /// Hit & Blow game instructions
  ///
  /// In en, this message translates to:
  /// **'Select numbers and place them in positions, then press Check to see if they\'re correct. A Hit means correct number in correct position. A Blow means correct number in wrong position.'**
  String get hnb_instructions;

  /// Hit & Blow enter guess placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your guess'**
  String get hnb_enterGuess;

  /// Hit & Blow check button
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get hnb_check;

  /// Hit & Blow attempt number with placeholder
  ///
  /// In en, this message translates to:
  /// **'Attempt {n}'**
  String hnb_attempt(int n);

  /// Hit & Blow Hit - correct position and number
  ///
  /// In en, this message translates to:
  /// **'Hit'**
  String get hnb_hit;

  /// Hit & Blow Blow - correct number wrong position
  ///
  /// In en, this message translates to:
  /// **'Blow'**
  String get hnb_blow;

  /// Hit & Blow attempts remaining label
  ///
  /// In en, this message translates to:
  /// **'Attempts Remaining'**
  String get hnb_attemptsRemaining;

  /// Hit & Blow attempts used label
  ///
  /// In en, this message translates to:
  /// **'Attempts Used'**
  String get hnb_attemptsUsed;

  /// Hit & Blow out of attempts message
  ///
  /// In en, this message translates to:
  /// **'Out of attempts!'**
  String get hnb_outOfAttempts;

  /// Hit & Blow select difficulty label
  ///
  /// In en, this message translates to:
  /// **'Select Difficulty'**
  String get hnb_selectDifficulty;

  /// Hit & Blow easy mode label
  ///
  /// In en, this message translates to:
  /// **'Easy Mode'**
  String get hnb_easyMode;

  /// Hit & Blow hard mode label
  ///
  /// In en, this message translates to:
  /// **'Hard Mode'**
  String get hnb_hardMode;

  /// Hit & Blow simple mode description
  ///
  /// In en, this message translates to:
  /// **'4 positions, digits 1-6'**
  String get hnb_simpleDescription;

  /// Hit & Blow hard mode description
  ///
  /// In en, this message translates to:
  /// **'6 positions, digits 1-8'**
  String get hnb_hardDescription;

  /// Hit & Blow game won message
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You guessed the number!'**
  String get hnb_gameWon;

  /// Hit & Blow game lost message
  ///
  /// In en, this message translates to:
  /// **'Game Over! The correct number was: '**
  String get hnb_gameLost;

  /// Hit & Blow new record message
  ///
  /// In en, this message translates to:
  /// **'New Record!'**
  String get hnb_newRecord;

  /// Hit & Blow guess history label
  ///
  /// In en, this message translates to:
  /// **'Guess History'**
  String get hnb_guessHistory;

  /// Hit & Blow target number label
  ///
  /// In en, this message translates to:
  /// **'Target Number'**
  String get hnb_targetNumber;

  /// Hit & Blow clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get hnb_clear;

  /// Hit & Blow attempts display format
  ///
  /// In en, this message translates to:
  /// **'Attempts: {current} / {max}'**
  String hnb_attemptsFormat(int current, int max);

  /// Yacht Dice game title
  ///
  /// In en, this message translates to:
  /// **'Yacht Dice'**
  String get game_yacht_dice;

  /// Yacht Dice game description
  ///
  /// In en, this message translates to:
  /// **'Roll dice to make combinations and score points!'**
  String get yd_gameDescription;

  /// Yacht Dice game instructions
  ///
  /// In en, this message translates to:
  /// **'Roll the dice and select scoring categories. You can re-roll up to 2 times by keeping good dice. The player with the highest score wins!'**
  String get yd_instructions;

  /// Yacht Dice roll dice button
  ///
  /// In en, this message translates to:
  /// **'Roll Dice'**
  String get yd_rollDice;

  /// Yacht Dice roll number with placeholder
  ///
  /// In en, this message translates to:
  /// **'Roll {n}'**
  String yd_roll(int n);

  /// Yacht Dice keep dice button
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get yd_keepDice;

  /// Yacht Dice release dice button
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get yd_releaseDice;

  /// Yacht Dice rolls remaining label
  ///
  /// In en, this message translates to:
  /// **'Rolls Remaining'**
  String get yd_rollsRemaining;

  /// Yacht Dice rolls used label
  ///
  /// In en, this message translates to:
  /// **'Rolls Used'**
  String get yd_rollsUsed;

  /// Yacht Dice select category label
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get yd_selectCategory;

  /// Yacht Dice confirm score button
  ///
  /// In en, this message translates to:
  /// **'Confirm Score'**
  String get yd_confirmScore;

  /// Yacht Dice confirm score dialog message with placeholders
  ///
  /// In en, this message translates to:
  /// **'Select {category} for {score} points?'**
  String yd_confirmScoreMessage(String category, int score);

  /// Yacht Dice category already used message
  ///
  /// In en, this message translates to:
  /// **'Category already used'**
  String get yd_categoryAlreadyUsed;

  /// Yacht Dice player's turn label
  ///
  /// In en, this message translates to:
  /// **'Player\'s Turn'**
  String get yd_playerTurn;

  /// Yacht Dice player number with placeholder
  ///
  /// In en, this message translates to:
  /// **'Player {n}'**
  String yd_player(int n);

  /// Yacht Dice AI player label
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get yd_ai;

  /// Yacht Dice select players label
  ///
  /// In en, this message translates to:
  /// **'Select Players'**
  String get yd_selectPlayers;

  /// Yacht Dice one player mode
  ///
  /// In en, this message translates to:
  /// **'1 Player'**
  String get yd_onePlayer;

  /// Yacht Dice two players mode
  ///
  /// In en, this message translates to:
  /// **'2 Players'**
  String get yd_twoPlayers;

  /// Yacht Dice versus AI mode
  ///
  /// In en, this message translates to:
  /// **'VS Computer'**
  String get yd_vsAI;

  /// Yacht Dice AI difficulty label
  ///
  /// In en, this message translates to:
  /// **'AI Difficulty'**
  String get yd_aiDifficulty;

  /// Yacht Dice easy AI difficulty
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get yd_easyAI;

  /// Yacht Dice medium AI difficulty
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get yd_mediumAI;

  /// Yacht Dice hard AI difficulty
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get yd_hardAI;

  /// Yacht Dice bonus label
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get yd_bonus;

  /// Yacht Dice bonus threshold description
  ///
  /// In en, this message translates to:
  /// **'Bonus at 63 points'**
  String get yd_bonusThreshold;

  /// Yacht Dice scoring category - Ones
  ///
  /// In en, this message translates to:
  /// **'Ones'**
  String get yd_ones;

  /// Yacht Dice scoring category - Twos
  ///
  /// In en, this message translates to:
  /// **'Twos'**
  String get yd_twos;

  /// Yacht Dice scoring category - Threes
  ///
  /// In en, this message translates to:
  /// **'Threes'**
  String get yd_threes;

  /// Yacht Dice scoring category - Fours
  ///
  /// In en, this message translates to:
  /// **'Fours'**
  String get yd_fours;

  /// Yacht Dice scoring category - Fives
  ///
  /// In en, this message translates to:
  /// **'Fives'**
  String get yd_fives;

  /// Yacht Dice scoring category - Sixes
  ///
  /// In en, this message translates to:
  /// **'Sixes'**
  String get yd_sixes;

  /// Yacht Dice scoring category - Chance (sum of all dice)
  ///
  /// In en, this message translates to:
  /// **'Chance'**
  String get yd_allSelect;

  /// Yacht Dice scoring category - Full House
  ///
  /// In en, this message translates to:
  /// **'Full House'**
  String get yd_fullHouse;

  /// Yacht Dice scoring category - Four of a Kind
  ///
  /// In en, this message translates to:
  /// **'Four of a Kind'**
  String get yd_fourOfAKind;

  /// Yacht Dice scoring category - Small Straight (1-2-3-4 or 2-3-4-5 or 3-4-5-6)
  ///
  /// In en, this message translates to:
  /// **'Small Straight'**
  String get yd_smallStraight;

  /// Yacht Dice scoring category - Large Straight (1-2-3-4-5 or 2-3-4-5-6)
  ///
  /// In en, this message translates to:
  /// **'Large Straight'**
  String get yd_largeStraight;

  /// Yacht Dice scoring category - Yacht (five of a kind)
  ///
  /// In en, this message translates to:
  /// **'Yacht'**
  String get yd_yacht;

  /// Yacht Dice Ones category description
  ///
  /// In en, this message translates to:
  /// **'Sum of all ones'**
  String get yd_onesDescription;

  /// Yacht Dice Twos category description
  ///
  /// In en, this message translates to:
  /// **'Sum of all twos'**
  String get yd_twosDescription;

  /// Yacht Dice Threes category description
  ///
  /// In en, this message translates to:
  /// **'Sum of all threes'**
  String get yd_threesDescription;

  /// Yacht Dice Fours category description
  ///
  /// In en, this message translates to:
  /// **'Sum of all fours'**
  String get yd_foursDescription;

  /// Yacht Dice Fives category description
  ///
  /// In en, this message translates to:
  /// **'Sum of all fives'**
  String get yd_fivesDescription;

  /// Yacht Dice Sixes category description
  ///
  /// In en, this message translates to:
  /// **'Sum of all sixes'**
  String get yd_sixesDescription;

  /// Yacht Dice Chance category description
  ///
  /// In en, this message translates to:
  /// **'Sum of all dice'**
  String get yd_allSelectDescription;

  /// Yacht Dice Full House category description
  ///
  /// In en, this message translates to:
  /// **'Three of a kind and a pair - 25 points'**
  String get yd_fullHouseDescription;

  /// Yacht Dice Four of a Kind category description
  ///
  /// In en, this message translates to:
  /// **'Four dice showing the same face - sum of all dice'**
  String get yd_fourOfAKindDescription;

  /// Yacht Dice Small Straight category description
  ///
  /// In en, this message translates to:
  /// **'Sequence of four - 15 points'**
  String get yd_smallStraightDescription;

  /// Yacht Dice Large Straight category description
  ///
  /// In en, this message translates to:
  /// **'Sequence of five - 30 points'**
  String get yd_largeStraightDescription;

  /// Yacht Dice Yacht category description
  ///
  /// In en, this message translates to:
  /// **'Five of a kind - 50 points'**
  String get yd_yachtDescription;

  /// Yacht Dice winner message
  ///
  /// In en, this message translates to:
  /// **'wins!'**
  String get yd_wins;

  /// Yacht Dice draw message
  ///
  /// In en, this message translates to:
  /// **'It\'s a draw!'**
  String get yd_draw;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark mode setting label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System default theme option
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get systemTheme;

  /// Sound setting label
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Sound enabled option
  ///
  /// In en, this message translates to:
  /// **'Sound On'**
  String get soundEnabled;

  /// Sound disabled option
  ///
  /// In en, this message translates to:
  /// **'Sound Off'**
  String get soundDisabled;

  /// Difficulty setting label
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// Easy difficulty option
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Normal difficulty option
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Hard difficulty option
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// Fullscreen setting label
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get fullscreen;

  /// Fullscreen enabled option
  ///
  /// In en, this message translates to:
  /// **'Fullscreen On'**
  String get fullscreenEnabled;

  /// About section label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Application description shown in settings
  ///
  /// In en, this message translates to:
  /// **'Classic games for everyone - board, dice, cards and puzzles.'**
  String get appDescription;

  /// Yacht Dice exit confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Exit Game'**
  String get yd_exitTitle;

  /// Yacht Dice exit confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Do you want to save your progress before exiting?'**
  String get yd_exitMessage;

  /// Yacht Dice button to exit without saving
  ///
  /// In en, this message translates to:
  /// **'Exit Without Saving'**
  String get yd_exitWithoutSaving;

  /// Yacht Dice button to save and exit
  ///
  /// In en, this message translates to:
  /// **'Save & Exit'**
  String get yd_saveAndExit;

  /// Yacht Dice resume game dialog title
  ///
  /// In en, this message translates to:
  /// **'Resume Game?'**
  String get yd_resumeTitle;

  /// Yacht Dice resume game dialog message
  ///
  /// In en, this message translates to:
  /// **'You have a saved game. Would you like to resume or start a new game?'**
  String get yd_resumeMessage;

  /// Yacht Dice button to resume saved game
  ///
  /// In en, this message translates to:
  /// **'Resume Game'**
  String get yd_resumeGame;

  /// Yacht Dice button to start new game (delete save)
  ///
  /// In en, this message translates to:
  /// **'Start New Game'**
  String get yd_startNewGame;

  /// Yacht Dice hint text for keeping dice
  ///
  /// In en, this message translates to:
  /// **'Tap dice to keep/release'**
  String get yd_tapToKeep;

  /// Guess Arrangement game title
  ///
  /// In en, this message translates to:
  /// **'Guess Arrangement'**
  String get game_guess_arrangement;

  /// Guess Arrangement game description
  ///
  /// In en, this message translates to:
  /// **'Guess your opponent\'s hidden cards in this card guessing game!'**
  String get ga_gameDescription;

  /// 2 player mode button
  ///
  /// In en, this message translates to:
  /// **'2 Players'**
  String get ga_twoPlayers;

  /// Easy AI mode button
  ///
  /// In en, this message translates to:
  /// **'Easy AI'**
  String get ga_easyAI;

  /// Medium AI mode button
  ///
  /// In en, this message translates to:
  /// **'Medium AI'**
  String get ga_mediumAI;

  /// Hard AI mode button
  ///
  /// In en, this message translates to:
  /// **'Hard AI'**
  String get ga_hardAI;

  /// How to play button
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get ga_howToPlay;

  /// Correct guess message
  ///
  /// In en, this message translates to:
  /// **'CORRECT!'**
  String get ga_correct;

  /// Wrong guess message
  ///
  /// In en, this message translates to:
  /// **'Wrong Guess'**
  String get ga_wrongGuess;

  /// Switch turns dialog title
  ///
  /// In en, this message translates to:
  /// **'Switch Turns'**
  String get ga_switchTurns;

  /// Ready to play button after turn switch
  ///
  /// In en, this message translates to:
  /// **'Ready to Play'**
  String get ga_readyToPlay;

  /// Win message
  ///
  /// In en, this message translates to:
  /// **'You Win!'**
  String get ga_youWin;

  /// AI wins message
  ///
  /// In en, this message translates to:
  /// **'AI Wins!'**
  String get ga_aiWins;

  /// Play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get ga_playAgain;

  /// Exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get ga_exit;

  /// Round label
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get ga_round;

  /// Turn label
  ///
  /// In en, this message translates to:
  /// **'Turn'**
  String get ga_turn;

  /// Combo label
  ///
  /// In en, this message translates to:
  /// **'Combo'**
  String get ga_combo;

  /// Dealing cards message
  ///
  /// In en, this message translates to:
  /// **'Dealing cards...'**
  String get ga_dealing;

  /// AI thinking message
  ///
  /// In en, this message translates to:
  /// **'AI Thinking...'**
  String get ga_aiThinking;

  /// Position label
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get ga_position;

  /// Your turn message
  ///
  /// In en, this message translates to:
  /// **'Your Turn!'**
  String get ga_yourTurn;

  /// Opponent's turn message
  ///
  /// In en, this message translates to:
  /// **'Opponent\'s Turn'**
  String get ga_opponentTurn;

  /// Cards remaining label
  ///
  /// In en, this message translates to:
  /// **'Cards Remaining'**
  String get ga_cardsRemaining;

  /// Select game mode label
  ///
  /// In en, this message translates to:
  /// **'Select Game Mode'**
  String get ga_selectGameMode;

  /// Got it button
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get ga_gotIt;

  /// Player's cards label with placeholder
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Cards'**
  String ga_playerCards(String name);

  /// Your cards label
  ///
  /// In en, this message translates to:
  /// **'Your Cards'**
  String get ga_yourCards;

  /// Hint to tap card
  ///
  /// In en, this message translates to:
  /// **'Tap a card to guess'**
  String get ga_tapToGuess;

  /// Position selected message with placeholder
  ///
  /// In en, this message translates to:
  /// **'Position {position} selected - Choose a number below'**
  String ga_positionSelected(int position);

  /// Select number label
  ///
  /// In en, this message translates to:
  /// **'Select Number (A-K)'**
  String get ga_selectNumber;

  /// Correct guess message with card placeholder
  ///
  /// In en, this message translates to:
  /// **'Correct! {card}'**
  String ga_guessCorrect(String card);

  /// Correct guess message with combo
  ///
  /// In en, this message translates to:
  /// **'Correct! {card} Combo x{combo}'**
  String ga_guessCorrectCombo(String card, int combo);

  /// Combo label with number
  ///
  /// In en, this message translates to:
  /// **'Combo x{n}'**
  String ga_comboLabel(int n);

  /// Clear selection button
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get ga_clearSelection;

  /// End turn button
  ///
  /// In en, this message translates to:
  /// **'End Turn'**
  String get ga_endTurn;

  /// Exit game dialog title
  ///
  /// In en, this message translates to:
  /// **'Exit Game?'**
  String get ga_exitGameTitle;

  /// Exit game dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit? Current progress will be lost.'**
  String get ga_exitGameMessage;

  /// Restart game dialog title
  ///
  /// In en, this message translates to:
  /// **'Restart?'**
  String get ga_restartGameTitle;

  /// Restart game dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restart the game?'**
  String get ga_restartGameMessage;

  /// Restart button
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get ga_restart;

  /// AI guessing message with placeholders
  ///
  /// In en, this message translates to:
  /// **'AI Guessing: Position {position} is {rank}'**
  String ga_aiGuessing(int position, String rank);

  /// Rule 1 title
  ///
  /// In en, this message translates to:
  /// **'1. Dealing'**
  String get ga_rule1Title;

  /// Rule 1 description
  ///
  /// In en, this message translates to:
  /// **'Each player draws 8 cards from a 52-card deck, arranged face-down from low to high (A=1 lowest, K=13 highest).'**
  String get ga_rule1Desc;

  /// Rule 2 title
  ///
  /// In en, this message translates to:
  /// **'2. Guessing'**
  String get ga_rule2Title;

  /// Rule 2 description
  ///
  /// In en, this message translates to:
  /// **'Players take turns guessing each other\'s cards. For example: \"Position 3 is a 7\". Guess the rank only, not the suit.'**
  String get ga_rule2Desc;

  /// Rule 3 title
  ///
  /// In en, this message translates to:
  /// **'3. Correct Guess'**
  String get ga_rule3Title;

  /// Rule 3 description
  ///
  /// In en, this message translates to:
  /// **'Reveal opponent\'s card! You can continue guessing, combo +1.'**
  String get ga_rule3Desc;

  /// Rule 4 title
  ///
  /// In en, this message translates to:
  /// **'4. Wrong Guess'**
  String get ga_rule4Title;

  /// Rule 4 description
  ///
  /// In en, this message translates to:
  /// **'Turn passes to opponent. Your combo resets.'**
  String get ga_rule4Desc;

  /// Rule 5 title
  ///
  /// In en, this message translates to:
  /// **'5. Win Condition'**
  String get ga_rule5Title;

  /// Rule 5 description
  ///
  /// In en, this message translates to:
  /// **'The player whose cards are all revealed first loses!'**
  String get ga_rule5Desc;

  /// Winner label for player
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get ga_winnerPlayer;

  /// Winner label for opponent
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get ga_winnerOpponent;

  /// AI wrong guess message
  ///
  /// In en, this message translates to:
  /// **'AI guessed wrong!'**
  String get ga_aiWrongGuess;

  /// Wrong guess title
  ///
  /// In en, this message translates to:
  /// **'Wrong Guess!'**
  String get ga_wrongGuessTitle;

  /// Turn to player message
  ///
  /// In en, this message translates to:
  /// **'Your turn now!'**
  String get ga_turnToYou;

  /// Turn to opponent message
  ///
  /// In en, this message translates to:
  /// **'Opponent\'s turn now.'**
  String get ga_turnToOpponent;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get ga_continue;

  /// AI round end title
  ///
  /// In en, this message translates to:
  /// **'AI Round End'**
  String get ga_aiRoundEnd;

  /// AI correct guess count
  ///
  /// In en, this message translates to:
  /// **'AI guessed correctly {correct}/{total} times'**
  String ga_aiCorrectCount(int correct, int total);

  /// Position label with number
  ///
  /// In en, this message translates to:
  /// **'Position {n}'**
  String ga_positionLabel(int n);

  /// Switch turn hint message
  ///
  /// In en, this message translates to:
  /// **'Please hand the device to {name}.\nRemember to hide your cards!'**
  String ga_switchTurnHint(String name);

  /// Winner wins message
  ///
  /// In en, this message translates to:
  /// **'{name} Wins!'**
  String ga_winnerWins(String name);

  /// Opponent wins message
  ///
  /// In en, this message translates to:
  /// **'{name} Wins...'**
  String ga_winnerLoses(String name);

  /// Correct guesses label
  ///
  /// In en, this message translates to:
  /// **'Correct Guesses'**
  String get ga_correctGuessesLabel;

  /// Max combo label
  ///
  /// In en, this message translates to:
  /// **'Max Combo'**
  String get ga_maxComboLabel;

  /// Play duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get ga_playDurationLabel;

  /// Play again button in game over
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get ga_playAgainButton;

  /// Duration format
  ///
  /// In en, this message translates to:
  /// **'{minutes}m {seconds}s'**
  String ga_durationFormat(int minutes, int seconds);

  /// 2048 game title
  ///
  /// In en, this message translates to:
  /// **'2048'**
  String get game_2048;

  /// 2048 game description
  ///
  /// In en, this message translates to:
  /// **'Combine tiles to reach 2048!'**
  String get t48_gameDescription;

  /// 2048 game instructions
  ///
  /// In en, this message translates to:
  /// **'Swipe or use Arrow keys/WASD to move tiles. When two tiles with the same number touch, they merge into one. Try to reach 2048!'**
  String get t48_instructions;

  /// 2048 new game button
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get t48_newGame;

  /// 2048 continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get t48_continue;

  /// 2048 load game button
  ///
  /// In en, this message translates to:
  /// **'Load Game'**
  String get t48_loadGame;

  /// 2048 save game button
  ///
  /// In en, this message translates to:
  /// **'Save Game'**
  String get t48_saveGame;

  /// 2048 save slot label with placeholder
  ///
  /// In en, this message translates to:
  /// **'Save Slot {n}'**
  String t48_saveSlot(int n);

  /// 2048 empty save slot
  ///
  /// In en, this message translates to:
  /// **'Empty Slot'**
  String get t48_emptySlot;

  /// 2048 max tile label
  ///
  /// In en, this message translates to:
  /// **'Max Tile'**
  String get t48_maxTile;

  /// 2048 elapsed time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get t48_elapsedTime;

  /// 2048 exit confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Exit Game'**
  String get t48_exitTitle;

  /// 2048 exit confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Do you want to save your progress before exiting?'**
  String get t48_exitMessage;

  /// 2048 button to exit without saving
  ///
  /// In en, this message translates to:
  /// **'Exit Without Saving'**
  String get t48_exitWithoutSaving;

  /// 2048 button to save and exit
  ///
  /// In en, this message translates to:
  /// **'Save & Exit'**
  String get t48_saveAndExit;

  /// 2048 game over message
  ///
  /// In en, this message translates to:
  /// **'Game Over!'**
  String get t48_gameOver;

  /// 2048 win message
  ///
  /// In en, this message translates to:
  /// **'You Won!'**
  String get t48_youWon;

  /// 2048 play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get t48_playAgain;

  /// 2048 saved time label
  ///
  /// In en, this message translates to:
  /// **'Saved: {time}'**
  String t48_savedAt(String time);

  /// 2048 select save slot message
  ///
  /// In en, this message translates to:
  /// **'Select a save slot'**
  String get t48_selectSlot;

  /// 2048 no saves message
  ///
  /// In en, this message translates to:
  /// **'No saved games'**
  String get t48_noSaves;

  /// 2048 delete save button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get t48_delete;

  /// 2048 overwrite save button
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get t48_overwrite;

  /// 2048 auto-save slot label
  ///
  /// In en, this message translates to:
  /// **'Auto Save'**
  String get t48_autoSave;

  /// 2048 overwrite confirmation message
  ///
  /// In en, this message translates to:
  /// **'This slot already has a save. Overwrite it?'**
  String get t48_overwriteConfirm;

  /// 2048 game saved success message
  ///
  /// In en, this message translates to:
  /// **'Game saved!'**
  String get t48_savedSuccessfully;

  /// 2048 auto-save info tooltip
  ///
  /// In en, this message translates to:
  /// **'Auto-saved every 3 minutes during gameplay'**
  String get t48_autoSaveInfo;

  /// Battle log header
  ///
  /// In en, this message translates to:
  /// **'Battle Log'**
  String get db_battleLog;

  /// Battle started message
  ///
  /// In en, this message translates to:
  /// **'Battle started...'**
  String get db_battleStarted;

  /// Mancala game title
  ///
  /// In en, this message translates to:
  /// **'Mancala'**
  String get game_mancala;

  /// Mancala game description
  ///
  /// In en, this message translates to:
  /// **'Capture more seeds than your opponent in this ancient strategy game!'**
  String get mc_gameDescription;

  /// Mancala game instructions
  ///
  /// In en, this message translates to:
  /// **'Pick up all seeds from one of your pits and sow them counter-clockwise. Land in your store for an extra turn. Land in your empty pit to capture seeds from the opposite pit!'**
  String get mc_instructions;

  /// 2 player mode button
  ///
  /// In en, this message translates to:
  /// **'2 Players'**
  String get mc_twoPlayers;

  /// Easy AI mode button
  ///
  /// In en, this message translates to:
  /// **'Easy AI'**
  String get mc_easyAI;

  /// Medium AI mode button
  ///
  /// In en, this message translates to:
  /// **'Medium AI'**
  String get mc_mediumAI;

  /// Hard AI mode button
  ///
  /// In en, this message translates to:
  /// **'Hard AI'**
  String get mc_hardAI;

  /// How to play button
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get mc_howToPlay;

  /// Your turn label
  ///
  /// In en, this message translates to:
  /// **'Your Turn'**
  String get mc_yourTurn;

  /// Opponent's turn label
  ///
  /// In en, this message translates to:
  /// **'Opponent\'s Turn'**
  String get mc_opponentTurn;

  /// Player's store label
  ///
  /// In en, this message translates to:
  /// **'Your Store'**
  String get mc_playerStore;

  /// Opponent's store label
  ///
  /// In en, this message translates to:
  /// **'Opponent\'s Store'**
  String get mc_opponentStore;

  /// Win message
  ///
  /// In en, this message translates to:
  /// **'You Win!'**
  String get mc_youWin;

  /// Lose message
  ///
  /// In en, this message translates to:
  /// **'You Lose!'**
  String get mc_youLose;

  /// AI wins message
  ///
  /// In en, this message translates to:
  /// **'AI Wins!'**
  String get mc_aiWins;

  /// Draw message
  ///
  /// In en, this message translates to:
  /// **'It\'s a Draw!'**
  String get mc_draw;

  /// Play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get mc_playAgain;

  /// Exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get mc_exit;

  /// Hint to select a pit
  ///
  /// In en, this message translates to:
  /// **'Tap a pit to sow seeds'**
  String get mc_selectPit;

  /// Game saved message
  ///
  /// In en, this message translates to:
  /// **'Game Saved'**
  String get mc_gameSaved;

  /// Extra turn message
  ///
  /// In en, this message translates to:
  /// **'Extra Turn!'**
  String get mc_extraTurn;

  /// Capture message
  ///
  /// In en, this message translates to:
  /// **'Captured!'**
  String get mc_captured;

  /// Color scheme setting label
  ///
  /// In en, this message translates to:
  /// **'Color Scheme'**
  String get colorScheme;

  /// Wooden color scheme option
  ///
  /// In en, this message translates to:
  /// **'Wooden'**
  String get woodenScheme;

  /// Starlight color scheme option
  ///
  /// In en, this message translates to:
  /// **'Starlight'**
  String get starlightScheme;

  /// Forest color scheme option
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forestScheme;

  /// Dice Battle game title
  ///
  /// In en, this message translates to:
  /// **'Dice Battle'**
  String get game_dice_battle;

  /// Dice Battle game description
  ///
  /// In en, this message translates to:
  /// **'Roll the dice, devise strategies, and defeat your opponent!'**
  String get db_gameDescription;

  /// Dice set 1 name
  ///
  /// In en, this message translates to:
  /// **'Balanced Set'**
  String get db_set1Name;

  /// Dice set 2 name
  ///
  /// In en, this message translates to:
  /// **'Offensive Set'**
  String get db_set2Name;

  /// Dice set 3 name
  ///
  /// In en, this message translates to:
  /// **'Defensive Set'**
  String get db_set3Name;

  /// Dice set 4 name
  ///
  /// In en, this message translates to:
  /// **'All-Rounder Set'**
  String get db_set4Name;

  /// Dice set 5 name
  ///
  /// In en, this message translates to:
  /// **'Mixed Set'**
  String get db_set5Name;

  /// Attack label
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get db_attack;

  /// Defense label
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get db_defense;

  /// Roll dice button
  ///
  /// In en, this message translates to:
  /// **'Roll Dice'**
  String get db_rollDice;

  /// Reroll button
  ///
  /// In en, this message translates to:
  /// **'Reroll'**
  String get db_reroll;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get db_confirm;

  /// Finish attack button
  ///
  /// In en, this message translates to:
  /// **'Finish Attack'**
  String get db_finishAttack;

  /// Finish defense button
  ///
  /// In en, this message translates to:
  /// **'Finish Defense'**
  String get db_finishDefense;

  /// Rerolls remaining
  ///
  /// In en, this message translates to:
  /// **'Rerolls Remaining: {n}'**
  String db_rerollsRemaining(int n);

  /// Select attack dice hint
  ///
  /// In en, this message translates to:
  /// **'Select Attack Dice (up to {n})'**
  String db_selectAttackDice(int n);

  /// Select defense dice hint
  ///
  /// In en, this message translates to:
  /// **'Select Defense Dice (up to {n})'**
  String db_selectDefenseDice(int n);

  /// Total points display
  ///
  /// In en, this message translates to:
  /// **'Total Points: {n}'**
  String db_totalPoints(int n);

  /// Damage dealt message
  ///
  /// In en, this message translates to:
  /// **'Dealt {n} damage!'**
  String db_damageDealt(int n);

  /// Perfect block message
  ///
  /// In en, this message translates to:
  /// **'Perfect Block!'**
  String get db_perfectBlock;

  /// Combo hit message
  ///
  /// In en, this message translates to:
  /// **'Combo! Dealt {n} bonus damage!'**
  String db_comboHit(int n);

  /// Keyword: Upgrade
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get db_keywordUpgrade;

  /// Keyword: Instant
  ///
  /// In en, this message translates to:
  /// **'Instant'**
  String get db_keywordInstant;

  /// Keyword: Perfect Block
  ///
  /// In en, this message translates to:
  /// **'Perfect Block'**
  String get db_keywordPerfectBlock;

  /// Keyword: Disrupt
  ///
  /// In en, this message translates to:
  /// **'Disrupt'**
  String get db_keywordDisrupt;

  /// Keyword: Combo
  ///
  /// In en, this message translates to:
  /// **'Combo'**
  String get db_keywordCombo;

  /// Keyword: Upgrade description
  ///
  /// In en, this message translates to:
  /// **'Replace a die with a higher-tier die. Example: Upgrading a d4 changes it to a d6'**
  String get db_keywordUpgradeDesc;

  /// Keyword: Instant description
  ///
  /// In en, this message translates to:
  /// **'Deal x damage to the enemy when triggered. Example: Instant(3) = Deal 3 damage immediately'**
  String get db_keywordInstantDesc;

  /// Keyword: Perfect Block description
  ///
  /// In en, this message translates to:
  /// **'Defense points rolled are greater than or equal to attack points'**
  String get db_keywordPerfectBlockDesc;

  /// Keyword: Disrupt description
  ///
  /// In en, this message translates to:
  /// **'When triggered, reduce one of the opponent\'s dice higher than 2 to 2. If the opponent has no dice higher than 2, nothing happens.'**
  String get db_keywordDisruptDesc;

  /// Keyword: Combo description
  ///
  /// In en, this message translates to:
  /// **'If damage was dealt, deal half the previous damage again. Combo damage rounds up.'**
  String get db_keywordComboDesc;

  /// Effect: Odd Bonus
  ///
  /// In en, this message translates to:
  /// **'Odd Power'**
  String get db_effectOddBonus;

  /// Effect: Odd Bonus description
  ///
  /// In en, this message translates to:
  /// **'If all attack dice show odd numbers, +5 points'**
  String get db_effectOddBonusDesc;

  /// Effect: Even Bonus
  ///
  /// In en, this message translates to:
  /// **'Even Shield'**
  String get db_effectEvenBonus;

  /// Effect: Even Bonus description
  ///
  /// In en, this message translates to:
  /// **'If all defense dice show even numbers, +4 points'**
  String get db_effectEvenBonusDesc;

  /// Effect: Combo on Low Damage
  ///
  /// In en, this message translates to:
  /// **'Low Damage Combo'**
  String get db_effectComboLow;

  /// Effect: Combo on Low Damage description
  ///
  /// In en, this message translates to:
  /// **'If total damage dealt is less than 10, **Combo**'**
  String get db_effectComboLowDesc;

  /// Effect: Dice Upgrade
  ///
  /// In en, this message translates to:
  /// **'Dice Upgrade'**
  String get db_effectDiceUpgrade;

  /// Effect: Dice Upgrade description
  ///
  /// In en, this message translates to:
  /// **'At the start of the round, **Upgrade** one die for both players'**
  String get db_effectDiceUpgradeDesc;

  /// Effect: Perfect Block Instant
  ///
  /// In en, this message translates to:
  /// **'Block Instant'**
  String get db_effectPerfectInstant;

  /// Effect: Perfect Block Instant description
  ///
  /// In en, this message translates to:
  /// **'If **Perfect Block**, then **Instant**(5)'**
  String get db_effectPerfectInstantDesc;

  /// Effect: Combo on High Attack
  ///
  /// In en, this message translates to:
  /// **'High Attack Combo'**
  String get db_effectComboHigh;

  /// Effect: Combo on High Attack description
  ///
  /// In en, this message translates to:
  /// **'If attacker\'s total points exceed 20, attacker gains **Combo**'**
  String get db_effectComboHighDesc;

  /// Effect: Life Sync Bonus
  ///
  /// In en, this message translates to:
  /// **'Life Sync'**
  String get db_effectLifeSync;

  /// Effect: Life Sync Bonus description
  ///
  /// In en, this message translates to:
  /// **'At round end, if the sum of both players\' health equals 42, defender gains +10 health'**
  String get db_effectLifeSyncDesc;

  /// Round number display
  ///
  /// In en, this message translates to:
  /// **'Round {n}'**
  String db_roundNumber(int n);

  /// Player's turn message
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Turn'**
  String db_playerTurn(String name);

  /// Attacking status
  ///
  /// In en, this message translates to:
  /// **'Attacking'**
  String get db_attacking;

  /// Defending status
  ///
  /// In en, this message translates to:
  /// **'Defending'**
  String get db_defending;

  /// Calculating damage status
  ///
  /// In en, this message translates to:
  /// **'Calculating damage...'**
  String get db_calculating;

  /// Round start message
  ///
  /// In en, this message translates to:
  /// **'Round Start'**
  String get db_roundStart;

  /// Round end message
  ///
  /// In en, this message translates to:
  /// **'Round End'**
  String get db_roundEnd;

  /// Coin flip message
  ///
  /// In en, this message translates to:
  /// **'Deciding first player...'**
  String get db_coinFlip;

  /// Player goes first message
  ///
  /// In en, this message translates to:
  /// **'{name} goes first!'**
  String db_goesFirst(String name);

  /// Victory message
  ///
  /// In en, this message translates to:
  /// **'{name} Wins!'**
  String db_victory(String name);

  /// Play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get db_playAgain;

  /// Exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get db_exit;

  /// Two players mode
  ///
  /// In en, this message translates to:
  /// **'Two Players'**
  String get db_twoPlayers;

  /// Easy AI mode
  ///
  /// In en, this message translates to:
  /// **'Easy AI'**
  String get db_easyAI;

  /// Medium AI mode
  ///
  /// In en, this message translates to:
  /// **'Medium AI'**
  String get db_mediumAI;

  /// Hard AI mode
  ///
  /// In en, this message translates to:
  /// **'Hard AI'**
  String get db_hardAI;

  /// Select dice set label
  ///
  /// In en, this message translates to:
  /// **'Select Dice Set'**
  String get db_selectDiceSet;

  /// Player 1 select dice set
  ///
  /// In en, this message translates to:
  /// **'Player 1 Select Set'**
  String get db_player1Select;

  /// Player 2 select dice set
  ///
  /// In en, this message translates to:
  /// **'Player 2 Select Set'**
  String get db_player2Select;

  /// Game rules button
  ///
  /// In en, this message translates to:
  /// **'Game Rules'**
  String get db_gameRules;

  /// Attack points label
  ///
  /// In en, this message translates to:
  /// **'Attack Points'**
  String get db_attackPoints;

  /// Defense points label
  ///
  /// In en, this message translates to:
  /// **'Defense Points'**
  String get db_defensePoints;

  /// Dice configuration label
  ///
  /// In en, this message translates to:
  /// **'Dice Configuration'**
  String get db_diceConfig;

  /// Health remaining display
  ///
  /// In en, this message translates to:
  /// **'Health Remaining: {hp}'**
  String db_healthRemaining(int hp);

  /// Field effect label
  ///
  /// In en, this message translates to:
  /// **'Field Effect'**
  String get db_fieldEffect;

  /// No active effect message
  ///
  /// In en, this message translates to:
  /// **'No Active Effect'**
  String get db_noActiveEffect;

  /// Hearts game title
  ///
  /// In en, this message translates to:
  /// **'Hearts'**
  String get hearts_game_hearts;

  /// Hearts game description
  ///
  /// In en, this message translates to:
  /// **'Avoid hearts and Queen of Spades!'**
  String get hearts_description;

  /// How to play button
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get hearts_howToPlay;

  /// Start game button
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get hearts_startGame;

  /// Play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get hearts_playAgain;

  /// Dealing cards message
  ///
  /// In en, this message translates to:
  /// **'Dealing cards...'**
  String get hearts_dealing;

  /// Pass phase label
  ///
  /// In en, this message translates to:
  /// **'Pass Phase'**
  String get hearts_passing;

  /// Playing status
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get hearts_playing;

  /// Round end label
  ///
  /// In en, this message translates to:
  /// **'Round End'**
  String get hearts_roundEnd;

  /// Game over label
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get hearts_gameOver;

  /// AI thinking message
  ///
  /// In en, this message translates to:
  /// **'AI is thinking...'**
  String get hearts_aiThinking;

  /// Pass direction label
  ///
  /// In en, this message translates to:
  /// **'Pass Direction'**
  String get hearts_passDirection;

  /// Pass left direction
  ///
  /// In en, this message translates to:
  /// **'Pass Left'**
  String get hearts_passLeft;

  /// Pass right direction
  ///
  /// In en, this message translates to:
  /// **'Pass Right'**
  String get hearts_passRight;

  /// Pass across direction
  ///
  /// In en, this message translates to:
  /// **'Pass Across'**
  String get hearts_passAcross;

  /// Hold (no pass) option
  ///
  /// In en, this message translates to:
  /// **'Hold (No Pass)'**
  String get hearts_passHold;

  /// Select cards to pass instruction
  ///
  /// In en, this message translates to:
  /// **'Select {n} cards to pass'**
  String hearts_selectCardsToPass(int n);

  /// Pass timer display
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {s}s'**
  String hearts_passTimer(int s);

  /// Confirm pass button
  ///
  /// In en, this message translates to:
  /// **'Confirm Pass'**
  String get hearts_confirmPass;

  /// Unlimited timer option
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get hearts_timerUnlimited;

  /// 15 second timer option
  ///
  /// In en, this message translates to:
  /// **'15 seconds'**
  String get hearts_timer15s;

  /// 20 second timer option
  ///
  /// In en, this message translates to:
  /// **'20 seconds'**
  String get hearts_timer20s;

  /// 30 second timer option
  ///
  /// In en, this message translates to:
  /// **'30 seconds'**
  String get hearts_timer30s;

  /// Your turn message
  ///
  /// In en, this message translates to:
  /// **'Your turn!'**
  String get hearts_yourTurn;

  /// Waiting for opponent message
  ///
  /// In en, this message translates to:
  /// **'Waiting for opponent...'**
  String get hearts_waitTurn;

  /// Hearts broken message
  ///
  /// In en, this message translates to:
  /// **'Hearts Broken!'**
  String get hearts_heartsBroken;

  /// First trick instruction
  ///
  /// In en, this message translates to:
  /// **'First trick - 2♣ leads'**
  String get hearts_firstTrick;

  /// Trick won message
  ///
  /// In en, this message translates to:
  /// **'Trick won by {player}'**
  String hearts_trickWon(String player);

  /// Round scores label
  ///
  /// In en, this message translates to:
  /// **'Round Scores'**
  String get hearts_roundScores;

  /// Total scores label
  ///
  /// In en, this message translates to:
  /// **'Total Scores'**
  String get hearts_totalScores;

  /// Points taken label
  ///
  /// In en, this message translates to:
  /// **'Points taken'**
  String get hearts_pointsTaken;

  /// Hearts count display
  ///
  /// In en, this message translates to:
  /// **'Hearts: {n}'**
  String hearts_heartsCount(int n);

  /// Shoot the moon message
  ///
  /// In en, this message translates to:
  /// **'Shoot the Moon!'**
  String get hearts_shootMoon;

  /// Shoot moon success message
  ///
  /// In en, this message translates to:
  /// **'Successfully shot the moon!'**
  String get hearts_shootMoonSuccess;

  /// Announce moon option
  ///
  /// In en, this message translates to:
  /// **'Announce moon attempt'**
  String get hearts_announceMoonOption;

  /// Hide moon option
  ///
  /// In en, this message translates to:
  /// **'Hide moon attempt'**
  String get hearts_hideMoonOption;

  /// Player number with placeholder
  ///
  /// In en, this message translates to:
  /// **'Player {n}'**
  String hearts_player(int n);

  /// Player you label
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get hearts_you;

  /// Winner label
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get hearts_winner;

  /// Final results label
  ///
  /// In en, this message translates to:
  /// **'Final Results'**
  String get hearts_finalResults;

  /// Rule 1 title
  ///
  /// In en, this message translates to:
  /// **'1. Goal'**
  String get hearts_rule1Title;

  /// Rule 1 description
  ///
  /// In en, this message translates to:
  /// **'Avoid collecting hearts (♥ = 1 point each) and Queen of Spades (♠Q = 13 points). Lowest score wins!'**
  String get hearts_rule1Desc;

  /// Rule 2 title
  ///
  /// In en, this message translates to:
  /// **'2. Passing'**
  String get hearts_rule2Title;

  /// Rule 2 description
  ///
  /// In en, this message translates to:
  /// **'Before each round, pass 3 cards: left→right→across→hold, cycling every 4 rounds.'**
  String get hearts_rule2Desc;

  /// Rule 3 title
  ///
  /// In en, this message translates to:
  /// **'3. Playing'**
  String get hearts_rule3Title;

  /// Rule 3 description
  ///
  /// In en, this message translates to:
  /// **'Player with 2♣ leads first trick. Must follow suit if possible. Hearts can\'t lead until \"broken\".'**
  String get hearts_rule3Desc;

  /// Rule 4 title
  ///
  /// In en, this message translates to:
  /// **'4. Scoring'**
  String get hearts_rule4Title;

  /// Rule 4 description
  ///
  /// In en, this message translates to:
  /// **'Collect all 14 penalty cards = Shoot the Moon (you get 0, others get 26). Game ends at 100 points.'**
  String get hearts_rule4Desc;

  /// Rule 5 title
  ///
  /// In en, this message translates to:
  /// **'5. Winning'**
  String get hearts_rule5Title;

  /// Rule 5 description
  ///
  /// In en, this message translates to:
  /// **'Lowest total score wins when game ends!'**
  String get hearts_rule5Desc;

  /// Resume button
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get hearts_resume;

  /// Save game button
  ///
  /// In en, this message translates to:
  /// **'Save Game'**
  String get hearts_saveGame;

  /// Load game button
  ///
  /// In en, this message translates to:
  /// **'Load Game'**
  String get hearts_loadGame;

  /// New game button
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get hearts_newGame;

  /// Exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get hearts_exitGame;

  /// AI difficulty setting
  ///
  /// In en, this message translates to:
  /// **'AI Difficulty'**
  String get hearts_aiDifficulty;

  /// Random position setting
  ///
  /// In en, this message translates to:
  /// **'Random player position'**
  String get hearts_randomPosition;

  /// Pass timer setting
  ///
  /// In en, this message translates to:
  /// **'Pass timer'**
  String get hearts_passTimerSetting;

  /// Pass complete dialog title
  ///
  /// In en, this message translates to:
  /// **'Pass Complete'**
  String get hearts_passComplete;

  /// Received cards dialog message
  ///
  /// In en, this message translates to:
  /// **'You received these cards:'**
  String get hearts_receivedCards;

  /// Continue button after showing received cards
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get hearts_continuePlaying;

  /// Coming soon text
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Bluff Bar game title
  ///
  /// In en, this message translates to:
  /// **'Bluff Bar'**
  String get game_bluff_bar;

  /// Bluff Bar game title displayed in game
  ///
  /// In en, this message translates to:
  /// **'Bluff Bar'**
  String get bb_game_title;

  /// Bluff Bar game subtitle
  ///
  /// In en, this message translates to:
  /// **'Bluff, Challenge, Survive'**
  String get bb_game_subtitle;

  /// Bluff Bar game description
  ///
  /// In en, this message translates to:
  /// **'A poker-style bluffing game with Russian roulette elimination'**
  String get bb_gameDescription;

  /// Setup phase label
  ///
  /// In en, this message translates to:
  /// **'Setup Phase'**
  String get bb_phase_setup;

  /// Dealing phase label
  ///
  /// In en, this message translates to:
  /// **'Dealing Phase'**
  String get bb_phase_deal;

  /// Play phase label
  ///
  /// In en, this message translates to:
  /// **'Play Phase'**
  String get bb_phase_play;

  /// Challenge phase label
  ///
  /// In en, this message translates to:
  /// **'Challenge Phase'**
  String get bb_phase_challenge;

  /// Reveal phase label
  ///
  /// In en, this message translates to:
  /// **'Reveal Phase'**
  String get bb_phase_reveal;

  /// Russian roulette phase label
  ///
  /// In en, this message translates to:
  /// **'Russian Roulette'**
  String get bb_phase_roulette;

  /// Round end phase label
  ///
  /// In en, this message translates to:
  /// **'Round End'**
  String get bb_phase_roundEnd;

  /// Game over phase label
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get bb_phase_gameOver;

  /// Target card label
  ///
  /// In en, this message translates to:
  /// **'Target Card'**
  String get bb_target_card;

  /// Jack is the target card
  ///
  /// In en, this message translates to:
  /// **'Target: J'**
  String get bb_target_jacks;

  /// Queen is the target card
  ///
  /// In en, this message translates to:
  /// **'Target: Q'**
  String get bb_target_queens;

  /// King is the target card
  ///
  /// In en, this message translates to:
  /// **'Target: K'**
  String get bb_target_kings;

  /// Ace is the target card
  ///
  /// In en, this message translates to:
  /// **'Target: A'**
  String get bb_target_aces;

  /// Play cards button
  ///
  /// In en, this message translates to:
  /// **'Play Cards'**
  String get bb_play_cards;

  /// Challenge button
  ///
  /// In en, this message translates to:
  /// **'Challenge!'**
  String get bb_challenge;

  /// Pass button
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get bb_pass;

  /// Select cards label
  ///
  /// In en, this message translates to:
  /// **'Select Cards'**
  String get bb_select_cards;

  /// Claim label
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get bb_claim;

  /// Claiming message with count and rank placeholders
  ///
  /// In en, this message translates to:
  /// **'{count} {rank}s'**
  String bb_claiming(int count, String rank);

  /// Cards played message with count placeholder
  ///
  /// In en, this message translates to:
  /// **'{count} cards played'**
  String bb_cards_played(int count);

  /// Challenge successful message
  ///
  /// In en, this message translates to:
  /// **'Challenge Successful!'**
  String get bb_challenge_successful;

  /// Challenge failed message
  ///
  /// In en, this message translates to:
  /// **'Challenge Failed'**
  String get bb_challenge_failed;

  /// Liar caught message
  ///
  /// In en, this message translates to:
  /// **'Caught the Liar!'**
  String get bb_liar_guilty;

  /// Honest play message
  ///
  /// In en, this message translates to:
  /// **'Honest Play!'**
  String get bb_liar_innocent;

  /// Draw roulette card button
  ///
  /// In en, this message translates to:
  /// **'Draw Roulette Card'**
  String get bb_roulette_draw;

  /// Survived roulette message
  ///
  /// In en, this message translates to:
  /// **'Survived!'**
  String get bb_roulette_survived;

  /// Eliminated by roulette message
  ///
  /// In en, this message translates to:
  /// **'Eliminated!'**
  String get bb_roulette_eliminated;

  /// Roulette cards remaining message with count placeholder
  ///
  /// In en, this message translates to:
  /// **'{count} cards remaining'**
  String bb_roulette_remaining(int count);

  /// Your turn message
  ///
  /// In en, this message translates to:
  /// **'Your Turn'**
  String get bb_your_turn;

  /// Opponent's turn message
  ///
  /// In en, this message translates to:
  /// **'Opponent\'s Turn'**
  String get bb_opponent_turn;

  /// Cards in hand message with count placeholder
  ///
  /// In en, this message translates to:
  /// **'{count} cards in hand'**
  String bb_cards_in_hand(int count);

  /// Eliminated player label
  ///
  /// In en, this message translates to:
  /// **'Eliminated'**
  String get bb_eliminated_player;

  /// AI thinking message
  ///
  /// In en, this message translates to:
  /// **'AI Thinking...'**
  String get bb_ai_thinking;

  /// AI playing message
  ///
  /// In en, this message translates to:
  /// **'AI Playing...'**
  String get bb_ai_playing;

  /// AI challenges message
  ///
  /// In en, this message translates to:
  /// **'AI Challenges!'**
  String get bb_ai_challenging;

  /// Winner message with name placeholder
  ///
  /// In en, this message translates to:
  /// **'{name} Wins!'**
  String bb_winner(String name);

  /// Last survivor label
  ///
  /// In en, this message translates to:
  /// **'Last Survivor'**
  String get bb_last_survivor;

  /// Play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get bb_play_again;

  /// Exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get bb_exit;

  /// AI difficulty setting label
  ///
  /// In en, this message translates to:
  /// **'AI Difficulty'**
  String get bb_ai_difficulty;

  /// Easy difficulty option
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get bb_easy;

  /// Medium difficulty option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get bb_medium;

  /// Hard difficulty option
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get bb_hard;

  /// Start game button
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get bb_start_game;

  /// How to play button
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get bb_how_to_play;

  /// Rule 1 title
  ///
  /// In en, this message translates to:
  /// **'1. Target Card'**
  String get bb_rule1_title;

  /// Rule 1 description
  ///
  /// In en, this message translates to:
  /// **'Each round randomly designates J/Q/K/A as the target card. That card and Joker count as \"real cards\".'**
  String get bb_rule1_desc;

  /// Rule 2 title
  ///
  /// In en, this message translates to:
  /// **'2. Playing Cards'**
  String get bb_rule2_title;

  /// Rule 2 description
  ///
  /// In en, this message translates to:
  /// **'Each turn, play 1-5 cards face-down and claim they are target cards.'**
  String get bb_rule2_desc;

  /// Rule 3 title
  ///
  /// In en, this message translates to:
  /// **'3. Challenge'**
  String get bb_rule3_title;

  /// Rule 3 description
  ///
  /// In en, this message translates to:
  /// **'Call \"Liar!\" to challenge the previous player. Flip cards to verify: fake cards = challenger wins, real cards = challenger loses.'**
  String get bb_rule3_desc;

  /// Rule 4 title
  ///
  /// In en, this message translates to:
  /// **'4. Elimination'**
  String get bb_rule4_title;

  /// Rule 4 description
  ///
  /// In en, this message translates to:
  /// **'The loser triggers Russian roulette: draw a card. Live bullet = eliminated.'**
  String get bb_rule4_desc;

  /// Rule 5 title
  ///
  /// In en, this message translates to:
  /// **'5. Victory'**
  String get bb_rule5_title;

  /// Rule 5 description
  ///
  /// In en, this message translates to:
  /// **'Become the last surviving player to win!'**
  String get bb_rule5_desc;

  /// Got it button
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get bb_got_it;

  /// 2 player mode button
  ///
  /// In en, this message translates to:
  /// **'2 Players'**
  String get bb_two_players;

  /// VS AI mode button
  ///
  /// In en, this message translates to:
  /// **'VS AI'**
  String get bb_vs_ai;

  /// Eliminated status badge
  ///
  /// In en, this message translates to:
  /// **'ELIMINATED'**
  String get bb_eliminated;

  /// Survived status message
  ///
  /// In en, this message translates to:
  /// **'SURVIVED!'**
  String get bb_survived;

  /// Draw card button for roulette
  ///
  /// In en, this message translates to:
  /// **'Draw Card'**
  String get bb_draw_card;

  /// Drawing status text
  ///
  /// In en, this message translates to:
  /// **'Drawing...'**
  String get bb_drawing;

  /// Cards remaining text
  ///
  /// In en, this message translates to:
  /// **'{count} cards remaining'**
  String bb_cards_remaining(int count);

  /// Empty played pile message
  ///
  /// In en, this message translates to:
  /// **'No cards played yet'**
  String get bb_no_cards_played;

  /// Total cards played text
  ///
  /// In en, this message translates to:
  /// **'{count} cards played'**
  String bb_cards_played_total(int count);

  /// Empty hand message
  ///
  /// In en, this message translates to:
  /// **'No cards'**
  String get bb_no_cards;

  /// Game mode description
  ///
  /// In en, this message translates to:
  /// **'1 Player + 3 AI'**
  String get bb_one_player_three_ai;

  /// Exit confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit? Progress will be lost.'**
  String get bb_exit_confirm;

  /// Round number display
  ///
  /// In en, this message translates to:
  /// **'Round {number}'**
  String bb_round(int number);

  /// Round ranking title
  ///
  /// In en, this message translates to:
  /// **'Round {number} Rankings'**
  String bb_round_ranking(int number);

  /// Roulette shots label
  ///
  /// In en, this message translates to:
  /// **'Shots fired'**
  String get bb_roulette_shots;

  /// Claim selection hint
  ///
  /// In en, this message translates to:
  /// **'Select claim rank'**
  String get bb_select_claim;

  /// Hand section title
  ///
  /// In en, this message translates to:
  /// **'Your Hand'**
  String get bb_your_hand;

  /// Waiting for opponent message
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name}...'**
  String bb_waiting_for(String name);

  /// Placeholder message
  ///
  /// In en, this message translates to:
  /// **'Game screen coming soon!'**
  String get bb_game_screen_coming;

  /// North position
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get bb_position_north;

  /// South position
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get bb_position_south;

  /// East position
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get bb_position_east;

  /// West position
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get bb_position_west;

  /// Challenge overlay title with challenger and challenged player names
  ///
  /// In en, this message translates to:
  /// **'{challenger} challenges {challenged}'**
  String bb_challenge_title(String challenger, String challenged);

  /// Label for revealed cards section in challenge overlay
  ///
  /// In en, this message translates to:
  /// **'Revealed Cards'**
  String get bb_revealed_cards;

  /// Challenge result - player was lying
  ///
  /// In en, this message translates to:
  /// **'Liar!'**
  String get bb_liar;

  /// Challenge result - player was telling truth
  ///
  /// In en, this message translates to:
  /// **'Honest!'**
  String get bb_honest;

  /// Label indicating player must face Russian roulette
  ///
  /// In en, this message translates to:
  /// **'faces Roulette'**
  String get bb_face_roulette;

  /// Victory result text
  ///
  /// In en, this message translates to:
  /// **'VICTORY'**
  String get bb_victory;

  /// Defeat result text
  ///
  /// In en, this message translates to:
  /// **'DEFEAT'**
  String get bb_defeat;

  /// Rankings section title
  ///
  /// In en, this message translates to:
  /// **'Rankings'**
  String get bb_ranking;

  /// Rounds survived text
  ///
  /// In en, this message translates to:
  /// **'{count} rounds'**
  String bb_rounds_survived(int count);

  /// Reaction Test game title
  ///
  /// In en, this message translates to:
  /// **'Reaction Test'**
  String get game_reaction_test;

  /// Reaction Test game description
  ///
  /// In en, this message translates to:
  /// **'Test your reflexes! Tap as fast as you can when colors change.'**
  String get rt_gameDescription;

  /// Reaction Test game instructions
  ///
  /// In en, this message translates to:
  /// **'Wait for the background color to change, then tap as fast as you can!'**
  String get rt_instructions;

  /// Color preset selection label
  ///
  /// In en, this message translates to:
  /// **'Select Color Scheme'**
  String get rt_selectPreset;

  /// Red-green colorblind friendly preset
  ///
  /// In en, this message translates to:
  /// **'Red-Green Colorblind'**
  String get rt_redGreenColorblind;

  /// Blue-yellow colorblind friendly preset
  ///
  /// In en, this message translates to:
  /// **'Blue-Yellow Colorblind'**
  String get rt_blueYellowColorblind;

  /// Monochromacy (grayscale) preset
  ///
  /// In en, this message translates to:
  /// **'Monochromacy'**
  String get rt_monochromacy;

  /// Custom color selection option
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get rt_custom;

  /// Before color selection label
  ///
  /// In en, this message translates to:
  /// **'Before Color'**
  String get rt_beforeColor;

  /// After color selection label
  ///
  /// In en, this message translates to:
  /// **'After Color'**
  String get rt_afterColor;

  /// Warning when same color is selected
  ///
  /// In en, this message translates to:
  /// **'Before and After colors cannot be the same!'**
  String get rt_sameColorWarning;

  /// Current test number display
  ///
  /// In en, this message translates to:
  /// **'Test {current} of {total}'**
  String rt_testNumber(int current, int total);

  /// Instruction to wait for color change
  ///
  /// In en, this message translates to:
  /// **'Wait for it...'**
  String get rt_waitForIt;

  /// Instruction to tap when color changed
  ///
  /// In en, this message translates to:
  /// **'TAP NOW!'**
  String get rt_tapNow;

  /// Reaction time display in milliseconds
  ///
  /// In en, this message translates to:
  /// **'{time} ms'**
  String rt_reactionTime(int time);

  /// Results dialog title
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get rt_results;

  /// Average reaction time label
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get rt_average;

  /// Best reaction time label
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get rt_best;

  /// Worst reaction time label
  ///
  /// In en, this message translates to:
  /// **'Worst'**
  String get rt_worst;

  /// Warning when user taps before color changes
  ///
  /// In en, this message translates to:
  /// **'Too early! Wait for the color to change.'**
  String get rt_tooEarly;

  /// Leaderboard dialog title
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// Leaderboard subtitle for reaction test
  ///
  /// In en, this message translates to:
  /// **'Fastest reaction times'**
  String get rt_leaderboardSubtitle;

  /// Message when no leaderboard records exist
  ///
  /// In en, this message translates to:
  /// **'No records yet. Play to set your first record!'**
  String get rt_noRecords;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Aim Test game title
  ///
  /// In en, this message translates to:
  /// **'Aim Test'**
  String get game_aim_test;

  /// Aim Test game description
  ///
  /// In en, this message translates to:
  /// **'Test your aim! Click the bubbles as fast as you can in 30 seconds.'**
  String get at_gameDescription;

  /// Aim Test game instructions
  ///
  /// In en, this message translates to:
  /// **'Click the bubbles before they disappear! You have 30 seconds.'**
  String get at_instructions;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get at_settings;

  /// Dead zone setting label
  ///
  /// In en, this message translates to:
  /// **'Dead Zone'**
  String get at_deadZone;

  /// Dead zone percentage display
  ///
  /// In en, this message translates to:
  /// **'{percent}% dead zone'**
  String at_deadZonePercent(int percent);

  /// Bubble color setting label
  ///
  /// In en, this message translates to:
  /// **'Bubble Color'**
  String get at_bubbleColor;

  /// Game duration setting label
  ///
  /// In en, this message translates to:
  /// **'Game Duration'**
  String get at_gameDuration;

  /// Missed clicks counter label
  ///
  /// In en, this message translates to:
  /// **'Misses'**
  String get at_misses;

  /// Enable bubble appear animation setting
  ///
  /// In en, this message translates to:
  /// **'Bubble Animation'**
  String get at_appearAnimation;

  /// Bubble size setting label
  ///
  /// In en, this message translates to:
  /// **'Bubble Size'**
  String get at_bubbleSize;

  /// Live preview label for settings
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get at_preview;

  /// Hits counter label
  ///
  /// In en, this message translates to:
  /// **'Hits'**
  String get at_hits;

  /// Accuracy percentage label
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get at_accuracy;

  /// Game over dialog title
  ///
  /// In en, this message translates to:
  /// **'Game Over!'**
  String get at_gameOver;

  /// Final score label
  ///
  /// In en, this message translates to:
  /// **'Final Score'**
  String get at_finalScore;

  /// Total bubbles spawned label
  ///
  /// In en, this message translates to:
  /// **'Bubbles Spawned'**
  String get at_bubblesSpawned;

  /// Time's up message
  ///
  /// In en, this message translates to:
  /// **'Time\'s Up!'**
  String get at_timeUp;

  /// Play again button
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get at_playAgain;

  /// Start game button
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get at_startGame;

  /// Countdown number 3
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get at_countdown3;

  /// Countdown number 2
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get at_countdown2;

  /// Countdown number 1
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get at_countdown1;

  /// Countdown GO! message
  ///
  /// In en, this message translates to:
  /// **'GO!'**
  String get at_countdownGo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
