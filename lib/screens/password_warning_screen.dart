import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_application_1/screens/secure_your_wallet_screen.dart';

import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import 'create_password_screen.dart';

class PasswordWarningScreen extends StatefulWidget {
  const PasswordWarningScreen({super.key});

  @override
  State<PasswordWarningScreen> createState() => _PasswordWarningScreenState();
}

class _PasswordWarningScreenState extends State<PasswordWarningScreen> {
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
            progressStatuses: [true, true, false],
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Center(
              child: CustomGradientText(
                  text: 'Secure your wallet',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 2 / 5,
              child: Image.asset(
                ImagePath.passwordFrame,
                fit: BoxFit.fill,
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          style: CustomTextStyles.textHeading(
                              color: CustomColor.grey,
                              fontWeight: FontWeight.normal),
                          children: [
                            TextSpan(
                                text:
                                    'Dont risk losing your funds. Protect your wallet by saving your '),
                            TextSpan(
                                text: 'Secret Recovery Phrase',
                                style: CustomTextStyles.textHeading(
                                    color: CustomColor.green,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              text:
                                  ' it’s the only way to recover your wallet if you get locked out of the app or get a new device.',
                              style: CustomTextStyles.textHeading(
                                  color: CustomColor.grey,
                                  fontWeight: FontWeight.normal),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Later',
                            onPressed: () {},
                            isGradient: false,
                            backgroundColor: CustomColor.grey,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            textStyle: CustomTextStyles.textCommon(
                                color: CustomColor.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomButton(
                            text: 'Start',
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SecureYourWalletScreen())),
                            isGradient: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            textStyle: CustomTextStyles.textSubLabel(
                                color: CustomColor.white),
                          ),
                        ),
                      ],
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
