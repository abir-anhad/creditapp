import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? prefix;
  final Widget? suffix;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.prefix,
    this.suffix,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : (backgroundColor ?? AppColors.primary),
          foregroundColor: isOutlined ? (backgroundColor ?? AppColors.primary) : (textColor ?? AppColors.white),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            side: isOutlined
                ? BorderSide(color: backgroundColor ?? AppColors.primary)
                : BorderSide.none,
          ),
          elevation: isOutlined ? 0 : null,
        ),
        child: isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isOutlined
                  ? (backgroundColor ?? AppColors.primary)
                  : (textColor ?? AppColors.white),
            ),
            strokeWidth: 2.0,
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefix != null) ...[
              prefix!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isOutlined
                    ? (backgroundColor ?? AppColors.primary)
                    : (textColor ?? AppColors.white),
              ),
            ),
            if (suffix != null) ...[
              const SizedBox(width: 8),
              suffix!,
            ],
          ],
        ),
      ),
    );
  }
}