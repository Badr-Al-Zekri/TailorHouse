import 'package:flutter/material.dart';

/// Extension methods for BuildContext
extension BuildContextExtensions on BuildContext {
  // ============================================================================
  // Theme
  // ============================================================================

  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // ============================================================================
  // Media Query
  // ============================================================================

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  double get bottomPadding => padding.bottom;
  double get topPadding => padding.top;
  double get keyboardHeight => viewInsets.bottom;
  bool get isKeyboardVisible => keyboardHeight > 0;
  Orientation get orientation => mediaQuery.orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // ============================================================================
  // Screen Size Breakpoints
  // ============================================================================

  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isLargeScreen => screenWidth >= 600 && screenWidth < 900;
  bool get isExtraLargeScreen => screenWidth >= 900;

  // ============================================================================
  // Navigation
  // ============================================================================

  NavigatorState get navigator => Navigator.of(this);

  void pop<T>([T? result]) => navigator.pop(result);

  Future<T?> push<T>(Route<T> route) => navigator.push(route);

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamed<T>(routeName, arguments: arguments);

  Future<T?> pushReplacement<T, TO>(Route<T> route, {TO? result}) =>
      navigator.pushReplacement(route, result: result);

  Future<T?> pushReplacementNamed<T, TO>(String routeName, {TO? result, Object? arguments}) =>
      navigator.pushReplacementNamed(routeName, result: result, arguments: arguments);

  Future<T?> pushAndRemoveUntil<T>(Route<T> route, RoutePredicate predicate) =>
      navigator.pushAndRemoveUntil(route, predicate);

  void popUntil(RoutePredicate predicate) => navigator.popUntil(predicate);

  bool canPop() => navigator.canPop();

  // ============================================================================
  // Focus
  // ============================================================================

  FocusScopeNode get focusScope => FocusScope.of(this);

  void unfocus() => focusScope.unfocus();

  void requestFocus([FocusNode? node]) => focusScope.requestFocus(node);

  // ============================================================================
  // Snackbar
  // ============================================================================

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.primary,
    );
  }

  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
    );
  }

  // ============================================================================
  // Dialog
  // ============================================================================

  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }

  // ============================================================================
  // Bottom Sheet
  // ============================================================================

  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      builder: (_) => child,
    );
  }
}

