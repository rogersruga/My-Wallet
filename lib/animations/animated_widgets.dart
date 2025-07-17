import 'package:flutter/material.dart';
import 'animation_utils.dart';

/// Animated success icon with scale and bounce effects
class AnimatedSuccessIcon extends StatefulWidget {
  final double size;
  final Color color;
  final Duration delay;
  final VoidCallback? onAnimationComplete;

  const AnimatedSuccessIcon({
    super.key,
    this.size = 80,
    this.color = Colors.green,
    this.delay = Duration.zero,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedSuccessIcon> createState() => _AnimatedSuccessIconState();
}

class _AnimatedSuccessIconState extends State<AnimatedSuccessIcon>
    with TickerProviderStateMixin, AnimationControllerMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = createAnimationController(
      duration: AnimationUtils.slowDuration,
    );
    
    _scaleAnimation = _scaleController.curvedTween(
      AnimationUtils.scaleStart,
      AnimationUtils.scaleEnd,
      AnimationUtils.bounceCurve,
    );

    _scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      _scaleController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            Icons.check_circle,
            size: widget.size,
            color: widget.color,
          ),
        );
      },
    );
  }
}

/// Animated text with fade and slide effects
class AnimatedSlideText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration delay;
  final TextAlign textAlign;

  const AnimatedSlideText({
    super.key,
    required this.text,
    this.style,
    this.delay = Duration.zero,
    this.textAlign = TextAlign.center,
  });

  @override
  State<AnimatedSlideText> createState() => _AnimatedSlideTextState();
}

class _AnimatedSlideTextState extends State<AnimatedSlideText>
    with TickerProviderStateMixin, AnimationControllerMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = createAnimationController(
      duration: AnimationUtils.normalDuration,
    );

    _slideAnimation = _slideController.curvedTween(
      const Offset(0, 0.5),
      Offset.zero,
      AnimationUtils.smoothCurve,
    );

    _fadeAnimation = _slideController.curved(AnimationUtils.defaultCurve);

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      _slideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              widget.text,
              style: widget.style,
              textAlign: widget.textAlign,
            ),
          ),
        );
      },
    );
  }
}

/// Pulsing animation widget
class PulsingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final bool autoStart;

  const PulsingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minOpacity = 0.6,
    this.maxOpacity = 1.0,
    this.autoStart = true,
  });

  @override
  State<PulsingWidget> createState() => _PulsingWidgetState();
}

class _PulsingWidgetState extends State<PulsingWidget>
    with TickerProviderStateMixin, AnimationControllerMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = createAnimationController(
      duration: widget.duration,
    );

    _pulseAnimation = _pulseController.curvedTween(
      widget.minOpacity,
      widget.maxOpacity,
      Curves.easeInOut,
    );

    if (widget.autoStart) {
      _pulseController.repeat(reverse: true);
    }
  }

  void startPulsing() {
    _pulseController.repeat(reverse: true);
  }

  void stopPulsing() {
    _pulseController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}



/// Animated progress indicator
class AnimatedProgressIndicator extends StatefulWidget {
  final double progress;
  final Duration duration;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
    this.duration = AnimationUtils.normalDuration,
    this.color,
    this.backgroundColor,
    this.height = 4.0,
  });

  @override
  State<AnimatedProgressIndicator> createState() => _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with TickerProviderStateMixin, AnimationControllerMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = createAnimationController(
      duration: widget.duration,
    );

    _progressAnimation = _progressController.curvedTween(
      0.0,
      widget.progress,
      AnimationUtils.smoothCurve,
    );

    _progressController.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: AnimationUtils.smoothCurve,
      ));
      _progressController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _progressAnimation.value,
          color: widget.color,
          backgroundColor: widget.backgroundColor,
          minHeight: widget.height,
        );
      },
    );
  }
}

/// Staggered fade-in animation for multiple children
class StaggeredFadeIn extends StatelessWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration animationDuration;
  final Axis direction;

  const StaggeredFadeIn({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.animationDuration = AnimationUtils.normalDuration,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final delay = staggerDelay * index;

        return AnimatedFadeInWidget(
          delay: delay,
          duration: animationDuration,
          child: child,
        );
      }).toList(),
    );
  }
}

/// Simple fade-in animation widget
class AnimatedFadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedFadeInWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AnimationUtils.normalDuration,
  });

  @override
  State<AnimatedFadeInWidget> createState() => _AnimatedFadeInWidgetState();
}

class _AnimatedFadeInWidgetState extends State<AnimatedFadeInWidget>
    with TickerProviderStateMixin, AnimationControllerMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = createAnimationController(
      duration: widget.duration,
    );

    _fadeAnimation = _fadeController.curved(AnimationUtils.defaultCurve);

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
