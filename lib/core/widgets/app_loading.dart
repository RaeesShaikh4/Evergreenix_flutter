import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppLoading extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? strokeWidth;

  const AppLoading({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 24.w,
      height: size ?? 24.h,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingText;
  final Color? backgroundColor;

  const AppLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? AppColors.shadow,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppLoading(
                    size: 32.w,
                    strokeWidth: 3,
                  ),
                  if (loadingText != null) ...[
                    SizedBox(height: AppDimensions.paddingM),
                    Text(
                      loadingText!,
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class AppShimmer extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor ?? AppColors.borderLight,
                widget.highlightColor ?? AppColors.border,
                widget.baseColor ?? AppColors.borderLight,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
