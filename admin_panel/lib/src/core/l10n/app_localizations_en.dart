// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get aiSportsTraining => 'AI Sports Training';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get sportsManagement => 'Sports Management';

  @override
  String get exerciseStepImages => 'Exercise Step Images';

  @override
  String get users => 'Users';

  @override
  String get admin => 'Admin';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get areYouSureSignOut => 'Are you sure you want to sign out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get enterValidEmail => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get signInToManage => 'Sign in to manage your sports training data';

  @override
  String get signIn => 'Sign In';

  @override
  String get myProfile => 'My Profile';

  @override
  String get manageAdminAccount => 'Manage your admin account';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get displayName => 'Display Name';

  @override
  String get profilePhotoUrl => 'Profile Photo URL (optional)';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get overviewDescription => 'Overview of your sports training platform';

  @override
  String errorLoadingStats(Object error) {
    return 'Error loading stats: $error';
  }

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get totalSports => 'Total Sports';

  @override
  String get trainingPoses => 'Training Poses';

  @override
  String get exerciseStepPoses => 'Exercise Step Poses';

  @override
  String get registeredUsers => 'Registered Users';

  @override
  String get addNewSport => 'Add New Sport';

  @override
  String get createNewSportEntry => 'Create a new sport entry';

  @override
  String get manageSports => 'Manage Sports';

  @override
  String get viewAndEditAllSports => 'View and edit all sports';

  @override
  String get manageStepImagePosts => 'Manage step image posts';

  @override
  String get createStepImage => 'Create Step Image';

  @override
  String get addNewExerciseStepImages => 'Add new exercise step images';

  @override
  String get sportsManagementDescription =>
      'Manage all sports and their training data';

  @override
  String get addSport => 'Add Sport';

  @override
  String get noSportsYet => 'No Sports Yet';

  @override
  String get addFirstSport => 'Add your first sport to get started';

  @override
  String get sport => 'Sport';

  @override
  String get description => 'Description';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get created => 'Created';

  @override
  String get actions => 'Actions';

  @override
  String get manageDetails => 'Manage Details';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteSport => 'Delete Sport';

  @override
  String areYouSureDeleteSport(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String deletedSuccessfully(Object name) {
    return '$name deleted successfully';
  }

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String requiresAtLeastOneItem(Object type) {
    return '$type requires at least one item.';
  }

  @override
  String itemTitleRequired(Object index, Object type) {
    return '$type - Item $index: Title is required.';
  }

  @override
  String itemDescriptionRequired(Object index, Object type) {
    return '$type - Item $index: Description is required.';
  }

  @override
  String errorPickingImage(Object error) {
    return 'Error picking image: $error';
  }

  @override
  String get editSport => 'Edit Sport';

  @override
  String get addNewSportTitle => 'Add New Sport';

  @override
  String get sportInformation => 'Sport Information';

  @override
  String get sportName => 'Sport Name';

  @override
  String get sportNameRequired => 'Sport name is required';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get difficultyLevel => 'Difficulty Level';

  @override
  String get updateSport => 'Update Sport';

  @override
  String get photo => 'Photo';

  @override
  String get remove => 'Remove';

  @override
  String get changeImage => 'Change Image';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String atLeastOneRequired(Object type) {
    return 'At least one $type is required.';
  }

  @override
  String itemCount(Object count, Object plural) {
    return '$count item$plural';
  }

  @override
  String addType(Object type) {
    return 'Add $type';
  }

  @override
  String typeNumber(Object number, Object type) {
    return '$type $number';
  }

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Title is required.';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionIsRequired => 'Description is required.';

  @override
  String get manageSportDetailsDescription =>
      'Manage sport details across all categories';

  @override
  String get search => 'Search...';

  @override
  String get add => 'Add';

  @override
  String noTypeYet(Object type) {
    return 'No $type Yet';
  }

  @override
  String addFirstItem(Object type) {
    return 'Add your first $type to get started';
  }

  @override
  String get createdDate => 'Created Date';

  @override
  String deleteType(Object type) {
    return 'Delete $type';
  }

  @override
  String areYouSureDeleteItem(Object title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String typeDeletedSuccessfully(Object type) {
    return '$type deleted successfully';
  }

  @override
  String get sportIsRequired => 'Sport is required.';

  @override
  String editType(Object type) {
    return 'Edit $type';
  }

  @override
  String addTypeTitle(Object type) {
    return 'Add $type';
  }

  @override
  String sportNameDisplay(Object name) {
    return 'Sport: $name';
  }

  @override
  String typeInformation(Object type) {
    return '$type Information';
  }

  @override
  String typeUpdatedSuccessfully(Object type) {
    return '$type updated successfully';
  }

  @override
  String typeAddedSuccessfully(Object type) {
    return '$type added successfully';
  }

  @override
  String get category => 'Category';

  @override
  String updateType(Object type) {
    return 'Update $type';
  }

  @override
  String get exerciseStepImagesDescription =>
      'Manage exercise step image posts';

  @override
  String get createPost => 'Create Post';

  @override
  String get noPostsYet => 'No Posts Yet';

  @override
  String get createFirstPost => 'Create your first exercise step image post';

  @override
  String get type => 'Type';

  @override
  String get items => 'Items';

  @override
  String imageCount(Object count, Object plural) {
    return '$count image$plural';
  }

  @override
  String get viewEdit => 'View / Edit';

  @override
  String get deletePost => 'Delete Post';

  @override
  String areYouSureDeletePost(Object count, Object title, Object type) {
    return 'Are you sure you want to delete \"$title\" ($type) with $count image(s)? This cannot be undone.';
  }

  @override
  String get postDeletedSuccessfully => 'Post deleted successfully';

  @override
  String errorPickingImageAdmin(Object error) {
    return 'Error picking image: $error';
  }

  @override
  String get imageMustContainFullBody =>
      'Image must contain a full body with visible landmarks. Please upload a clearer full-body reference pose image.';

  @override
  String failedToProcessPose(Object error) {
    return 'Failed to process pose: $error';
  }

  @override
  String get typeIsRequired => 'Type is required.';

  @override
  String get titleIsRequired => 'Title is required.';

  @override
  String itemDescriptionRequiredAdmin(Object index) {
    return 'Item $index: Description is required.';
  }

  @override
  String itemImageRequiredAdmin(Object index) {
    return 'Item $index: Image is required.';
  }

  @override
  String get poseDetectionIncomplete => 'Pose Detection Incomplete';

  @override
  String failedImagesMessage(Object failed) {
    return '$failed image(s) failed pose detection. ';
  }

  @override
  String pendingImagesMessage(Object pending) {
    return '$pending image(s) still processing.';
  }

  @override
  String get savedWithoutPoseData =>
      '\n\nImages will be saved without pose data. You can re-upload later to add pose detection.';

  @override
  String get saveAnyway => 'Save Anyway';

  @override
  String get editPost => 'Edit Post';

  @override
  String get addExerciseStepImagesDescription =>
      'Add exercise step images with pose detection';

  @override
  String get customTypeName => 'Custom Type Name';

  @override
  String get customTypeNameRequired => 'Custom type name is required.';

  @override
  String get postTitle => 'Post Title';

  @override
  String get updatePost => 'Update Post';

  @override
  String get postType => 'Post Type';

  @override
  String get selectType => 'Select a type';

  @override
  String get others => 'Others';

  @override
  String get imagesDescriptions => 'Images & Descriptions';

  @override
  String imageStepCount(
      Object imagePlural, Object images, Object stepPlural, Object steps) {
    return '$images image$imagePlural · $steps step$stepPlural';
  }

  @override
  String get assignImageDescription =>
      '* Assign each image to a Step. Images in the same step are practiced together. During practice: matching first image auto-advances to next within the step. Last image in step shows success button to proceed.';

  @override
  String get noItemsTapToAdd => 'No items. Tap \"Add Image\" below to add one.';

  @override
  String get addImage => 'Add Image';

  @override
  String get addNewStep => 'Add New Step';

  @override
  String imageNumber(Object number) {
    return 'Image $number';
  }

  @override
  String get step => 'Step';

  @override
  String get selectImage => 'Select Image';

  @override
  String get processing => 'Processing...';

  @override
  String get poseDetected => 'Pose Detected';

  @override
  String get failed => 'Failed';

  @override
  String get extractedPoseData => 'Extracted Pose Data';

  @override
  String get detectingPose => 'Detecting pose...';

  @override
  String get tapToSelectPoseImage => 'Tap to select a full-body pose image';

  @override
  String get mlKitWillDetect =>
      'ML Kit will detect body landmarks automatically';

  @override
  String get userManagement => 'User Management';

  @override
  String get manageRegisteredUsers => 'Manage registered users';

  @override
  String get searchByNameOrEmail => 'Search by name or email...';

  @override
  String get noUsersYet => 'No Users Yet';

  @override
  String get noUsersRegistered => 'No users have registered yet';

  @override
  String get noResults => 'No Results';

  @override
  String get noUsersMatchSearch => 'No users match your search';

  @override
  String get user => 'User';

  @override
  String get phone => 'Phone';

  @override
  String get joined => 'Joined';

  @override
  String get unknown => 'Unknown';

  @override
  String get deleteUser => 'Delete User';

  @override
  String areYouSureDeleteUser(Object name) {
    return 'Are you sure you want to delete \"$name\"? This cannot be undone.';
  }

  @override
  String get userDeletedSuccessfully => 'User deleted successfully';

  @override
  String get fullName => 'Full Name';

  @override
  String get bio => 'Bio';

  @override
  String get save => 'Save';

  @override
  String get userUpdatedSuccessfully => 'User updated successfully';

  @override
  String get rules => 'Rules';

  @override
  String get trainingMethods => 'Training Methods';

  @override
  String get injuryPrevention => 'Injury Prevention';

  @override
  String get fitnessRequirements => 'Fitness Requirements';

  @override
  String get rule => 'Rule';

  @override
  String get trainingMethod => 'Training Method';

  @override
  String get injuryPreventionSingular => 'Injury Prevention';

  @override
  String get fitnessRequirement => 'Fitness Requirement';

  @override
  String get injuryPreventionAndTreatment => 'Injury Prevention & Treatment';

  @override
  String get manageInjuryDataDescription =>
      'Manage injury prevention tips and treatment guidelines';

  @override
  String get prevention => 'Prevention';

  @override
  String get treatment => 'Treatment';

  @override
  String get noPreventionAvailable => 'No Prevention Available';

  @override
  String get noTreatmentAvailable => 'No Treatment Available';
}
