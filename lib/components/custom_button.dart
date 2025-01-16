import 'package:flutter/material.dart';

import '../constants/custom_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGradient;
  final List<Color> gradientColors;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double? width;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.isGradient = false,
      this.gradientColors = const [CustomColor.green, CustomColor.blue],
      this.backgroundColor = Colors.grey,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      this.borderRadius = 24.0,
      this.textStyle = const TextStyle(color: Colors.white, fontSize: 15),
      this.borderColor,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isGradient
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(colors: gradientColors),
            )
          : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: borderColor ?? Colors.transparent),
          backgroundColor: isGradient ? Colors.transparent : backgroundColor,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
