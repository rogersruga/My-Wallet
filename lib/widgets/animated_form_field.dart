import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'custom_text_field.dart';

/// Animated wrapper for form fields with validation animations
class AnimatedFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool enabled;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;

  const AnimatedFormField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.isRequired = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.enabled = true,
    this.onChanged,
    this.onEditingComplete,
    this.focusNode,
  });

  @override
  State<AnimatedFormField> createState() => _AnimatedFormFieldState();
}

class _AnimatedFormFieldState extends State<AnimatedFormField>
    with TickerProviderStateMixin {
  final GlobalKey<_ShakeWidgetState> _shakeKey = GlobalKey<_ShakeWidgetState>();
  String? _lastError;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      key: _shakeKey,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: _hasError
              ? Border.all(color: AppTheme.errorRed, width: 2)
              : null,
        ),
        child: CustomTextField(
          controller: widget.controller,
          label: widget.label,
          hint: widget.hint,
          isRequired: widget.isRequired,
          validator: _validateWithAnimation,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLength: widget.maxLength,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          onSuffixIconPressed: widget.onSuffixIconPressed,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          focusNode: widget.focusNode,
        ),
      ),
    );
  }

  String? _validateWithAnimation(String? value) {
    final error = widget.validator?.call(value);
    
    // Check if this is a new error
    if (error != null && error != _lastError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _shakeKey.currentState?.shake();
        setState(() {
          _hasError = true;
        });
        
        // Remove error styling after animation
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _hasError = false;
            });
          }
        });
      });
    } else if (error == null) {
      setState(() {
        _hasError = false;
      });
    }
    
    _lastError = error;
    return error;
  }
}

/// Enhanced shake widget with better control
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final int shakeCount;

  const ShakeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.offset = 8.0,
    this.shakeCount = 3,
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void shake() {
    if (!_shakeController.isAnimating) {
      _shakeController.forward().then((_) {
        _shakeController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final sineValue =
            math.sin(widget.shakeCount * 2 * math.pi * _shakeAnimation.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.offset, 0),
          child: widget.child,
        );
      },
    );
  }
}

/// Animated error message widget
class AnimatedErrorMessage extends StatefulWidget {
  final String? errorMessage;
  final Duration animationDuration;

  const AnimatedErrorMessage({
    super.key,
    this.errorMessage,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedErrorMessage> createState() => _AnimatedErrorMessageState();
}

class _AnimatedErrorMessageState extends State<AnimatedErrorMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.errorMessage != null) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedErrorMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.errorMessage != null && oldWidget.errorMessage == null) {
      _controller.forward();
    } else if (widget.errorMessage == null && oldWidget.errorMessage != null) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.errorMessage == null) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(top: AppTheme.spacingXS),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingS,
            vertical: AppTheme.spacingXS,
          ),
          decoration: BoxDecoration(
            color: AppTheme.errorRed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
            border: Border.all(
              color: AppTheme.errorRed.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
                size: 16,
                color: AppTheme.errorRed,
              ),
              const SizedBox(width: AppTheme.spacingXS),
              Expanded(
                child: Text(
                  widget.errorMessage!,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.errorRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
