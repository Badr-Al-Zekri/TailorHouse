import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';

/// Settings screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  String _selectedLanguage = 'English';
  String _selectedCountry = 'United States';
  String _measurementUnit = 'Metric (cm)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account section
            _SectionHeader(title: 'Account')
                .animate().fadeIn(),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () => context.push(AppRoutes.changePassword),
                  ),
                  const Divider(height: 1),
                  _SettingsItem(
                    icon: Icons.language,
                    title: 'Language',
                    value: _selectedLanguage,
                    onTap: () => _showLanguagePicker(),
                  ),
                  const Divider(height: 1),
                  _SettingsItem(
                    icon: Icons.public,
                    title: 'Country',
                    value: _selectedCountry,
                    onTap: () => _showCountryPicker(),
                  ),
                  const Divider(height: 1),
                  _SettingsItem(
                    icon: Icons.straighten,
                    title: 'Measurement Unit',
                    value: _measurementUnit,
                    onTap: () => _showMeasurementUnitPicker(),
                  ),
                ],
              ),
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05, end: 0),
            const SizedBox(height: AppSpacing.lg),

            // Notifications section
            _SectionHeader(title: 'Notifications')
                .animate(delay: 200.ms).fadeIn(),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _SettingsSwitch(
                    icon: Icons.notifications_outlined,
                    title: 'Enable Notifications',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() => _notificationsEnabled = value);
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsSwitch(
                    icon: Icons.email_outlined,
                    title: 'Email Notifications',
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() => _emailNotifications = value);
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsSwitch(
                    icon: Icons.phone_android,
                    title: 'Push Notifications',
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() => _pushNotifications = value);
                    },
                  ),
                ],
              ),
            ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.05, end: 0),
            const SizedBox(height: AppSpacing.lg),

            // Data & Privacy section
            _SectionHeader(title: 'Data & Privacy')
                .animate(delay: 400.ms).fadeIn(),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.download_outlined,
                    title: 'Export My Data',
                    onTap: () {
                      // TODO: Export data
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsItem(
                    icon: Icons.delete_outline,
                    title: 'Delete My Measurements',
                    titleColor: AppColors.warning,
                    onTap: () => _showDeleteMeasurementsDialog(),
                  ),
                  const Divider(height: 1),
                  _SettingsItem(
                    icon: Icons.delete_forever_outlined,
                    title: 'Delete Account',
                    titleColor: AppColors.error,
                    onTap: () => _showDeleteAccountDialog(),
                  ),
                ],
              ),
            ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.05, end: 0),
            const SizedBox(height: AppSpacing.lg),

            // About section
            _SectionHeader(title: 'About')
                .animate(delay: 600.ms).fadeIn(),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.info_outline,
                    title: 'App Version',
                    value: '1.0.0',
                    showArrow: false,
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _SettingsItem(
                    icon: Icons.star_outline,
                    title: 'Rate the App',
                    onTap: () {
                      // TODO: Open app store
                    },
                  ),
                ],
              ),
            ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.05, end: 0),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _PickerSheet(
        title: 'Select Language',
        options: const ['English', 'العربية', 'Türkçe', 'کوردی'],
        selectedValue: _selectedLanguage,
        onSelect: (value) {
          setState(() => _selectedLanguage = value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _PickerSheet(
        title: 'Select Country',
        options: const ['United States', 'Saudi Arabia', 'Turkey', 'Iraq', 'UAE'],
        selectedValue: _selectedCountry,
        onSelect: (value) {
          setState(() => _selectedCountry = value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showMeasurementUnitPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _PickerSheet(
        title: 'Select Measurement Unit',
        options: const ['Metric (cm)', 'Imperial (inches)'],
        selectedValue: _measurementUnit,
        onSelect: (value) {
          setState(() => _measurementUnit = value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDeleteMeasurementsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Measurements'),
        content: const Text(
          'Are you sure you want to delete all your measurement profiles? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete measurements
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? All your data will be permanently deleted. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingHorizontal,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Color? titleColor;
  final bool showArrow;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.value,
    this.titleColor,
    this.showArrow = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.textSecondary),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          if (showArrow) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: AppTypography.bodyMedium),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelect;

  const _PickerSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.md),
          ...options.map((option) {
            final isSelected = option == selectedValue;
            return ListTile(
              title: Text(
                option,
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () => onSelect(option),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

