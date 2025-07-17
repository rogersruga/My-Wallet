import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable switch widget with consistent styling and enhanced features
class CustomSwitch extends StatelessWidget {
  /// The current value of the switch
  final bool value;
  
  /// Callback when the switch value changes
  final void Function(bool)? onChanged;
  
  /// The title text for the switch
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Optional leading icon
  final IconData? icon;
  
  /// Whether the switch is enabled
  final bool enabled;
  
  /// Custom active color
  final Color? activeColor;
  
  /// Custom inactive color
  final Color? inactiveColor;
  
  /// Whether to show the switch in a card container
  final bool showInCard;
  
  /// Custom padding
  final EdgeInsetsGeometry? padding;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.icon,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.showInCard = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = _buildSwitchContent();
    
    if (showInCard) {
      return Container(
        padding: padding ?? const EdgeInsets.all(AppTheme.spacingS),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(color: AppTheme.borderSecondary),
        ),
        child: switchWidget,
      );
    }
    
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: switchWidget,
    );
  }

  Widget _buildSwitchContent() {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: enabled 
                ? (value ? (activeColor ?? AppTheme.accentOrange) : AppTheme.textSecondary)
                : AppTheme.textDisabled,
            size: AppTheme.iconSizeMedium,
          ),
          const SizedBox(width: AppTheme.spacingM),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: enabled ? AppTheme.textPrimary : AppTheme.textDisabled,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  subtitle!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: enabled ? AppTheme.textSecondary : AppTheme.textDisabled,
                  ),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: activeColor ?? AppTheme.accentOrange,
          activeTrackColor: (activeColor ?? AppTheme.accentOrange).withValues(alpha: 0.3),
          inactiveThumbColor: inactiveColor ?? AppTheme.textSecondary,
          inactiveTrackColor: AppTheme.borderSecondary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}

/// A specialized switch for favorite/bookmark functionality
class FavoriteSwitch extends StatelessWidget {
  /// Whether the item is marked as favorite
  final bool isFavorite;
  
  /// Callback when favorite status changes
  final void Function(bool)? onChanged;
  
  /// Whether the switch is enabled
  final bool enabled;

  const FavoriteSwitch({
    super.key,
    required this.isFavorite,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSwitch(
      value: isFavorite,
      onChanged: onChanged,
      enabled: enabled,
      title: 'Save as Favorite',
      subtitle: 'Quick access for future transfers',
      icon: isFavorite ? Icons.favorite : Icons.favorite_outline,
      activeColor: AppTheme.accentOrange,
    );
  }
}

/// A specialized switch for notification settings
class NotificationSwitch extends StatelessWidget {
  /// Whether notifications are enabled
  final bool isEnabled;
  
  /// Callback when notification setting changes
  final void Function(bool)? onChanged;
  
  /// The type of notification
  final String notificationType;
  
  /// Optional description
  final String? description;

  const NotificationSwitch({
    super.key,
    required this.isEnabled,
    required this.notificationType,
    this.onChanged,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSwitch(
      value: isEnabled,
      onChanged: onChanged,
      title: notificationType,
      subtitle: description,
      icon: isEnabled ? Icons.notifications_active : Icons.notifications_off,
      activeColor: AppTheme.successGreen,
    );
  }
}

/// A specialized switch for privacy/security settings
class PrivacySwitch extends StatelessWidget {
  /// Whether the privacy setting is enabled
  final bool isEnabled;
  
  /// Callback when privacy setting changes
  final void Function(bool)? onChanged;
  
  /// The privacy setting name
  final String settingName;
  
  /// Optional description
  final String? description;
  
  /// Whether this is enabled by default
  final bool enabled;

  const PrivacySwitch({
    super.key,
    required this.isEnabled,
    required this.settingName,
    this.onChanged,
    this.description,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSwitch(
      value: isEnabled,
      onChanged: onChanged,
      enabled: enabled,
      title: settingName,
      subtitle: description,
      icon: isEnabled ? Icons.security : Icons.security_outlined,
      activeColor: AppTheme.infoBlue,
    );
  }
}
