import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import '../constants/custom_color.dart';

class CustomSendTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? iconPath;
  final Function(String)? onChanged;
  final bool isPhoneNumber;
  final TextInputType keyboardType;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final int? maxLength;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final double focusedBorderWidth;
  final Color focusedBorderColor;
  final Color? borderColour;
  final bool isFullSize;
  final bool isPassword;
  final InputDecoration? decoration;
  final String? prefixText;

  const CustomSendTextField(
      {Key? key,
      this.controller,
      this.hintText,
      this.iconPath,
      this.onChanged,
      this.isPhoneNumber = false,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.focusNode,
      this.textAlign = TextAlign.start,
      this.maxLength,
      this.textStyle,
      this.onTap,
      this.onSubmitted,
      this.textInputAction,
      this.focusedBorderWidth = 2.0,
      this.focusedBorderColor = Colors.green,
      this.isFullSize = true,
      this.isPassword = false,
      this.decoration,
      this.prefixText,
      this.borderColour})
      : super(key: key);

  @override
  State<CustomSendTextField> createState() => _CustomSendTextFieldState();
}

class _CustomSendTextFieldState extends State<CustomSendTextField> {
  bool _isTextVisible = false;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 24;

    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: widget.focusNode,
            textAlign: widget.textAlign,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            controller: widget.controller,
            maxLength: widget.maxLength,
            keyboardType: widget.isPassword
                ? TextInputType.visiblePassword
                : widget.keyboardType,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            textInputAction: widget.textInputAction,
            onTap: widget.onTap,
            obscureText: widget.isPassword && !_isTextVisible,
            decoration: widget.decoration ??
                InputDecoration(
                  prefixText: widget.prefixText,
                  prefixStyle:
                      CustomTextStyles.textCommon(color: CustomColor.grey),
                  prefixIcon: widget.iconPath != null
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            widget.iconPath!,
                            height: 20,
                            width: 20,
                          ),
                        )
                      : null,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            _isTextVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: _isTextVisible
                                ? CustomColor.green
                                : CustomColor.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isTextVisible = !_isTextVisible;
                            });
                          },
                        )
                      : null,
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(color: Colors.black54),
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                        color: widget.borderColour ?? Colors.green, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                        color: widget.borderColour ?? Colors.green, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: widget.focusedBorderColor,
                      width: widget.focusedBorderWidth,
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
