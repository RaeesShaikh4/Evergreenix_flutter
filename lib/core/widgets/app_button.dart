import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

enum AppButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.height,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? AppDimensions.buttonHeightM,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (type) {
      case AppButtonType.primary:
        return _buildPrimaryButton();
      case AppButtonType.secondary:
        return _buildSecondaryButton();
      case AppButtonType.outline:
        return _buildOutlineButton();
      case AppButtonType.text:
        return _buildTextButton();
    }
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? AppColors.textOnPrimary,
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.radiusM,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.secondary,
        foregroundColor: textColor ?? AppColors.textOnPrimary,
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.radiusM,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlineButton() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        side: BorderSide(
          color: backgroundColor ?? AppColors.primary,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.radiusM,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.radiusM,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 20.w,
        height: 20.h,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.outline || type == AppButtonType.text
                ? (textColor ?? AppColors.primary)
                : AppColors.textOnPrimary,
          ),
        ),
      );
    }

    final textStyle = AppTextStyles.buttonMedium.copyWith(
      color: textColor,
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconS, color: textColor),
          SizedBox(width: AppDimensions.paddingS),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }
}
