import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_application_1/screens/reset_wallet_phrase_screen.dart';

import '../components/custom_text.dart';
import '../components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _passwordController = TextEditingController();
  bool isSwitched = false;

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      print('Toggle is ${isSwitched ? 'On' : 'Off'}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagePath.trueWalletLogo,
            width: 60,
            height: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomText(
            text: 'Welcome Back',
            style: CustomTextStyles.textTitle(
                color: CustomColor.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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
                    Center(
                      child: CustomButton(
                        text: 'Next',
                        onPressed: () {},
                        isGradient: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 10),
                        textStyle: CustomTextStyles.textHeading(
                            color: CustomColor.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: CustomText(
                          textAlign: TextAlign.center,
                          text: 'Wallet wont unlock? You can reset your wallet',
                          style: CustomTextStyles.textSubHeading(
                            color: CustomColor.grey,
                          ),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ResetWalletPhraseScreen()));
                        },
                        child: CustomText(
                          text: 'Reset Wallet',
                          style: CustomTextStyles.textSubHeading(
                            color: CustomColor.green,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
