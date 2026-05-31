/// Application-wide constants
abstract class AppConstants {
  // API endpoints (placeholder)
  static const String apiBaseUrl = 'https://api.tailorhouse.app/v1';
  
  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'onboarding_complete';
  static const String languageKey = 'app_language';
  static const String measurementUnitKey = 'measurement_unit';
  
  // Hive box names
  static const String hiveBoxAuth = 'auth_box';
  static const String hiveBoxMeasurements = 'measurements_box';
  static const String hiveBoxOrders = 'orders_box';
  static const String hiveBoxSettings = 'settings_box';
  static const String hiveBoxCache = 'cache_box';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxMeasurementValue = 500; // cm
  static const int minMeasurementValue = 10; // cm
  
  // Body measurements validation
  static const double minHeight = 100; // cm
  static const double maxHeight = 250; // cm
  static const double minWeight = 30; // kg
  static const double maxWeight = 300; // kg
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // AI Measurement
  static const double minConfidenceThreshold = 0.7;
  static const int requiredPhotos = 2; // Front and side
  static const int aiMinPhotos = 2;
  static const int aiMaxPhotos = 5;
}

/// Order status enum
enum OrderStatus {
  pending('Pending', 'Your order has been placed'),
  confirmed('Confirmed', 'Order confirmed by tailor'),
  cutting('Cutting', 'Fabric is being cut'),
  sewing('Sewing', 'Garment is being sewn'),
  ready('Ready', 'Ready for pickup/delivery'),
  delivered('Delivered', 'Order completed'),
  cancelled('Cancelled', 'Order was cancelled');

  final String displayName;
  final String description;

  const OrderStatus(this.displayName, this.description);
}

/// Garment types
enum GarmentType {
  shirt('Shirt'),
  pants('Pants'),
  suit('Suit'),
  dress('Dress'),
  jacket('Jacket'),
  thobe('Thobe'),
  abaya('Abaya'),
  other('Other');

  final String displayName;

  const GarmentType(this.displayName);
}

/// Measurement units
enum MeasurementUnit {
  centimeter('cm', 'Centimeter'),
  inch('in', 'Inch');

  final String symbol;
  final String displayName;

  const MeasurementUnit(this.symbol, this.displayName);
}
