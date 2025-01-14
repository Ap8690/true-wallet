import 'package:flutter/material.dart';

import '../constants/custom_color.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final TextStyle? style;

  CustomText({
    this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? 'No text provided',
      textAlign: textAlign ?? TextAlign.start,
      style: style,
      overflow: maxLines != null ? (overflow ?? TextOverflow.ellipsis) : null,
      softWrap: softWrap ?? true,
      maxLines: maxLines,
    );
  }
}
