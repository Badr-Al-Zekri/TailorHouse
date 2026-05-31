import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_shadows.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';

/// Choose Language screen - shown after login/signup
class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  String? _selectedLanguage;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<LanguageOption> _languages = const [
    LanguageOption(
      code: 'ar',
      name: 'العربية',
      nativeName: 'Arabic',
      flag: '🇸🇦',
    ),
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    LanguageOption(
      code: 'tr',
      name: 'Türkçe',
      nativeName: 'Turkish',
      flag: '🇹🇷',
    ),
    LanguageOption(
      code: 'ku',
      name: 'کوردی',
      nativeName: 'Kurdish',
      flag: '🇮🇶',
    ),
  ];

  List<LanguageOption> get _filteredLanguages {
    if (_searchQuery.isEmpty) return _languages;
    return _languages.where((lang) {
      return lang.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lang.nativeName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selectedLanguage != null) {
      // TODO: Save selected language
      context.go(AppRoutes.enableLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: const Icon(
                        Icons.language,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Choose Language',
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Select your preferred language',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
              const SizedBox(height: AppSpacing.xl),

              // Search
              AppTextField.search(
                controller: _searchController,
                hint: 'Search language...',
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ).animate(delay: 200.ms).fadeIn(),
              const SizedBox(height: AppSpacing.lg),

              // Language list
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredLanguages.length,
                  itemBuilder: (context, index) {
                    final language = _filteredLanguages[index];
                    final isSelected = _selectedLanguage == language.code;
                    return _LanguageCard(
                      language: language,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() => _selectedLanguage = language.code);
                      },
                    )
                        .animate(delay: Duration(milliseconds: 300 + (index * 100)))
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Continue button
              AppButton.gradient(
                text: 'Continue',
                onPressed: _selectedLanguage != null ? _onContinue : null,
                trailingIcon: Icons.arrow_forward,
              ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2, end: 0),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

class _LanguageCard extends StatelessWidget {
  final LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.paddingMd),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.sm : null,
        ),
        child: Row(
          children: [
            // Flag
            Text(
              language.flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: AppSpacing.md),
            // Language name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.name,
                    style: AppTypography.titleMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    language.nativeName,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Check icon
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

