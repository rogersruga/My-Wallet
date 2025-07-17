import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable button widget specifically designed for money transfer operations
/// Provides consistent styling and behavior across different screens
class MoneyTransferButton extends StatefulWidget {
  /// The text to display on the button
  final String text;
  
  /// Callback function when button is pressed
  final VoidCallback? onPressed;
  
  /// Whether the button is in loading state
  final bool isLoading;
  
  /// Icon to display before the text (optional)
  final IconData? icon;
  
  /// Button size variant
  final MoneyTransferButtonSize size;
  
  /// Button style variant
  final MoneyTransferButtonStyle style;
  
  /// Whether the button should take full width
  final bool fullWidth;
  
  /// Custom loading text (optional)
  final String? loadingText;
  
  /// Custom background color (optional, overrides style)
  final Color? backgroundColor;
  
  /// Custom text color (optional, overrides style)
  final Color? textColor;

  const MoneyTransferButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = MoneyTransferButtonSize.medium,
    this.style = MoneyTransferButtonStyle.primary,
    this.fullWidth = false,
    this.loadingText,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<MoneyTransferButton> createState() => _MoneyTransferButtonState();
}

class _MoneyTransferButtonState extends State<MoneyTransferButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonConfig = _getButtonConfiguration();
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.fullWidth ? double.infinity : null,
              height: buttonConfig.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(buttonConfig.borderRadius),
                boxShadow: isDisabled ? null : [
                  BoxShadow(
                    color: (widget.backgroundColor ?? buttonConfig.backgroundColor)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: isDisabled ? null : _handlePress,
                style: _buildButtonStyle(buttonConfig, isDisabled),
                child: _buildButtonContent(buttonConfig),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onHover(bool isHovered) {
    // Add subtle hover effect
    if (!widget.isLoading && widget.onPressed != null) {
      // Could add additional hover animations here
    }
  }

  void _handlePress() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onPressed?.call();
  }

  ButtonStyle _buildButtonStyle(ButtonConfiguration config, bool isDisabled) {
    final backgroundColor = widget.backgroundColor ?? config.backgroundColor;
    final elevation = isDisabled ? 0.0 : config.elevation;
    
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled 
          ? AppTheme.textDisabled.withValues(alpha: 0.3)
          : backgroundColor,
      foregroundColor: widget.textColor ?? config.textColor,
      elevation: elevation,
      shadowColor: backgroundColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
        side: config.borderSide ?? BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: config.paddingHorizontal,
        vertical: config.paddingVertical,
      ),
      textStyle: config.textStyle,
    );
  }

  Widget _buildButtonContent(ButtonConfiguration config) {
    if (widget.isLoading) {
      return _buildLoadingContent(config);
    }

    if (widget.icon != null) {
      return _buildIconContent(config);
    }

    return Text(
      widget.text,
      style: config.textStyle.copyWith(
        color: widget.textColor ?? config.textColor,
      ),
    );
  }

  Widget _buildLoadingContent(ButtonConfiguration config) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: config.loadingIndicatorSize,
          height: config.loadingIndicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.textColor ?? config.textColor,
            ),
          ),
        ),
        if (widget.loadingText != null) ...[
          SizedBox(width: AppTheme.spacingS),
          Text(
            widget.loadingText!,
            style: config.textStyle.copyWith(
              color: widget.textColor ?? config.textColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIconContent(ButtonConfiguration config) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widget.icon,
          size: config.iconSize,
          color: widget.textColor ?? config.textColor,
        ),
        SizedBox(width: AppTheme.spacingS),
        Text(
          widget.text,
          style: config.textStyle.copyWith(
            color: widget.textColor ?? config.textColor,
          ),
        ),
      ],
    );
  }

  ButtonConfiguration _getButtonConfiguration() {
    switch (widget.size) {
      case MoneyTransferButtonSize.small:
        return _getSmallButtonConfig();
      case MoneyTransferButtonSize.medium:
        return _getMediumButtonConfig();
      case MoneyTransferButtonSize.large:
        return _getLargeButtonConfig();
    }
  }

  ButtonConfiguration _getSmallButtonConfig() {
    final baseConfig = _getBaseConfigForStyle();
    return baseConfig.copyWith(
      height: AppTheme.buttonHeightSmall,
      paddingHorizontal: AppTheme.spacingM,
      paddingVertical: AppTheme.spacingS,
      textStyle: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      iconSize: AppTheme.iconSizeSmall,
      loadingIndicatorSize: 16,
    );
  }

  ButtonConfiguration _getMediumButtonConfig() {
    final baseConfig = _getBaseConfigForStyle();
    return baseConfig.copyWith(
      height: AppTheme.buttonHeightMedium,
      paddingHorizontal: AppTheme.buttonPaddingHorizontal,
      paddingVertical: AppTheme.buttonPaddingVertical,
      textStyle: AppTheme.buttonText,
      iconSize: AppTheme.iconSizeMedium,
      loadingIndicatorSize: 20,
    );
  }

  ButtonConfiguration _getLargeButtonConfig() {
    final baseConfig = _getBaseConfigForStyle();
    return baseConfig.copyWith(
      height: AppTheme.buttonHeightLarge,
      paddingHorizontal: AppTheme.spacingXL,
      paddingVertical: AppTheme.spacingM, // Reduced from spacingL (24) to spacingM (16) to prevent text clipping
      textStyle: AppTheme.buttonText.copyWith(fontSize: 18),
      iconSize: AppTheme.iconSizeLarge,
      loadingIndicatorSize: 24,
    );
  }

  ButtonConfiguration _getBaseConfigForStyle() {
    switch (widget.style) {
      case MoneyTransferButtonStyle.primary:
        return ButtonConfiguration(
          backgroundColor: AppTheme.accentOrange,
          textColor: AppTheme.textPrimary,
          borderRadius: AppTheme.radiusM,
          elevation: AppTheme.elevationMedium,
        );
      case MoneyTransferButtonStyle.secondary:
        return ButtonConfiguration(
          backgroundColor: AppTheme.backgroundCard,
          textColor: AppTheme.textPrimary,
          borderRadius: AppTheme.radiusM,
          elevation: AppTheme.elevationLow,
          borderSide: const BorderSide(color: AppTheme.borderPrimary, width: 1),
        );
      case MoneyTransferButtonStyle.outline:
        return ButtonConfiguration(
          backgroundColor: Colors.transparent,
          textColor: AppTheme.accentOrange,
          borderRadius: AppTheme.radiusM,
          elevation: 0,
          borderSide: const BorderSide(color: AppTheme.accentOrange, width: 2),
        );
      case MoneyTransferButtonStyle.danger:
        return ButtonConfiguration(
          backgroundColor: AppTheme.errorRed,
          textColor: AppTheme.textPrimary,
          borderRadius: AppTheme.radiusM,
          elevation: AppTheme.elevationMedium,
        );
    }
  }
}

