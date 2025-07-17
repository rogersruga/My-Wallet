import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Utility class for showing consistent snackbars throughout the app
class CustomSnackBar {
  /// Show a success snackbar
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: AppTheme.successGreen,
      duration: duration,
      action: action,
    );
  }

  /// Show an error snackbar
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: AppTheme.errorRed,
      duration: duration,
      action: action,
    );
  }

  /// Show a warning snackbar
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      icon: Icons.warning_outlined,
      backgroundColor: AppTheme.warningAmber,
      duration: duration,
      action: action,
    );
  }

  /// Show an info snackbar
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: AppTheme.infoBlue,
      duration: duration,
      action: action,
    );
  }

  /// Show a custom snackbar
  static void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
    );
  }

  /// Internal method to show snackbar with consistent styling
  static void _showSnackBar(
    BuildContext context, {
    required String message,
    IconData? icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    // Remove any existing snackbar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: AppTheme.textPrimary,
              size: AppTheme.iconSizeMedium,
            ),
            const SizedBox(width: AppTheme.spacingM),
          ],
          Expanded(
            child: Text(
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      margin: const EdgeInsets.all(AppTheme.spacingM),
      action: action,
      actionOverflowThreshold: 0.25,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Predefined snackbar actions
class SnackBarActions {
  /// Retry action
  static SnackBarAction retry(VoidCallback onPressed) {
    return SnackBarAction(
      label: 'Retry',
      textColor: AppTheme.textPrimary,
      onPressed: onPressed,
    );
  }

  /// Undo action
  static SnackBarAction undo(VoidCallback onPressed) {
    return SnackBarAction(
      label: 'Undo',
      textColor: AppTheme.textPrimary,
      onPressed: onPressed,
    );
  }

  /// View action
  static SnackBarAction view(VoidCallback onPressed) {
    return SnackBarAction(
      label: 'View',
      textColor: AppTheme.textPrimary,
      onPressed: onPressed,
    );
  }

  /// Dismiss action
  static SnackBarAction dismiss(VoidCallback onPressed) {
    return SnackBarAction(
      label: 'Dismiss',
      textColor: AppTheme.textPrimary,
      onPressed: onPressed,
    );
  }

  /// Settings action
  static SnackBarAction settings(VoidCallback onPressed) {
    return SnackBarAction(
      label: 'Settings',
      textColor: AppTheme.textPrimary,
      onPressed: onPressed,
    );
  }
}

/// Extension on BuildContext for easier snackbar access
extension SnackBarExtension on BuildContext {
  /// Show success snackbar
  void showSuccessSnackBar(String message, {SnackBarAction? action}) {
    CustomSnackBar.showSuccess(this, message, action: action);
  }

  /// Show error snackbar
  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    CustomSnackBar.showError(this, message, action: action);
  }

  /// Show warning snackbar
  void showWarningSnackBar(String message, {SnackBarAction? action}) {
    CustomSnackBar.showWarning(this, message, action: action);
  }

  /// Show info snackbar
  void showInfoSnackBar(String message, {SnackBarAction? action}) {
    CustomSnackBar.showInfo(this, message, action: action);
  }
}
