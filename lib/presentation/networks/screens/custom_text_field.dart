import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  final int length;
  final Widget? suffix;
  final String? hintText;
  final TextEditingController? controller;
  final Color borderColor;
  final double height;
  final bool isError;
  final Function(String)? onChange;
  final VoidCallback? onTap;
  final bool enabled;
  final FocusNode? focusNode;
  final bool focusOnTap;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final double? fontSize;
  final TextAlign textAlign;
  final TextInputType? inputType;
  const CustomTextfield({
    super.key,
    this.textInputAction,
    this.inputType,
    this.fontSize,
    this.suffix,
    this.height = 50,
    this.inputFormatters,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onTap,
    this.length=8,
    this.focusOnTap = true,
    this.borderColor = Colors.white,
    this.onChange,
    this.enabled = true,
    this.isError = false,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        textAlign: textAlign,
        maxLength: length,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        focusNode: focusNode,
        keyboardType: inputType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        onTap: onTap,
        enabled: enabled,
        controller: controller,
        showCursor: focusOnTap,
        readOnly: !focusOnTap,
        style: TextStyle(color: Colors.black, fontSize: fontSize),
        cursorColor: Colors.white,
        onChanged: onChange,
        decoration: InputDecoration(
          suffixIcon: suffix != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.white,
                        width: 2,
                        height: 30,
                      ),
                      SizedBox(
                        width: 5
                      ),
                      suffix!,
                    ],
                  ),
                )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: fontSize),
          counterText: "",
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
          errorText: isError ? '' : null,
          errorStyle: const TextStyle(fontSize: 0),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: borderColor,
            ),
          ),
        ),
      ),
    );
  }
}
