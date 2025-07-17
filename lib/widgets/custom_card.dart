import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable card widget with consistent styling
class CustomCard extends StatelessWidget {
  /// The child widget to display inside the card
  final Widget child;
  
  /// Custom padding for the card content
  final EdgeInsetsGeometry? padding;
  
  /// Custom margin for the card
  final EdgeInsetsGeometry? margin;
  
  /// Custom background color
  final Color? backgroundColor;
  
  /// Custom border radius
  final double? borderRadius;
  
  /// Custom elevation
  final double? elevation;
  
  /// Whether to show a border
  final bool showBorder;
  
  /// Custom border color
  final Color? borderColor;
  
  /// Whether to apply gradient background
  final bool useGradient;
  
  /// Custom gradient
  final Gradient? gradient;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.showBorder = false,
    this.borderColor,
    this.useGradient = false,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardChild = Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingL),
      decoration: _buildDecoration(),
      child: child,
    );

    if (onTap != null) {
      return Container(
        margin: margin,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusL),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusL),
            child: cardChild,
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      child: cardChild,
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: useGradient ? null : (backgroundColor ?? AppTheme.backgroundCard),
      gradient: useGradient ? (gradient ?? AppTheme.cardGradient) : null,
      borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusL),
      border: showBorder
          ? Border.all(
              color: borderColor ?? AppTheme.borderPrimary,
              width: 1,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: elevation ?? AppTheme.elevationMedium,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

/// A specialized card for displaying transfer information
class TransferInfoCard extends StatelessWidget {
  /// The recipient's name
  final String recipientName;
  
  /// The transfer amount
  final String amount;
  
  /// The payment method
  final String paymentMethod;
  
  /// Whether the transfer is marked as favorite
  final bool isFavorite;
  
  /// Icon for the payment method
  final IconData? paymentMethodIcon;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;

  const TransferInfoCard({
    super.key,
    required this.recipientName,
    required this.amount,
    required this.paymentMethod,
    this.isFavorite = false,
    this.paymentMethodIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      useGradient: true,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipient Info
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.accentOrange,
                radius: 25,
                child: Text(
                  recipientName.isNotEmpty ? recipientName[0].toUpperCase() : 'R',
                  style: AppTheme.headingSmall.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipientName,
                      style: AppTheme.headingSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Row(
                      children: [
                        Icon(
                          paymentMethodIcon ?? Icons.payment,
                          color: AppTheme.accentOrange,
                          size: AppTheme.iconSizeSmall,
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Text(
                          paymentMethod,
                          style: AppTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isFavorite)
                const Icon(
                  Icons.favorite,
                  color: AppTheme.accentOrange,
                  size: AppTheme.iconSizeMedium,
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          // Amount Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.backgroundPrimary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Column(
              children: [
                Text(
                  'Transfer Amount',
                  style: AppTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  amount,
                  style: AppTheme.headingLarge.copyWith(
                    color: AppTheme.accentOrange,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A specialized card for displaying account balance
class BalanceCard extends StatelessWidget {
  /// The account balance
  final String balance;
  
  /// The account type/name
  final String accountName;
  
  /// Whether to show the balance (for privacy)
  final bool showBalance;
  
  /// Callback to toggle balance visibility
  final VoidCallback? onToggleVisibility;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.accountName,
    this.showBalance = true,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      useGradient: true,
      gradient: AppTheme.accentGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                accountName,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onToggleVisibility != null)
                IconButton(
                  onPressed: onToggleVisibility,
                  icon: Icon(
                    showBalance ? Icons.visibility : Icons.visibility_off,
                    color: AppTheme.textPrimary,
                    size: AppTheme.iconSizeMedium,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'Available Balance',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            showBalance ? balance : '••••••',
            style: AppTheme.headingLarge.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A specialized card for quick actions
class QuickActionCard extends StatelessWidget {
  /// The action icon
  final IconData icon;
  
  /// The action title
  final String title;
  
  /// The action subtitle
  final String? subtitle;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;
  
  /// Custom icon color
  final Color? iconColor;
  
  /// Whether the action is enabled
  final bool enabled;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: enabled ? onTap : null,
      backgroundColor: enabled 
          ? AppTheme.backgroundCard 
          : AppTheme.backgroundCard.withValues(alpha: 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppTheme.iconSizeXL,
            color: enabled 
                ? (iconColor ?? AppTheme.accentOrange)
                : AppTheme.textDisabled,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            title,
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: enabled ? AppTheme.textPrimary : AppTheme.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              subtitle!,
              style: AppTheme.bodySmall.copyWith(
                color: enabled ? AppTheme.textSecondary : AppTheme.textDisabled,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
