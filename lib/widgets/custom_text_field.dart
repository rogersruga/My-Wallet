import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// A reusable text field widget with consistent styling
class CustomTextField extends StatefulWidget {
  /// The controller for the text field
  final TextEditingController? controller;
  
  /// The label text for the field
  final String label;
  
  /// The hint text for the field
  final String? hint;
  
  /// Whether the field is required
  final bool isRequired;
  
  /// Custom validation function
  final String? Function(String?)? validator;
  
  /// The keyboard type
  final TextInputType keyboardType;
  
  /// Whether to obscure the text (for passwords)
  final bool obscureText;
  
  /// Maximum length of input
  final int? maxLength;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Prefix icon
  final IconData? prefixIcon;
  
  /// Suffix icon
  final IconData? suffixIcon;
  
  /// Suffix icon callback
  final VoidCallback? onSuffixIconPressed;
  
  /// Whether the field is enabled
  final bool enabled;
  
  /// Callback when the value changes
  final void Function(String)? onChanged;
  
  /// Callback when editing is complete
  final void Function()? onEditingComplete;
  
  /// Focus node for the field
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.isRequired = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.enabled = true,
    this.onChanged,
    this.onEditingComplete,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: widget.label,
            style: AppTheme.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (widget.isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppTheme.errorRed),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        
        // Text Field
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          obscureText: _isObscured,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          style: AppTheme.bodyLarge,
          decoration: _buildInputDecoration(),
          validator: widget.validator,
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hint,
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
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: AppTheme.accentOrange,
              size: AppTheme.iconSizeMedium,
            )
          : null,
      suffixIcon: _buildSuffixIcon(),
      errorStyle: const TextStyle(
        color: AppTheme.errorRed,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      counterStyle: AppTheme.bodySmall,
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility : Icons.visibility_off,
          color: AppTheme.textSecondary,
          size: AppTheme.iconSizeMedium,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }
    
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: AppTheme.accentOrange,
          size: AppTheme.iconSizeMedium,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }
    
    return null;
  }
}

/// Validation helper class
class FieldValidators {
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  static String? amount(String? value, {double? minAmount, double? maxAmount}) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    final double? amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Please enter a valid number';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (minAmount != null && amount < minAmount) {
      return 'Amount must be at least \$${minAmount.toStringAsFixed(2)}';
    }
    
    if (maxAmount != null && amount > maxAmount) {
      return 'Amount cannot exceed \$${maxAmount.toStringAsFixed(2)}';
    }
    
    return null;
  }

  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (value.trim().length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    
    return null;
  }

  static String? pin(String? value, {int length = 4}) {
    if (value == null || value.trim().isEmpty) {
      return 'PIN is required';
    }
    
    if (value.trim().length < length) {
      return 'PIN must be at least $length digits';
    }
    
    final pinRegex = RegExp(r'^\d+$');
    if (!pinRegex.hasMatch(value.trim())) {
      return 'PIN must contain only numbers';
    }
    
    return null;
  }
}
