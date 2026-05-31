import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';

/// Reusable text field component
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final TextCapitalization textCapitalization;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textCapitalization = TextCapitalization.none,
  });

  /// Email field preset
  factory AppTextField.email({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    String? errorText,
    bool enabled = true,
  }) {
    return AppTextField(
      key: key,
      label: 'Email',
      hint: 'Enter your email',
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.email_outlined),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      errorText: errorText,
      enabled: enabled,
      textCapitalization: TextCapitalization.none,
    );
  }

  /// Password field preset
  static Widget password({
    Key? key,
    String label = 'Password',
    String hint = 'Enter your password',
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    String? errorText,
    bool enabled = true,
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    return _PasswordTextField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      errorText: errorText,
      enabled: enabled,
      textInputAction: textInputAction,
    );
  }

  /// Phone number field preset
  factory AppTextField.phone({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FormFieldValidator<String>? validator,
    String? errorText,
    bool enabled = true,
  }) {
    return AppTextField(
      key: key,
      label: 'Phone Number',
      hint: 'Enter your phone number',
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.phone_outlined),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      errorText: errorText,
      enabled: enabled,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\+\(\)]')),
      ],
    );
  }

  /// Measurement field preset
  factory AppTextField.measurement({
    Key? key,
    required String label,
    String unit = 'cm',
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
    bool enabled = true,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hint: '0.0',
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      suffixText: unit,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      enabled: enabled,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
    );
  }

  /// Search field preset
  static Widget search({
    Key? key,
    String hint = 'Search...',
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    VoidCallback? onClear,
    bool enabled = true,
  }) {
    return _SearchTextField(
      key: key,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onClear: onClear,
      enabled: enabled,
    );
  }

  /// Multiline field preset
  factory AppTextField.multiline({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
    int minLines = 3,
    int maxLines = 5,
    int? maxLength,
    bool enabled = true,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      enabled: enabled,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.gapXs),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          autovalidateMode: widget.autovalidateMode,
          textCapitalization: widget.textCapitalization,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
          ),
        ),
      ],
    );
  }
}

/// Password text field with toggle visibility
class _PasswordTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final bool enabled;
  final TextInputAction textInputAction;

  const _PasswordTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      errorText: widget.errorText,
      enabled: widget.enabled,
    );
  }
}

/// Search text field with clear button
class _SearchTextField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool enabled;

  const _SearchTextField({
    super.key,
    required this.hint,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onClear,
    this.enabled = true,
  });

  @override
  State<_SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  late TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _showClear = _controller.text.isNotEmpty;
    _controller.addListener(_updateClearButton);
  }

  void _updateClearButton() {
    final shouldShow = _controller.text.isNotEmpty;
    if (_showClear != shouldShow) {
      setState(() {
        _showClear = shouldShow;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hint: widget.hint,
      controller: _controller,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _showClear
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                widget.onClear?.call();
              },
            )
          : null,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
    );
  }
}

