import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelLarge.copyWith(
            color: _isFocused ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.paddingS),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            focusNode: widget.focusNode,
            textCapitalization: widget.textCapitalization,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              prefixText: widget.prefixText,
              suffixText: widget.suffixText,
              filled: true,
              fillColor: widget.fillColor ?? 
                  (_isFocused ? AppColors.surface : AppColors.surfaceVariant),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingM,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppDimensions.radiusM,
                ),
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.border,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppDimensions.radiusM,
                ),
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.border,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppDimensions.radiusM,
                ),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppDimensions.radiusM,
                ),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppDimensions.radiusM,
                ),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppDimensions.radiusM,
                ),
                borderSide: BorderSide(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }
}
