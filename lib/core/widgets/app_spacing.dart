import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_colors.dart';

class AppSpacing {
  // Vertical Spacing
  static Widget verticalXS() => SizedBox(height: AppDimensions.paddingXS);
  static Widget verticalS() => SizedBox(height: AppDimensions.paddingS);
  static Widget verticalM() => SizedBox(height: AppDimensions.paddingM);
  static Widget verticalL() => SizedBox(height: AppDimensions.paddingL);
  static Widget verticalXL() => SizedBox(height: AppDimensions.paddingXL);
  static Widget verticalXXL() => SizedBox(height: AppDimensions.paddingXXL);
  
  // Horizontal Spacing
  static Widget horizontalXS() => SizedBox(width: AppDimensions.paddingXS);
  static Widget horizontalS() => SizedBox(width: AppDimensions.paddingS);
  static Widget horizontalM() => SizedBox(width: AppDimensions.paddingM);
  static Widget horizontalL() => SizedBox(width: AppDimensions.paddingL);
  static Widget horizontalXL() => SizedBox(width: AppDimensions.paddingXL);
  static Widget horizontalXXL() => SizedBox(width: AppDimensions.paddingXXL);
  
  // Custom Spacing
  static Widget vertical(double height) => SizedBox(height: height.h);
  static Widget horizontal(double width) => SizedBox(width: width.w);
  static Widget box({double? width, double? height}) => 
      SizedBox(width: width?.w, height: height?.h);
}

class AppDivider extends StatelessWidget {
  final double? height;
  final Color? color;
  final double? thickness;
  final EdgeInsetsGeometry? margin;

  const AppDivider({
    super.key,
    this.height,
    this.color,
    this.thickness,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Divider(
        height: height ?? AppDimensions.dividerHeight,
        thickness: thickness ?? AppDimensions.dividerThickness,
        color: color ?? AppColors.border,
      ),
    );
  }
}
