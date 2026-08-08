import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('my')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AI Sports Training'**
  String get appName;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pose Analysis Assistant'**
  String get splashSubtitle;

  /// No description provided for @splashDescription.
  ///
  /// In en, this message translates to:
  /// **'Master your sport with AI-powered pose analysis and personalized training plans.'**
  String get splashDescription;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your training'**
  String get signInToContinue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signingIn;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @startTrainingJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your training journey today'**
  String get startTrainingJourney;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// No description provided for @includeUppercase.
  ///
  /// In en, this message translates to:
  /// **'Include at least one uppercase letter'**
  String get includeUppercase;

  /// No description provided for @includeLowercase.
  ///
  /// In en, this message translates to:
  /// **'Include at least one lowercase letter'**
  String get includeLowercase;

  /// No description provided for @includeNumber.
  ///
  /// In en, this message translates to:
  /// **'Include at least one number'**
  String get includeNumber;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Min 8 characters, include uppercase, lowercase and number'**
  String get passwordHint;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating Account...'**
  String get creatingAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get training;

  /// No description provided for @poses.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get poses;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmi;

  /// No description provided for @fitnessScore.
  ///
  /// In en, this message translates to:
  /// **'Fitness Score'**
  String get fitnessScore;

  /// No description provided for @weeklyProgress.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @poseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Pose\nAnalysis'**
  String get poseAnalysis;

  /// No description provided for @trainingDetails.
  ///
  /// In en, this message translates to:
  /// **'Training\nDetails'**
  String get trainingDetails;

  /// No description provided for @injuryPrevention.
  ///
  /// In en, this message translates to:
  /// **'Injury\nPrevention'**
  String get injuryPrevention;

  /// No description provided for @poseAnalysisHistory.
  ///
  /// In en, this message translates to:
  /// **'Pose Analysis History'**
  String get poseAnalysisHistory;

  /// No description provided for @squatAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Squat Analysis'**
  String get squatAnalysis;

  /// No description provided for @accuracy87percent.
  ///
  /// In en, this message translates to:
  /// **'87% accuracy'**
  String get accuracy87percent;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'2 hours ago'**
  String get hoursAgo;

  /// No description provided for @lungeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Lunge Analysis'**
  String get lungeAnalysis;

  /// No description provided for @accuracy82percent.
  ///
  /// In en, this message translates to:
  /// **'82% accuracy'**
  String get accuracy82percent;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @deadliftAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Deadlift Analysis'**
  String get deadliftAnalysis;

  /// No description provided for @accuracy91percent.
  ///
  /// In en, this message translates to:
  /// **'91% accuracy'**
  String get accuracy91percent;

  /// No description provided for @daysAgo2.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get daysAgo2;

  /// No description provided for @recommendedPlans.
  ///
  /// In en, this message translates to:
  /// **'Recommended Plans'**
  String get recommendedPlans;

  /// No description provided for @aiTrainingPlan.
  ///
  /// In en, this message translates to:
  /// **'AI Training Plan'**
  String get aiTrainingPlan;

  /// No description provided for @getPersonalizedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get personalized training recommendations'**
  String get getPersonalizedRecommendations;

  /// No description provided for @trainingHistory.
  ///
  /// In en, this message translates to:
  /// **'Training History'**
  String get trainingHistory;

  /// No description provided for @footballTraining.
  ///
  /// In en, this message translates to:
  /// **'Football Training'**
  String get footballTraining;

  /// No description provided for @minSession60.
  ///
  /// In en, this message translates to:
  /// **'60 min session'**
  String get minSession60;

  /// No description provided for @daysAgo3.
  ///
  /// In en, this message translates to:
  /// **'3 days ago'**
  String get daysAgo3;

  /// No description provided for @cardioWorkout.
  ///
  /// In en, this message translates to:
  /// **'Cardio Workout'**
  String get cardioWorkout;

  /// No description provided for @minSession45.
  ///
  /// In en, this message translates to:
  /// **'45 min session'**
  String get minSession45;

  /// No description provided for @daysAgo4.
  ///
  /// In en, this message translates to:
  /// **'4 days ago'**
  String get daysAgo4;

  /// No description provided for @strengthTraining.
  ///
  /// In en, this message translates to:
  /// **'Strength Training'**
  String get strengthTraining;

  /// No description provided for @minSession50.
  ///
  /// In en, this message translates to:
  /// **'50 min session'**
  String get minSession50;

  /// No description provided for @daysAgo5.
  ///
  /// In en, this message translates to:
  /// **'5 days ago'**
  String get daysAgo5;

  /// No description provided for @athlete.
  ///
  /// In en, this message translates to:
  /// **'Athlete'**
  String get athlete;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @selectYourSport.
  ///
  /// In en, this message translates to:
  /// **'Select Your Sport'**
  String get selectYourSport;

  /// No description provided for @chooseSportDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a sport to start your personalized training journey.'**
  String get chooseSportDescription;

  /// No description provided for @noSportsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Sports Available'**
  String get noSportsAvailable;

  /// No description provided for @sportsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Sports will appear here once added.'**
  String get sportsWillAppear;

  /// No description provided for @failedToLoadSports.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Sports'**
  String get failedToLoadSports;

  /// No description provided for @noTypeAvailable.
  ///
  /// In en, this message translates to:
  /// **'No {type} Available'**
  String noTypeAvailable(Object type);

  /// No description provided for @sectionUpdatedSoon.
  ///
  /// In en, this message translates to:
  /// **'This section will be updated soon.'**
  String get sectionUpdatedSoon;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Data'**
  String get failedToLoadData;

  /// No description provided for @cameraPreview.
  ///
  /// In en, this message translates to:
  /// **'Camera Preview'**
  String get cameraPreview;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @bodyBalance.
  ///
  /// In en, this message translates to:
  /// **'Body\nBalance'**
  String get bodyBalance;

  /// No description provided for @kneeAngle.
  ///
  /// In en, this message translates to:
  /// **'Knee\nAngle'**
  String get kneeAngle;

  /// No description provided for @legPosition.
  ///
  /// In en, this message translates to:
  /// **'Leg\nPosition'**
  String get legPosition;

  /// No description provided for @followThrough.
  ///
  /// In en, this message translates to:
  /// **'Follow\nThrough'**
  String get followThrough;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @startAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Start Analysis'**
  String get startAnalysis;

  /// No description provided for @poseFeedback.
  ///
  /// In en, this message translates to:
  /// **'Pose Feedback'**
  String get poseFeedback;

  /// No description provided for @yourPose.
  ///
  /// In en, this message translates to:
  /// **'Your Pose'**
  String get yourPose;

  /// No description provided for @idealPose.
  ///
  /// In en, this message translates to:
  /// **'Ideal Pose'**
  String get idealPose;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @goodForm.
  ///
  /// In en, this message translates to:
  /// **'Good Form'**
  String get goodForm;

  /// No description provided for @strengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get strengths;

  /// No description provided for @feedbackBackAlignment.
  ///
  /// In en, this message translates to:
  /// **'Good back alignment during the movement'**
  String get feedbackBackAlignment;

  /// No description provided for @feedbackKneeTracking.
  ///
  /// In en, this message translates to:
  /// **'Proper knee tracking over toes'**
  String get feedbackKneeTracking;

  /// No description provided for @feedbackTempo.
  ///
  /// In en, this message translates to:
  /// **'Consistent tempo throughout'**
  String get feedbackTempo;

  /// No description provided for @areasToImprove.
  ///
  /// In en, this message translates to:
  /// **'Areas to Improve'**
  String get areasToImprove;

  /// No description provided for @feedbackArmStability.
  ///
  /// In en, this message translates to:
  /// **'Arm position could be more stable'**
  String get feedbackArmStability;

  /// No description provided for @feedbackForwardLean.
  ///
  /// In en, this message translates to:
  /// **'Slightly forward lean at bottom'**
  String get feedbackForwardLean;

  /// No description provided for @improvementSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Improvement Suggestions'**
  String get improvementSuggestions;

  /// No description provided for @suggestionChestUp.
  ///
  /// In en, this message translates to:
  /// **'Keep your chest up throughout the movement'**
  String get suggestionChestUp;

  /// No description provided for @suggestionHeels.
  ///
  /// In en, this message translates to:
  /// **'Focus on driving through your heels'**
  String get suggestionHeels;

  /// No description provided for @suggestionMirror.
  ///
  /// In en, this message translates to:
  /// **'Practice with a mirror to check form'**
  String get suggestionMirror;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// No description provided for @aiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendation'**
  String get aiRecommendation;

  /// No description provided for @fitnessLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Fitness Level: Intermediate'**
  String get fitnessLevelIntermediate;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @personalizedTrainingPlan.
  ///
  /// In en, this message translates to:
  /// **'Personalized Training Plan'**
  String get personalizedTrainingPlan;

  /// No description provided for @weeklyWorkoutPlan.
  ///
  /// In en, this message translates to:
  /// **'Weekly Workout Plan'**
  String get weeklyWorkoutPlan;

  /// No description provided for @sessionsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'5 sessions per week, 45 min each'**
  String get sessionsPerWeek;

  /// No description provided for @exerciseRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Exercise Recommendations'**
  String get exerciseRecommendations;

  /// No description provided for @basedOnFitnessLevel.
  ///
  /// In en, this message translates to:
  /// **'Based on your fitness level'**
  String get basedOnFitnessLevel;

  /// No description provided for @nutritionGuide.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Guide'**
  String get nutritionGuide;

  /// No description provided for @customizedMealPlans.
  ///
  /// In en, this message translates to:
  /// **'Customized meal plans for performance'**
  String get customizedMealPlans;

  /// No description provided for @startTrainingPlan.
  ///
  /// In en, this message translates to:
  /// **'Start Training Plan'**
  String get startTrainingPlan;

  /// No description provided for @stretchingWarmUp.
  ///
  /// In en, this message translates to:
  /// **'Stretching & Warm Up'**
  String get stretchingWarmUp;

  /// No description provided for @preventInjuriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Prevent injuries with proper preparation'**
  String get preventInjuriesDescription;

  /// No description provided for @warmUpExercises.
  ///
  /// In en, this message translates to:
  /// **'Warm Up Exercises'**
  String get warmUpExercises;

  /// No description provided for @startWarmUp.
  ///
  /// In en, this message translates to:
  /// **'Start Warm Up'**
  String get startWarmUp;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @dribblingDrill.
  ///
  /// In en, this message translates to:
  /// **'Dribbling Drill'**
  String get dribblingDrill;

  /// No description provided for @dribblingDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice close ball control through cone patterns'**
  String get dribblingDescription;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @passingDrill.
  ///
  /// In en, this message translates to:
  /// **'Passing Drill'**
  String get passingDrill;

  /// No description provided for @passingDescription.
  ///
  /// In en, this message translates to:
  /// **'Improve accuracy with partner passing exercises'**
  String get passingDescription;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @shootingDrill.
  ///
  /// In en, this message translates to:
  /// **'Shooting Drill'**
  String get shootingDrill;

  /// No description provided for @shootingDescription.
  ///
  /// In en, this message translates to:
  /// **'Work on finishing from various positions and angles'**
  String get shootingDescription;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @smallSidedGame.
  ///
  /// In en, this message translates to:
  /// **'Small-Sided Game'**
  String get smallSidedGame;

  /// No description provided for @smallSidedDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice match situations in reduced spaces'**
  String get smallSidedDescription;

  /// No description provided for @weeklyPlan.
  ///
  /// In en, this message translates to:
  /// **'Weekly Plan'**
  String get weeklyPlan;

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week {week} of {total}'**
  String weekOf(Object total, Object week);

  /// No description provided for @sessionsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} of 7 sessions completed'**
  String sessionsCompleted(Object completed);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @exerciseCategories.
  ///
  /// In en, this message translates to:
  /// **'Exercise Categories'**
  String get exerciseCategories;

  /// No description provided for @chooseCategoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a category to start training'**
  String get chooseCategoryDescription;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No Categories Yet'**
  String get noCategoriesYet;

  /// No description provided for @exerciseCategoriesWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Exercise categories will appear here.'**
  String get exerciseCategoriesWillAppear;

  /// No description provided for @exercisesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String exercisesCount(Object count);

  /// No description provided for @selectExerciseToBegin.
  ///
  /// In en, this message translates to:
  /// **'Select an exercise to begin'**
  String get selectExerciseToBegin;

  /// No description provided for @noExercises.
  ///
  /// In en, this message translates to:
  /// **'No Exercises'**
  String get noExercises;

  /// No description provided for @stepsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String stepsCount(Object count);

  /// No description provided for @stepComplete.
  ///
  /// In en, this message translates to:
  /// **'Step Complete!'**
  String get stepComplete;

  /// No description provided for @noPersonDetected.
  ///
  /// In en, this message translates to:
  /// **'No person detected'**
  String get noPersonDetected;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @autoAdvancing.
  ///
  /// In en, this message translates to:
  /// **'Auto-advancing...'**
  String get autoAdvancing;

  /// No description provided for @matchReferencePose.
  ///
  /// In en, this message translates to:
  /// **'Match the reference pose...'**
  String get matchReferencePose;

  /// No description provided for @stepCompleted.
  ///
  /// In en, this message translates to:
  /// **'Step Completed!'**
  String get stepCompleted;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Required'**
  String get cameraPermissionRequired;

  /// No description provided for @cameraPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'This feature needs camera access to detect your pose.'**
  String get cameraPermissionDescription;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @exerciseCompleted.
  ///
  /// In en, this message translates to:
  /// **'Exercise Completed!'**
  String get exerciseCompleted;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @practiceAgain.
  ///
  /// In en, this message translates to:
  /// **'Practice Again'**
  String get practiceAgain;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @stepResults.
  ///
  /// In en, this message translates to:
  /// **'Step Results'**
  String get stepResults;

  /// No description provided for @exerciseStepPoses.
  ///
  /// In en, this message translates to:
  /// **'Exercise Step Poses'**
  String get exerciseStepPoses;

  /// No description provided for @followStepByStepGuides.
  ///
  /// In en, this message translates to:
  /// **'Follow step-by-step pose guides for your exercises.'**
  String get followStepByStepGuides;

  /// No description provided for @noPosesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Poses Available'**
  String get noPosesAvailable;

  /// No description provided for @exerciseStepPosesWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Exercise step poses will appear here once added.'**
  String get exerciseStepPosesWillAppear;

  /// No description provided for @failedToLoadPoses.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Poses'**
  String get failedToLoadPoses;

  /// No description provided for @stepByStep.
  ///
  /// In en, this message translates to:
  /// **'Step by Step'**
  String get stepByStep;

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

  /// No description provided for @noStepsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Steps Available'**
  String get noStepsAvailable;

  /// No description provided for @stepImagesWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Step images will appear here once added.'**
  String get stepImagesWillAppear;

  /// No description provided for @failedToLoadSteps.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Steps'**
  String get failedToLoadSteps;

  /// No description provided for @stepNumber.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String stepNumber(Object number);

  /// No description provided for @autoAdvancingIn5s.
  ///
  /// In en, this message translates to:
  /// **'Auto-advancing in 5s...'**
  String get autoAdvancingIn5s;

  /// No description provided for @matchPoseToCompleteStep.
  ///
  /// In en, this message translates to:
  /// **'Match the pose to complete step...'**
  String get matchPoseToCompleteStep;

  /// No description provided for @matchPoseToContinue.
  ///
  /// In en, this message translates to:
  /// **'Match the pose to continue...'**
  String get matchPoseToContinue;

  /// No description provided for @imageCompleteNextIn5s.
  ///
  /// In en, this message translates to:
  /// **'Image Complete! Next in 5s...'**
  String get imageCompleteNextIn5s;

  /// No description provided for @allStepsComplete.
  ///
  /// In en, this message translates to:
  /// **'All Steps Complete!'**
  String get allStepsComplete;

  /// No description provided for @analyzingPose.
  ///
  /// In en, this message translates to:
  /// **'Analyzing pose...'**
  String get analyzingPose;

  /// No description provided for @cameraPermissionDescriptionPose.
  ///
  /// In en, this message translates to:
  /// **'This feature needs camera access to detect your pose and compare with the reference.'**
  String get cameraPermissionDescriptionPose;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open App Settings'**
  String get openAppSettings;

  /// No description provided for @allStepsCompleteDescription.
  ///
  /// In en, this message translates to:
  /// **'You completed all {steps} steps ({images} images).'**
  String allStepsCompleteDescription(Object images, Object steps);

  /// No description provided for @stepBackToShowFullBody.
  ///
  /// In en, this message translates to:
  /// **'Step back to show full body'**
  String get stepBackToShowFullBody;

  /// No description provided for @excellentAlignment.
  ///
  /// In en, this message translates to:
  /// **'Excellent alignment!'**
  String get excellentAlignment;

  /// No description provided for @matchTheReferencePose.
  ///
  /// In en, this message translates to:
  /// **'Match the reference pose'**
  String get matchTheReferencePose;

  /// No description provided for @noReferenceAngles.
  ///
  /// In en, this message translates to:
  /// **'No reference angles'**
  String get noReferenceAngles;

  /// No description provided for @noMatchingAngles.
  ///
  /// In en, this message translates to:
  /// **'No matching angles'**
  String get noMatchingAngles;

  /// No description provided for @notEnoughBodyVisible.
  ///
  /// In en, this message translates to:
  /// **'Not enough body visible'**
  String get notEnoughBodyVisible;

  /// No description provided for @excellentForm.
  ///
  /// In en, this message translates to:
  /// **'Excellent form!'**
  String get excellentForm;

  /// No description provided for @goodAdjustSlightly.
  ///
  /// In en, this message translates to:
  /// **'Good, adjust slightly'**
  String get goodAdjustSlightly;

  /// No description provided for @keepAdjustingPose.
  ///
  /// In en, this message translates to:
  /// **'Keep adjusting your pose'**
  String get keepAdjustingPose;

  /// No description provided for @trainingPlans.
  ///
  /// In en, this message translates to:
  /// **'Training Plans'**
  String get trainingPlans;

  /// No description provided for @weeksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks'**
  String weeksCount(Object count);

  /// No description provided for @poseDetection.
  ///
  /// In en, this message translates to:
  /// **'Pose Detection'**
  String get poseDetection;

  /// No description provided for @squat.
  ///
  /// In en, this message translates to:
  /// **'Squat'**
  String get squat;

  /// No description provided for @detecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting...'**
  String get detecting;

  /// No description provided for @startDetection.
  ///
  /// In en, this message translates to:
  /// **'Start Detection'**
  String get startDetection;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @trainingMethods.
  ///
  /// In en, this message translates to:
  /// **'Training Methods'**
  String get trainingMethods;

  /// No description provided for @injuryPreventionLabel.
  ///
  /// In en, this message translates to:
  /// **'Injury Prevention'**
  String get injuryPreventionLabel;

  /// No description provided for @fitnessRequirements.
  ///
  /// In en, this message translates to:
  /// **'Fitness Requirements'**
  String get fitnessRequirements;

  /// No description provided for @prevention.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get prevention;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @noPreventionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Prevention Available'**
  String get noPreventionAvailable;

  /// No description provided for @noTreatmentAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Treatment Available'**
  String get noTreatmentAvailable;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @myWorkouts.
  ///
  /// In en, this message translates to:
  /// **'My Workouts'**
  String get myWorkouts;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailOptional;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @bioOptional.
  ///
  /// In en, this message translates to:
  /// **'Bio (optional)'**
  String get bioOptional;

  /// No description provided for @profileImageUrlOptional.
  ///
  /// In en, this message translates to:
  /// **'Profile Image URL (optional)'**
  String get profileImageUrlOptional;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated. Verification email may be sent for email change.'**
  String get profileUpdated;

  /// No description provided for @intermediateLevel.
  ///
  /// In en, this message translates to:
  /// **'Intermediate Level'**
  String get intermediateLevel;

  /// No description provided for @fitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get fitness;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @poseAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Pose Analysis'**
  String get poseAnalysisTitle;

  /// No description provided for @analysisLabel.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysisLabel;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @accuracyValue.
  ///
  /// In en, this message translates to:
  /// **'Accuracy: {value}%'**
  String accuracyValue(Object value);

  /// No description provided for @repsValue.
  ///
  /// In en, this message translates to:
  /// **'Reps: {count}'**
  String repsValue(Object count);

  /// No description provided for @fitnessAssessment.
  ///
  /// In en, this message translates to:
  /// **'Fitness Assessment'**
  String get fitnessAssessment;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @tellUsAboutYourBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your body'**
  String get tellUsAboutYourBody;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @enterValidAge.
  ///
  /// In en, this message translates to:
  /// **'Enter valid age'**
  String get enterValidAge;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @enterValidHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter valid height'**
  String get enterValidHeight;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @enterValidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter valid weight'**
  String get enterValidWeight;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityLevel;

  /// No description provided for @howActiveAreYou.
  ///
  /// In en, this message translates to:
  /// **'How active are you?'**
  String get howActiveAreYou;

  /// No description provided for @exerciseFrequencyQuestion.
  ///
  /// In en, this message translates to:
  /// **'How often do you exercise per week?'**
  String get exerciseFrequencyQuestion;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @dailyActivityQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your daily activity level?'**
  String get dailyActivityQuestion;

  /// No description provided for @sedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get sedentary;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @completeAssessment.
  ///
  /// In en, this message translates to:
  /// **'Complete Assessment'**
  String get completeAssessment;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save:'**
  String get failedToSave;

  /// No description provided for @fitnessScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Fitness Score'**
  String get fitnessScoreLabel;

  /// No description provided for @notAssessed.
  ///
  /// In en, this message translates to:
  /// **'Not Assessed'**
  String get notAssessed;

  /// No description provided for @completeAssessmentToSee.
  ///
  /// In en, this message translates to:
  /// **'Complete fitness assessment to see your score'**
  String get completeAssessmentToSee;

  /// No description provided for @editFitnessInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Fitness Info'**
  String get editFitnessInfo;

  /// No description provided for @maxLevelReached.
  ///
  /// In en, this message translates to:
  /// **'Max level reached'**
  String get maxLevelReached;

  /// No description provided for @exercisesCompleted.
  ///
  /// In en, this message translates to:
  /// **'exercises completed'**
  String get exercisesCompleted;

  /// No description provided for @moreToIntermediate.
  ///
  /// In en, this message translates to:
  /// **'more to Intermediate'**
  String get moreToIntermediate;

  /// No description provided for @moreToAdvanced.
  ///
  /// In en, this message translates to:
  /// **'more to Advanced'**
  String get moreToAdvanced;

  /// No description provided for @beginnerLevel.
  ///
  /// In en, this message translates to:
  /// **'Beginner Level'**
  String get beginnerLevel;

  /// No description provided for @intermediateLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Intermediate Level'**
  String get intermediateLevelLabel;

  /// No description provided for @advancedLevel.
  ///
  /// In en, this message translates to:
  /// **'Advanced Level'**
  String get advancedLevel;

  /// No description provided for @noCompletedExercises.
  ///
  /// In en, this message translates to:
  /// **'No Completed Exercises'**
  String get noCompletedExercises;

  /// No description provided for @completeExercisesToSee.
  ///
  /// In en, this message translates to:
  /// **'Complete exercises to see your progress here.'**
  String get completeExercisesToSee;

  /// No description provided for @yourGoals.
  ///
  /// In en, this message translates to:
  /// **'Your Goals ({count})'**
  String yourGoals(Object count);

  /// No description provided for @performanceFeedback.
  ///
  /// In en, this message translates to:
  /// **'Performance Feedback'**
  String get performanceFeedback;

  /// No description provided for @strengthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get strengthsLabel;

  /// No description provided for @needsPractice.
  ///
  /// In en, this message translates to:
  /// **'Needs Practice'**
  String get needsPractice;

  /// No description provided for @recommendedNext.
  ///
  /// In en, this message translates to:
  /// **'Recommended Next'**
  String get recommendedNext;

  /// No description provided for @practiceTheseExercises.
  ///
  /// In en, this message translates to:
  /// **'Practice these exercises'**
  String get practiceTheseExercises;

  /// No description provided for @exerciseCompletions.
  ///
  /// In en, this message translates to:
  /// **'Exercise Completions'**
  String get exerciseCompletions;

  /// No description provided for @photoSelected.
  ///
  /// In en, this message translates to:
  /// **'Photo selected'**
  String get photoSelected;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed'**
  String get imageUploadFailed;

  /// No description provided for @searchSportsHint.
  ///
  /// In en, this message translates to:
  /// **'Search sports...'**
  String get searchSportsHint;

  /// No description provided for @searchPosesHint.
  ///
  /// In en, this message translates to:
  /// **'Search poses...'**
  String get searchPosesHint;

  /// No description provided for @searchInjuryHint.
  ///
  /// In en, this message translates to:
  /// **'Search prevention & treatment...'**
  String get searchInjuryHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No Results'**
  String get noResults;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @yourTrainingFocus.
  ///
  /// In en, this message translates to:
  /// **'Your Training Focus'**
  String get yourTrainingFocus;

  /// No description provided for @trainingForType.
  ///
  /// In en, this message translates to:
  /// **'You\'re training for {type}!'**
  String trainingForType(Object type);

  /// No description provided for @practiceRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Practice {type} poses at least {count} times a week to improve your skills.'**
  String practiceRecommendation(Object count, Object type);

  /// No description provided for @keepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing to see better results!'**
  String get keepPracticing;

  /// No description provided for @weightLossTip.
  ///
  /// In en, this message translates to:
  /// **'Combine regular exercise with a balanced diet for effective weight loss.'**
  String get weightLossTip;

  /// No description provided for @weightGainTip.
  ///
  /// In en, this message translates to:
  /// **'Focus on strength training and protein-rich nutrition for healthy weight gain.'**
  String get weightGainTip;

  /// No description provided for @sportTipFootball.
  ///
  /// In en, this message translates to:
  /// **'Focus on agility drills, sprint intervals, and ball control exercises.'**
  String get sportTipFootball;

  /// No description provided for @sportTipBasketball.
  ///
  /// In en, this message translates to:
  /// **'Work on jump shots, defensive slides, and passing accuracy.'**
  String get sportTipBasketball;

  /// No description provided for @sportTipVolleyball.
  ///
  /// In en, this message translates to:
  /// **'Practice serving precision, spike timing, and court positioning.'**
  String get sportTipVolleyball;

  /// No description provided for @sportTipBadminton.
  ///
  /// In en, this message translates to:
  /// **'Improve footwork, racket swings, and net play techniques.'**
  String get sportTipBadminton;

  /// No description provided for @sportTipYoga.
  ///
  /// In en, this message translates to:
  /// **'Hold poses longer, focus on breathing, and improve flexibility gradually.'**
  String get sportTipYoga;

  /// No description provided for @sportTipStretching.
  ///
  /// In en, this message translates to:
  /// **'Increase stretch duration gradually and maintain consistent daily practice.'**
  String get sportTipStretching;
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
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
