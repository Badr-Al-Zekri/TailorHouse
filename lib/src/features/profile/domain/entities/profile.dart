import 'package:equatable/equatable.dart';

/// Extended user profile with preferences
class UserProfile extends Equatable {
  final String userId;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final ProfilePreferences preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.preferences = const ProfilePreferences(),
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    DateTime? dateOfBirth,
    String? gender,
    ProfilePreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get age if date of birth is set
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Get initials for avatar placeholder
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        email,
        phoneNumber,
        avatarUrl,
        dateOfBirth,
        gender,
        preferences,
        createdAt,
        updatedAt,
      ];
}

/// User preferences
class ProfilePreferences extends Equatable {
  final String language;
  final String country;
  final MeasurementUnit measurementUnit;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final ThemePreference themePreference;

  const ProfilePreferences({
    this.language = 'en',
    this.country = 'US',
    this.measurementUnit = MeasurementUnit.metric,
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.themePreference = ThemePreference.system,
  });

  ProfilePreferences copyWith({
    String? language,
    String? country,
    MeasurementUnit? measurementUnit,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    ThemePreference? themePreference,
  }) {
    return ProfilePreferences(
      language: language ?? this.language,
      country: country ?? this.country,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      themePreference: themePreference ?? this.themePreference,
    );
  }

  @override
  List<Object?> get props => [
        language,
        country,
        measurementUnit,
        notificationsEnabled,
        emailNotifications,
        pushNotifications,
        themePreference,
      ];
}

/// Measurement unit preference
enum MeasurementUnit {
  metric('Metric (cm, kg)'),
  imperial('Imperial (in, lbs)');

  final String displayName;
  const MeasurementUnit(this.displayName);
}

/// Theme preference
enum ThemePreference {
  light('Light'),
  dark('Dark'),
  system('System Default');

  final String displayName;
  const ThemePreference(this.displayName);
}

