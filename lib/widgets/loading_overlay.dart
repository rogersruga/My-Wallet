import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable loading overlay widget
class LoadingOverlay extends StatelessWidget {
  /// Whether the loading overlay is visible
  final bool isLoading;
  
  /// The child widget to display behind the overlay
  final Widget child;
  
  /// Custom loading message
  final String? message;
  
  /// Custom loading widget
  final Widget? loadingWidget;
  
  /// Background color of the overlay
  final Color? overlayColor;
  
  /// Whether the overlay can be dismissed by tapping
  final bool dismissible;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.loadingWidget,
    this.overlayColor,
    this.dismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: GestureDetector(
              onTap: dismissible ? () {} : null,
              child: Container(
                color: overlayColor ?? Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: loadingWidget ?? _buildDefaultLoadingWidget(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentOrange),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spacingM),
            Text(
              message!,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A specialized loading overlay for transfer operations
class TransferLoadingOverlay extends StatefulWidget {
  /// Whether the loading overlay is visible
  final bool isLoading;
  
  /// The child widget to display behind the overlay
  final Widget child;
  
  /// The current step in the transfer process
  final TransferStep currentStep;

  const TransferLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.currentStep = TransferStep.processing,
  });

  @override
  State<TransferLoadingOverlay> createState() => _TransferLoadingOverlayState();
}

class _TransferLoadingOverlayState extends State<TransferLoadingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isLoading) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TransferLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: widget.isLoading,
      child: widget.child,
      loadingWidget: _buildTransferLoadingWidget(),
    );
  }

  Widget _buildTransferLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    size: 40,
                    color: AppTheme.accentOrange,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            _getStepTitle(widget.currentStep),
            style: AppTheme.headingSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            _getStepDescription(widget.currentStep),
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingL),
          const LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentOrange),
            backgroundColor: AppTheme.borderSecondary,
          ),
        ],
      ),
    );
  }

  String _getStepTitle(TransferStep step) {
    switch (step) {
      case TransferStep.validating:
        return 'Validating Transfer';
      case TransferStep.processing:
        return 'Processing Transfer';
      case TransferStep.confirming:
        return 'Confirming Transaction';
      case TransferStep.completing:
        return 'Completing Transfer';
    }
  }

  String _getStepDescription(TransferStep step) {
    switch (step) {
      case TransferStep.validating:
        return 'Checking recipient details and account balance...';
      case TransferStep.processing:
        return 'Securely processing your money transfer...';
      case TransferStep.confirming:
        return 'Confirming transaction with payment provider...';
      case TransferStep.completing:
        return 'Finalizing transfer and sending confirmation...';
    }
  }
}

/// Enum for transfer steps
enum TransferStep {
  validating,
  processing,
  confirming,
  completing,
}

/// A simple loading button that shows loading state
class LoadingButton extends StatelessWidget {
  /// Whether the button is in loading state
  final bool isLoading;
  
  /// The button text
  final String text;
  
  /// The loading text
  final String? loadingText;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Button style
  final ButtonStyle? style;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.text,
    this.loadingText,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textPrimary),
                  ),
                ),
                if (loadingText != null) ...[
                  const SizedBox(width: AppTheme.spacingS),
                  Text(loadingText!),
                ],
              ],
            )
          : Text(text),
    );
  }
}
