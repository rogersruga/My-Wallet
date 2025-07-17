import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable dropdown widget with consistent styling
class CustomDropdown<T> extends StatelessWidget {
  /// The label text for the dropdown
  final String label;
  
  /// The current selected value
  final T? value;
  
  /// List of dropdown items
  final List<DropdownItem<T>> items;
  
  /// Callback when value changes
  final void Function(T?)? onChanged;
  
  /// Whether the dropdown is required
  final bool isRequired;
  
  /// Whether the dropdown is enabled
  final bool enabled;
  
  /// Hint text when no value is selected
  final String? hint;
  
  /// Validation function
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.isRequired = false,
    this.enabled = true,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: label,
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppTheme.errorRed),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        
        // Dropdown Field
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) => _buildDropdownMenuItem(item)).toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: _buildInputDecoration(),
          style: AppTheme.bodyLarge,
          dropdownColor: AppTheme.backgroundCard,
          icon: Icon(
            Icons.arrow_drop_down,
            color: enabled ? AppTheme.textPrimary : AppTheme.textDisabled,
            size: AppTheme.iconSizeMedium,
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  DropdownMenuItem<T> _buildDropdownMenuItem(DropdownItem<T> item) {
    return DropdownMenuItem<T>(
      value: item.value,
      child: Row(
        children: [
          if (item.icon != null) ...[
            Icon(
              item.icon,
              color: AppTheme.accentOrange,
              size: AppTheme.iconSizeSmall,
            ),
            const SizedBox(width: AppTheme.spacingS),
          ],
          Expanded(
            child: Text(
              item.label,
              style: AppTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTheme.bodyMedium.copyWith(
        color: AppTheme.textTertiary,
      ),
      filled: true,
      fillColor: AppTheme.backgroundCard,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        borderSide: const BorderSide(
          color: AppTheme.borderSecondary,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        borderSide: const BorderSide(
          color: AppTheme.borderFocus,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        borderSide: const BorderSide(
          color: AppTheme.borderError,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        borderSide: const BorderSide(
          color: AppTheme.borderError,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        borderSide: BorderSide(
          color: AppTheme.textDisabled.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      errorStyle: const TextStyle(
        color: AppTheme.errorRed,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// Data class for dropdown items
class DropdownItem<T> {
  /// The value of the item
  final T value;
  
  /// The display label
  final String label;
  
  /// Optional subtitle
  final String? subtitle;
  
  /// Optional icon
  final IconData? icon;

  const DropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}

/// Helper class for common dropdown validators
class DropdownValidators {
  static String? required<T>(T? value, {String? fieldName}) {
    if (value == null) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }
}

/// Predefined payment method dropdown items
class PaymentMethodItems {
  static const List<DropdownItem<String>> items = [
    DropdownItem(
      value: 'bank_transfer',
      label: 'Bank Transfer',
      subtitle: 'Direct bank account transfer',
      icon: Icons.account_balance,
    ),
    DropdownItem(
      value: 'mobile_money',
      label: 'Mobile Money',
      subtitle: 'Mobile wallet transfer',
      icon: Icons.phone_android,
    ),
    DropdownItem(
      value: 'credit_card',
      label: 'Credit Card',
      subtitle: 'Pay with credit card',
      icon: Icons.credit_card,
    ),
    DropdownItem(
      value: 'debit_card',
      label: 'Debit Card',
      subtitle: 'Pay with debit card',
      icon: Icons.payment,
    ),
    DropdownItem(
      value: 'paypal',
      label: 'PayPal',
      subtitle: 'PayPal account transfer',
      icon: Icons.account_balance_wallet,
    ),
  ];
  
  static DropdownItem<String>? getByValue(String value) {
    try {
      return items.firstWhere((item) => item.value == value);
    } catch (e) {
      return null;
    }
  }
  
  static IconData getIconByValue(String value) {
    final item = getByValue(value);
    return item?.icon ?? Icons.payment;
  }
  
  static String getLabelByValue(String value) {
    final item = getByValue(value);
    return item?.label ?? value;
  }
}
