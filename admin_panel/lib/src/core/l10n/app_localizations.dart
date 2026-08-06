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

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @aiSportsTraining.
  ///
  /// In en, this message translates to:
  /// **'AI Sports Training'**
  String get aiSportsTraining;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @sportsManagement.
  ///
  /// In en, this message translates to:
  /// **'Sports Management'**
  String get sportsManagement;

  /// No description provided for @exerciseStepImages.
  ///
  /// In en, this message translates to:
  /// **'Exercise Step Images'**
  String get exerciseStepImages;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @areYouSureSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSureSignOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

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

  /// No description provided for @signInToManage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your sports training data'**
  String get signInToManage;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @manageAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your admin account'**
  String get manageAdminAccount;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @profilePhotoUrl.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo URL (optional)'**
  String get profilePhotoUrl;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(Object error);

  /// No description provided for @overviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Overview of your sports training platform'**
  String get overviewDescription;

  /// No description provided for @errorLoadingStats.
  ///
  /// In en, this message translates to:
  /// **'Error loading stats: {error}'**
  String errorLoadingStats(Object error);

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @totalSports.
  ///
  /// In en, this message translates to:
  /// **'Total Sports'**
  String get totalSports;

  /// No description provided for @trainingPoses.
  ///
  /// In en, this message translates to:
  /// **'Training Poses'**
  String get trainingPoses;

  /// No description provided for @exerciseStepPoses.
  ///
  /// In en, this message translates to:
  /// **'Exercise Step Poses'**
  String get exerciseStepPoses;

  /// No description provided for @registeredUsers.
  ///
  /// In en, this message translates to:
  /// **'Registered Users'**
  String get registeredUsers;

  /// No description provided for @addNewSport.
  ///
  /// In en, this message translates to:
  /// **'Add New Sport'**
  String get addNewSport;

  /// No description provided for @createNewSportEntry.
  ///
  /// In en, this message translates to:
  /// **'Create a new sport entry'**
  String get createNewSportEntry;

  /// No description provided for @manageSports.
  ///
  /// In en, this message translates to:
  /// **'Manage Sports'**
  String get manageSports;

  /// No description provided for @viewAndEditAllSports.
  ///
  /// In en, this message translates to:
  /// **'View and edit all sports'**
  String get viewAndEditAllSports;

  /// No description provided for @manageStepImagePosts.
  ///
  /// In en, this message translates to:
  /// **'Manage step image posts'**
  String get manageStepImagePosts;

  /// No description provided for @createStepImage.
  ///
  /// In en, this message translates to:
  /// **'Create Step Image'**
  String get createStepImage;

  /// No description provided for @addNewExerciseStepImages.
  ///
  /// In en, this message translates to:
  /// **'Add new exercise step images'**
  String get addNewExerciseStepImages;

  /// No description provided for @sportsManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage all sports and their training data'**
  String get sportsManagementDescription;

  /// No description provided for @addSport.
  ///
  /// In en, this message translates to:
  /// **'Add Sport'**
  String get addSport;

  /// No description provided for @noSportsYet.
  ///
  /// In en, this message translates to:
  /// **'No Sports Yet'**
  String get noSportsYet;

  /// No description provided for @addFirstSport.
  ///
  /// In en, this message translates to:
  /// **'Add your first sport to get started'**
  String get addFirstSport;

  /// No description provided for @sport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get sport;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @manageDetails.
  ///
  /// In en, this message translates to:
  /// **'Manage Details'**
  String get manageDetails;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteSport.
  ///
  /// In en, this message translates to:
  /// **'Delete Sport'**
  String get deleteSport;

  /// No description provided for @areYouSureDeleteSport.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String areYouSureDeleteSport(Object name);

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted successfully'**
  String deletedSuccessfully(Object name);

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

  /// No description provided for @requiresAtLeastOneItem.
  ///
  /// In en, this message translates to:
  /// **'{type} requires at least one item.'**
  String requiresAtLeastOneItem(Object type);

  /// No description provided for @itemTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'{type} - Item {index}: Title is required.'**
  String itemTitleRequired(Object index, Object type);

  /// No description provided for @itemDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'{type} - Item {index}: Description is required.'**
  String itemDescriptionRequired(Object index, Object type);

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(Object error);

  /// No description provided for @editSport.
  ///
  /// In en, this message translates to:
  /// **'Edit Sport'**
  String get editSport;

  /// No description provided for @addNewSportTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Sport'**
  String get addNewSportTitle;

  /// No description provided for @sportInformation.
  ///
  /// In en, this message translates to:
  /// **'Sport Information'**
  String get sportInformation;

  /// No description provided for @sportName.
  ///
  /// In en, this message translates to:
  /// **'Sport Name'**
  String get sportName;

  /// No description provided for @sportNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Sport name is required'**
  String get sportNameRequired;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @difficultyLevel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty Level'**
  String get difficultyLevel;

  /// No description provided for @updateSport.
  ///
  /// In en, this message translates to:
  /// **'Update Sport'**
  String get updateSport;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @atLeastOneRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one {type} is required.'**
  String atLeastOneRequired(Object type);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} item{plural}'**
  String itemCount(Object count, Object plural);

  /// No description provided for @addType.
  ///
  /// In en, this message translates to:
  /// **'Add {type}'**
  String addType(Object type);

  /// No description provided for @typeNumber.
  ///
  /// In en, this message translates to:
  /// **'{type} {number}'**
  String typeNumber(Object number, Object type);

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required.'**
  String get titleRequired;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required.'**
  String get descriptionIsRequired;

  /// No description provided for @manageSportDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage sport details across all categories'**
  String get manageSportDetailsDescription;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noTypeYet.
  ///
  /// In en, this message translates to:
  /// **'No {type} Yet'**
  String noTypeYet(Object type);

  /// No description provided for @addFirstItem.
  ///
  /// In en, this message translates to:
  /// **'Add your first {type} to get started'**
  String addFirstItem(Object type);

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get createdDate;

  /// No description provided for @deleteType.
  ///
  /// In en, this message translates to:
  /// **'Delete {type}'**
  String deleteType(Object type);

  /// No description provided for @areYouSureDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String areYouSureDeleteItem(Object title);

  /// No description provided for @typeDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{type} deleted successfully'**
  String typeDeletedSuccessfully(Object type);

  /// No description provided for @sportIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Sport is required.'**
  String get sportIsRequired;

  /// No description provided for @editType.
  ///
  /// In en, this message translates to:
  /// **'Edit {type}'**
  String editType(Object type);

  /// No description provided for @addTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {type}'**
  String addTypeTitle(Object type);

  /// No description provided for @sportNameDisplay.
  ///
  /// In en, this message translates to:
  /// **'Sport: {name}'**
  String sportNameDisplay(Object name);

  /// No description provided for @typeInformation.
  ///
  /// In en, this message translates to:
  /// **'{type} Information'**
  String typeInformation(Object type);

  /// No description provided for @typeUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{type} updated successfully'**
  String typeUpdatedSuccessfully(Object type);

  /// No description provided for @typeAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{type} added successfully'**
  String typeAddedSuccessfully(Object type);

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @updateType.
  ///
  /// In en, this message translates to:
  /// **'Update {type}'**
  String updateType(Object type);

  /// No description provided for @exerciseStepImagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage exercise step image posts'**
  String get exerciseStepImagesDescription;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No Posts Yet'**
  String get noPostsYet;

  /// No description provided for @createFirstPost.
  ///
  /// In en, this message translates to:
  /// **'Create your first exercise step image post'**
  String get createFirstPost;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @imageCount.
  ///
  /// In en, this message translates to:
  /// **'{count} image{plural}'**
  String imageCount(Object count, Object plural);

  /// No description provided for @viewEdit.
  ///
  /// In en, this message translates to:
  /// **'View / Edit'**
  String get viewEdit;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deletePost;

  /// No description provided for @areYouSureDeletePost.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\" ({type}) with {count} image(s)? This cannot be undone.'**
  String areYouSureDeletePost(Object count, Object title, Object type);

  /// No description provided for @postDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get postDeletedSuccessfully;

  /// No description provided for @errorPickingImageAdmin.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImageAdmin(Object error);

  /// No description provided for @imageMustContainFullBody.
  ///
  /// In en, this message translates to:
  /// **'Image must contain a full body with visible landmarks. Please upload a clearer full-body reference pose image.'**
  String get imageMustContainFullBody;

  /// No description provided for @failedToProcessPose.
  ///
  /// In en, this message translates to:
  /// **'Failed to process pose: {error}'**
  String failedToProcessPose(Object error);

  /// No description provided for @typeIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Type is required.'**
  String get typeIsRequired;

  /// No description provided for @titleIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required.'**
  String get titleIsRequired;

  /// No description provided for @itemDescriptionRequiredAdmin.
  ///
  /// In en, this message translates to:
  /// **'Item {index}: Description is required.'**
  String itemDescriptionRequiredAdmin(Object index);

  /// No description provided for @itemImageRequiredAdmin.
  ///
  /// In en, this message translates to:
  /// **'Item {index}: Image is required.'**
  String itemImageRequiredAdmin(Object index);

  /// No description provided for @poseDetectionIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Pose Detection Incomplete'**
  String get poseDetectionIncomplete;

  /// No description provided for @failedImagesMessage.
  ///
  /// In en, this message translates to:
  /// **'{failed} image(s) failed pose detection. '**
  String failedImagesMessage(Object failed);

  /// No description provided for @pendingImagesMessage.
  ///
  /// In en, this message translates to:
  /// **'{pending} image(s) still processing.'**
  String pendingImagesMessage(Object pending);

  /// No description provided for @savedWithoutPoseData.
  ///
  /// In en, this message translates to:
  /// **'\n\nImages will be saved without pose data. You can re-upload later to add pose detection.'**
  String get savedWithoutPoseData;

  /// No description provided for @saveAnyway.
  ///
  /// In en, this message translates to:
  /// **'Save Anyway'**
  String get saveAnyway;

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get editPost;

  /// No description provided for @addExerciseStepImagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add exercise step images with pose detection'**
  String get addExerciseStepImagesDescription;

  /// No description provided for @customTypeName.
  ///
  /// In en, this message translates to:
  /// **'Custom Type Name'**
  String get customTypeName;

  /// No description provided for @customTypeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Custom type name is required.'**
  String get customTypeNameRequired;

  /// No description provided for @postTitle.
  ///
  /// In en, this message translates to:
  /// **'Post Title'**
  String get postTitle;

  /// No description provided for @updatePost.
  ///
  /// In en, this message translates to:
  /// **'Update Post'**
  String get updatePost;

  /// No description provided for @postType.
  ///
  /// In en, this message translates to:
  /// **'Post Type'**
  String get postType;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select a type'**
  String get selectType;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @imagesDescriptions.
  ///
  /// In en, this message translates to:
  /// **'Images & Descriptions'**
  String get imagesDescriptions;

  /// No description provided for @imageStepCount.
  ///
  /// In en, this message translates to:
  /// **'{images} image{imagePlural} · {steps} step{stepPlural}'**
  String imageStepCount(
      Object imagePlural, Object images, Object stepPlural, Object steps);

  /// No description provided for @assignImageDescription.
  ///
  /// In en, this message translates to:
  /// **'* Assign each image to a Step. Images in the same step are practiced together. During practice: matching first image auto-advances to next within the step. Last image in step shows success button to proceed.'**
  String get assignImageDescription;

  /// No description provided for @noItemsTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'No items. Tap \"Add Image\" below to add one.'**
  String get noItemsTapToAdd;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @addNewStep.
  ///
  /// In en, this message translates to:
  /// **'Add New Step'**
  String get addNewStep;

  /// No description provided for @imageNumber.
  ///
  /// In en, this message translates to:
  /// **'Image {number}'**
  String imageNumber(Object number);

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @poseDetected.
  ///
  /// In en, this message translates to:
  /// **'Pose Detected'**
  String get poseDetected;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @extractedPoseData.
  ///
  /// In en, this message translates to:
  /// **'Extracted Pose Data'**
  String get extractedPoseData;

  /// No description provided for @detectingPose.
  ///
  /// In en, this message translates to:
  /// **'Detecting pose...'**
  String get detectingPose;

  /// No description provided for @tapToSelectPoseImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a full-body pose image'**
  String get tapToSelectPoseImage;

  /// No description provided for @mlKitWillDetect.
  ///
  /// In en, this message translates to:
  /// **'ML Kit will detect body landmarks automatically'**
  String get mlKitWillDetect;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @manageRegisteredUsers.
  ///
  /// In en, this message translates to:
  /// **'Manage registered users'**
  String get manageRegisteredUsers;

  /// No description provided for @searchByNameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email...'**
  String get searchByNameOrEmail;

  /// No description provided for @noUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No Users Yet'**
  String get noUsersYet;

  /// No description provided for @noUsersRegistered.
  ///
  /// In en, this message translates to:
  /// **'No users have registered yet'**
  String get noUsersRegistered;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No Results'**
  String get noResults;

  /// No description provided for @noUsersMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No users match your search'**
  String get noUsersMatchSearch;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @areYouSureDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This cannot be undone.'**
  String areYouSureDeleteUser(Object name);

  /// No description provided for @userDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeletedSuccessfully;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @userUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdatedSuccessfully;

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

  /// No description provided for @injuryPrevention.
  ///
  /// In en, this message translates to:
  /// **'Injury Prevention'**
  String get injuryPrevention;

  /// No description provided for @fitnessRequirements.
  ///
  /// In en, this message translates to:
  /// **'Fitness Requirements'**
  String get fitnessRequirements;

  /// No description provided for @rule.
  ///
  /// In en, this message translates to:
  /// **'Rule'**
  String get rule;

  /// No description provided for @trainingMethod.
  ///
  /// In en, this message translates to:
  /// **'Training Method'**
  String get trainingMethod;

  /// No description provided for @injuryPreventionSingular.
  ///
  /// In en, this message translates to:
  /// **'Injury Prevention'**
  String get injuryPreventionSingular;

  /// No description provided for @fitnessRequirement.
  ///
  /// In en, this message translates to:
  /// **'Fitness Requirement'**
  String get fitnessRequirement;

  /// No description provided for @injuryPreventionAndTreatment.
  ///
  /// In en, this message translates to:
  /// **'Injury Prevention & Treatment'**
  String get injuryPreventionAndTreatment;

  /// No description provided for @manageInjuryDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage injury prevention tips and treatment guidelines'**
  String get manageInjuryDataDescription;

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
