import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/custom_color.dart';

class CustomGradientText extends StatelessWidget {
  final String? text;
  final TextStyle style;
  final List<Color> gradientColors;
  final TextAlign? textAlign;

  const CustomGradientText({
    Key? key,
    this.text,
    required this.style,
    this.textAlign,
    this.gradientColors = const [CustomColor.green, CustomColor.blue],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors,
      ).createShader(bounds),
      child: Text(
        textAlign: textAlign,
        text ?? '',
        style: style.copyWith(color: CustomColor.white),
      ),
    );
  }
}
