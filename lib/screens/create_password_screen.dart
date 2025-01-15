import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_appbar.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_text_field.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/screens/password_warning_screen.dart';

import '../components/custom_text.dart';
import '../constants/custom_color.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool isSwitched = false;
  bool isChecked = false;

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      print('Toggle is ${isSwitched ? 'On' : 'Off'}');
    });
  }

  void toggleCheckBox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  void onButtonPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PasswordWarningScreen()));
  }

  void doNothing() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: CustomAppbar(
            toolBarHeight: 140,
            showCenterWidget: true,
            showBackWidget: true,
            onBackArrowTap: () => Navigator.of(context).pop(),
            showProgressBars: true,
            progressStatuses: [true, false, false],
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Center(
              child: CustomGradientText(
                  text: 'Create Password',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: CustomText(
                textAlign: TextAlign.center,
                text:
                    'This password will unlock your wallet only on this device',
                style: CustomTextStyles.textHeading(
                  color: CustomColor.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Password',
                      style: CustomTextStyles.textSubHeading(
                          color: CustomColor.grey,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      isFullSize: true,
                      isPassword: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      text: 'Confirm Password',
                      style: CustomTextStyles.textSubHeading(
                          color: CustomColor.grey,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      isFullSize: true,
                      isPassword: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomText(
                      text: 'Password must be at least 8 characters long',
                      style: CustomTextStyles.textCommon(
                          color: CustomColor.grey,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'UnLock with Fingerprint ?',
                          style: CustomTextStyles.textCommon(
                              color: CustomColor.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Switch(
                          value: isSwitched,
                          onChanged: toggleSwitch,
                          activeTrackColor: CustomColor.green,
                          activeColor: CustomColor.white,
                          inactiveThumbColor: CustomColor.grey,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: toggleCheckBox,
                          activeColor: CustomColor.blue,
                        ),
                        Expanded(
                          child: CustomText(
                            text:
                                'I understand that this wallet cannot recover the password for me',
                            style: CustomTextStyles.textSubHeading(
                                color: CustomColor.grey,
                                fontWeight: FontWeight.normal),
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: CustomButton(
                        text: 'Next',
                        isGradient: isChecked,
                        onPressed: isChecked ? onButtonPressed : doNothing,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 10),
                        textStyle: CustomTextStyles.textSubHeading(
                            color: CustomColor.white),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
