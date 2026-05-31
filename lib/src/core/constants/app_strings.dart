/// Application string constants for UI text
/// These should be moved to localization files for multi-language support
abstract class AppStrings {
  AppStrings._();

  // ============================================================================
  // General
  // ============================================================================

  static const String appName = 'TailorHouse';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String confirm = 'Confirm';
  static const String retry = 'Retry';
  static const String close = 'Close';
  static const String search = 'Search';
  static const String loading = 'Loading...';
  static const String noData = 'No data available';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String warning = 'Warning';
  static const String info = 'Info';

  // ============================================================================
  // Authentication
  // ============================================================================

  static const String login = 'Log In';
  static const String signup = 'Sign Up';
  static const String logout = 'Log Out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String name = 'Name';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String newPassword = 'New Password';
  static const String currentPassword = 'Current Password';
  static const String rememberMe = 'Remember Me';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String continueWithGoogle = 'Continue with Google';
  static const String agreeToTerms = 'I agree to the Privacy Policy and Terms';
  static const String verificationCode = 'Verification Code';
  static const String resendCode = 'Resend Code';
  static const String verifyEmail = 'Verify Email';
  static const String welcomeBack = 'Welcome Back';
  static const String createAccount = 'Create Account';

  // ============================================================================
  // Onboarding
  // ============================================================================

  static const String onboardingTitle1 = 'Perfect Fit at Home';
  static const String onboardingSubtitle1 =
      'Get precise body measurements using AI technology from the comfort of your home';

  static const String onboardingTitle2 = 'Custom Made for You';
  static const String onboardingSubtitle2 =
      'Order custom clothes that match your exact measurements for the perfect fit';

  static const String onboardingTitle3 = 'Easy Alterations';
  static const String onboardingSubtitle3 =
      'Request alterations on your existing clothes with just a few taps';

  static const String getStarted = 'Get Started';

  // ============================================================================
  // Home
  // ============================================================================

  static const String home = 'Home';
  static const String hello = 'Hello';
  static const String welcomeMessage = 'What would you like to do today?';
  static const String giveMeasurement = 'Give Measurement';
  static const String alterClothes = 'Alter Clothes';
  static const String orderHistory = 'Order History';
  static const String customize = 'Customize';

  // ============================================================================
  // Measurements
  // ============================================================================

  static const String myMeasurements = 'My Measurements';
  static const String newMeasurement = 'New Measurement';
  static const String aiMeasurement = 'AI Measurement';
  static const String manualMeasurement = 'Manual Measurement';
  static const String measurementProfile = 'Measurement Profile';
  static const String measurementHistory = 'Measurement History';
  static const String height = 'Height';
  static const String weight = 'Weight';
  static const String neck = 'Neck';
  static const String shoulder = 'Shoulder';
  static const String chest = 'Chest';
  static const String waist = 'Waist';
  static const String hip = 'Hip';
  static const String armLength = 'Arm Length';
  static const String wrist = 'Wrist';
  static const String thigh = 'Thigh';
  static const String inseam = 'Inseam';
  static const String outseam = 'Outseam';
  static const String calf = 'Calf';
  static const String ankle = 'Ankle';
  static const String cm = 'cm';
  static const String inches = 'in';
  static const String kg = 'kg';
  static const String lbs = 'lbs';

  // AI Measurement
  static const String aiMeasurementTitle = 'AI Body Measurement';
  static const String aiMeasurementInstructions =
      'Stand in a well-lit area and follow the instructions to capture your measurements';
  static const String takeFrontPhoto = 'Front Photo';
  static const String takeSidePhoto = 'Side Photo';
  static const String takeBackPhoto = 'Back Photo';
  static const String processing = 'Processing...';
  static const String analyzingPhotos = 'Analyzing your photos...';
  static const String reviewMeasurements = 'Review Measurements';
  static const String measurementsReady = 'Your measurements are ready!';
  static const String adjustIfNeeded = 'Review and adjust if needed';

  // ============================================================================
  // Orders
  // ============================================================================

  static const String orders = 'Orders';
  static const String newOrder = 'New Order';
  static const String orderDetails = 'Order Details';
  static const String orderStatus = 'Order Status';
  static const String orderId = 'Order ID';
  static const String orderDate = 'Order Date';
  static const String estimatedDelivery = 'Estimated Delivery';
  static const String totalAmount = 'Total Amount';
  static const String quantity = 'Quantity';
  static const String price = 'Price';
  static const String addToCart = 'Add to Cart';
  static const String placeOrder = 'Place Order';
  static const String viewDetails = 'View Details';
  static const String trackOrder = 'Track Order';
  static const String cancelOrder = 'Cancel Order';
  static const String reorder = 'Reorder';

  // Order Status
  static const String pending = 'Pending';
  static const String confirmed = 'Confirmed';
  static const String cutting = 'Cutting';
  static const String sewing = 'Sewing';
  static const String ready = 'Ready';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';

  // ============================================================================
  // Alteration
  // ============================================================================

  static const String alteration = 'Alteration';
  static const String requestAlteration = 'Request Alteration';
  static const String alterationDetails = 'Alteration Details';
  static const String selectGarment = 'Select Garment';
  static const String uploadPhoto = 'Upload Photo';
  static const String takePhoto = 'Take Photo';
  static const String describeAlteration = 'Describe the alteration needed';
  static const String alterationInstructions = 'Instructions';

  // ============================================================================
  // Profile
  // ============================================================================

  static const String profile = 'Profile';
  static const String myProfile = 'My Profile';
  static const String editProfile = 'Edit Profile';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';
  static const String language = 'Language';
  static const String country = 'Country';
  static const String changePassword = 'Change Password';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsAndConditions = 'Terms & Conditions';
  static const String helpAndSupport = 'Help & Support';
  static const String about = 'About';
  static const String dateOfBirth = 'Date of Birth';
  static const String gender = 'Gender';
  static const String male = 'Male';
  static const String female = 'Female';
  static const String other = 'Other';

  // ============================================================================
  // Shop
  // ============================================================================

  static const String shop = 'Shop';
  static const String shopInfo = 'Shop Info';
  static const String contactShop = 'Contact Shop';
  static const String getDirections = 'Get Directions';
  static const String openingHours = 'Opening Hours';
  static const String rating = 'Rating';
  static const String reviews = 'Reviews';
  static const String writeReview = 'Write a Review';
  static const String callNow = 'Call Now';
  static const String chatOnWhatsApp = 'Chat on WhatsApp';

  // ============================================================================
  // Navigation
  // ============================================================================

  static const String category = 'Category';
  static const String ai = 'AI';
  static const String cart = 'Cart';
  static const String account = 'Account';

  // ============================================================================
  // Errors & Messages
  // ============================================================================

  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternetConnection = 'No internet connection';
  static const String sessionExpired = 'Your session has expired';
  static const String invalidCredentials = 'Invalid email or password';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String fieldRequired = 'This field is required';
  static const String invalidPhoneNumber = 'Please enter a valid phone number';
  static const String cameraPermissionRequired = 'Camera permission is required';
  static const String saveChanges = 'Save Changes';
  static const String discardChanges = 'Discard Changes';
  static const String unsavedChanges = 'You have unsaved changes';
  static const String unsavedChangesMessage =
      'Are you sure you want to leave? Your changes will be lost.';

  // Success messages
  static const String profileUpdated = 'Profile updated successfully';
  static const String passwordChanged = 'Password changed successfully';
  static const String measurementSaved = 'Measurement saved successfully';
  static const String orderPlaced = 'Order placed successfully';
  static const String alterationRequested = 'Alteration request submitted';
}

