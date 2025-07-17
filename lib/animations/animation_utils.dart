import 'package:flutter/material.dart';

/// Utility class for common animation configurations and curves
class AnimationUtils {
  // Private constructor to prevent instantiation
  AnimationUtils._();

  // Animation durations
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 400);
  static const Duration slowDuration = Duration(milliseconds: 800);
  static const Duration extraSlowDuration = Duration(milliseconds: 1200);

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutCubic;
  static const Curve sharpCurve = Curves.easeInCubic;

  // Common animation values
  static const double scaleStart = 0.5;
  static const double scaleEnd = 1.0;
  static const double opacityStart = 0.0;
  static const double opacityEnd = 1.0;
  static const double pulseMin = 0.6;
  static const double pulseMax = 1.0;

  /// Check if reduced motion is enabled for accessibility
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get animation duration based on accessibility settings
  static Duration getAnimationDuration(BuildContext context, Duration defaultDuration) {
    return shouldReduceMotion(context) ? Duration.zero : defaultDuration;
  }

  /// Create a slide transition from right to left
  static SlideTransition slideFromRight(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: defaultCurve,
      )),
      child: child,
    );
  }

  /// Create a slide transition from left to right
  static SlideTransition slideFromLeft(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: defaultCurve,
      )),
      child: child,
    );
  }

  /// Create a slide transition from bottom to top
  static SlideTransition slideFromBottom(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: defaultCurve,
      )),
      child: child,
    );
  }

  /// Create a fade transition
  static FadeTransition fadeTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Create a scale transition
  static ScaleTransition scaleTransition(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  /// Create a combined fade and scale transition
  static Widget fadeScaleTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  /// Create a shake animation transform
  static Transform shakeTransform(Animation<double> animation, Widget child) {
    return Transform.translate(
      offset: Offset(
        animation.value * 10 * (animation.value > 0.5 ? 1 : -1),
        0,
      ),
      child: child,
    );
  }
}

/// Custom page route builder for smooth transitions
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  CustomPageRoute({
    required this.child,
    this.transitionType = PageTransitionType.slideRight,
    this.duration = AnimationUtils.normalDuration,
    this.curve = AnimationUtils.defaultCurve,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    switch (transitionType) {
      case PageTransitionType.slideRight:
        return AnimationUtils.slideFromRight(curvedAnimation, child);
      case PageTransitionType.slideLeft:
        return AnimationUtils.slideFromLeft(curvedAnimation, child);
      case PageTransitionType.slideUp:
        return AnimationUtils.slideFromBottom(curvedAnimation, child);
      case PageTransitionType.fade:
        return AnimationUtils.fadeTransition(curvedAnimation, child);
      case PageTransitionType.scale:
        return AnimationUtils.scaleTransition(curvedAnimation, child);
      case PageTransitionType.fadeScale:
        return AnimationUtils.fadeScaleTransition(curvedAnimation, child);
    }
  }
}

/// Enum for different page transition types
enum PageTransitionType {
  slideRight,
  slideLeft,
  slideUp,
  fade,
  scale,
  fadeScale,
}

/// Mixin for managing animation controllers with proper disposal
mixin AnimationControllerMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  final List<AnimationController> _controllers = [];

  /// Create and register an animation controller
  AnimationController createAnimationController({
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
    double? value,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  }) {
    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      value: value,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: this,
    );
    _controllers.add(controller);
    return controller;
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }
}

/// Extension for easy animation creation
extension AnimationExtensions on AnimationController {
  /// Create a curved animation
  Animation<double> curved(Curve curve) {
    return CurvedAnimation(parent: this, curve: curve);
  }

  /// Create a tween animation
  Animation<T> tween<T>(T begin, T end) {
    return Tween<T>(begin: begin, end: end).animate(this);
  }

  /// Create a curved tween animation
  Animation<T> curvedTween<T>(T begin, T end, Curve curve) {
    return Tween<T>(begin: begin, end: end).animate(
      CurvedAnimation(parent: this, curve: curve),
    );
  }
}
