import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final bool isClickable;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.onTap,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      padding: padding ?? EdgeInsets.all(AppDimensions.cardPadding),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.cardRadius,
        ),
        border: border,
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (isClickable || onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.cardRadius,
          ),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}

class AppCardWithHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final double? borderRadius;

  const AppCardWithHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.action,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      margin: margin,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppDimensions.cardPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (action != null) action!,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: padding ?? EdgeInsets.all(AppDimensions.cardPadding),
            child: child,
          ),
        ],
      ),
    );
  }
}
