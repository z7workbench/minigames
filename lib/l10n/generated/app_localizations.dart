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
  /// **'System Default'**
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
  /// **'Swipe to move tiles. When two tiles with the same number touch, they merge into one. Try to reach 2048!'**
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
