import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';

import '../constants/custom_color.dart';
import 'custom_button.dart';
import 'custom_text.dart';
import 'custom_text_styles.dart';

class CustomInfoDialog {
  String? title;
  String? subTitle;
  String? imagePath;
  String? buttonText;
  String? buttontextRight;
  Function? cancel;
  Function? no;
  Function? ok;
  CustomInfoDialog(
      {required this.title,
      this.cancel,
      this.subTitle,
      this.no,
      this.ok,
      this.imagePath,
      this.buttontextRight,
      this.buttonText});
  void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return const Center();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - anim1.value)),
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      imagePath ?? '',
                      height: 60,
                      width: 60,
                    ),
                    const SizedBox(height: 16.0),
                    CustomGradientText(
                        text: title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomText(
                      text: subTitle,
                      maxLines: 3,
                      softWrap: true,
                      style: CustomTextStyles.textSubHeading(
                          color: CustomColor.grey,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cancel != null
                            ? CustomButton(
                                onPressed: () {
                                  cancel!();
                                },
                                text: buttonText ?? 'Cancel',
                                backgroundColor: CustomColor.grey,
                                textStyle: CustomTextStyles.textCommon(
                                    color: CustomColor.white),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 8,
                        ),
                        no != null
                            ? CustomButton(
                                onPressed: () {
                                  no!();
                                },
                                isGradient: true,
                                text: buttontextRight ?? '',
                                textStyle: CustomTextStyles.textCommon(
                                    color: CustomColor.white),
                              )
                            : const SizedBox(),
                        ok != null
                            ? ElevatedButton(
                                onPressed: () {
                                  ok!();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: CustomText(text: 'OK'),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