/// Button size variants
enum MoneyTransferButtonSize { small, medium, large }

/// Button style variants
enum MoneyTransferButtonStyle { primary, secondary, outline, danger }

/// Internal configuration class for button properties
class ButtonConfiguration {
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final BorderSide? borderSide;
  final double height;
  final double paddingHorizontal;
  final double paddingVertical;
  final TextStyle textStyle;
  final double iconSize;
  final double loadingIndicatorSize;

  const ButtonConfiguration({
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.elevation,
    this.borderSide,
    this.height = AppTheme.buttonHeightMedium,
    this.paddingHorizontal = AppTheme.buttonPaddingHorizontal,
    this.paddingVertical = AppTheme.buttonPaddingVertical,
    this.textStyle = AppTheme.buttonText,
    this.iconSize = AppTheme.iconSizeMedium,
    this.loadingIndicatorSize = 20,
  });

  ButtonConfiguration copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
    double? elevation,
    BorderSide? borderSide,
    double? height,
    double? paddingHorizontal,
    double? paddingVertical,
    TextStyle? textStyle,
    double? iconSize,
    double? loadingIndicatorSize,
  }) {
    return ButtonConfiguration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      borderSide: borderSide ?? this.borderSide,
      height: height ?? this.height,
      paddingHorizontal: paddingHorizontal ?? this.paddingHorizontal,
      paddingVertical: paddingVertical ?? this.paddingVertical,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      loadingIndicatorSize: loadingIndicatorSize ?? this.loadingIndicatorSize,
    );
  }
}
