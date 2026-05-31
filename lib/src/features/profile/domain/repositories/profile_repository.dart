import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/profile/domain/entities/profile.dart';

/// Abstract repository for profile operations
abstract class ProfileRepository {
  /// Get current user's profile
  FutureResult<UserProfile> getProfile();

  /// Update profile information
  FutureResult<UserProfile> updateProfile(UserProfile profile);

  /// Update user avatar
  FutureResult<String> updateAvatar(String imagePath);

  /// Delete user avatar
  FutureResult<void> deleteAvatar();

  /// Update preferences
  FutureResult<ProfilePreferences> updatePreferences(
    ProfilePreferences preferences,
  );

  /// Get preferences
  FutureResult<ProfilePreferences> getPreferences();

  /// Delete account and all data
  FutureResult<void> deleteAccount();

  /// Export all user data
  FutureResult<Map<String, dynamic>> exportData();

  /// Stream of profile changes
  Stream<UserProfile?> watchProfile();
}

