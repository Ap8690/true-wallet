import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/screens/confirm_recovery_phrase_screen.dart';

import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_gradient_text.dart';
import '../components/custom_text_styles.dart';
import '../constants/custom_color.dart'; // Assuming this is the correct path

class SecureYourWalletScreen extends StatefulWidget {
  const SecureYourWalletScreen({super.key});

  @override
  State<SecureYourWalletScreen> createState() => _SecureYourWalletScreenState();
}

class _SecureYourWalletScreenState extends State<SecureYourWalletScreen> {
  List<String> recoveryPhrases = [];

  @override
  void initState() {
    super.initState();
    recoveryPhrases = generateRecoveryPhrases();
  }

  List<String> generateRecoveryPhrases() {
    final List<String> phrases = [
      'Orphan',
      'Fetch',
      'Mail',
      'Plunge',
      'Shiver',
      'Hammer',
      'System',
      'Symbol',
      'Senior',
      'Vast',
      'North',
      'Huge',
      'Garden',
      'Artist',
      'Market',
      'Dancer',
      'Basket',
      'Night',
      'Island',
      'Ocean',
      'Forest',
      'Mountain',
      'River',
      'Valley',
    ];

    phrases.shuffle();
    return phrases.take(12).toList();
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
                child: CustomGradientText(
              text: 'Secure your wallet',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 3 / 7,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3.5,
                ),
                itemCount: recoveryPhrases.length,
                itemBuilder: (context, index) {
                  return CustomButton(
                    text: '${index + 1}. ${recoveryPhrases[index]}',
                    onPressed: () {},
                    isGradient: false,
                    backgroundColor: CustomColor.offWhite,
                    borderRadius: 24.0,
                    borderColor: CustomColor.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8),
                    textStyle:
                        const TextStyle(color: CustomColor.black, fontSize: 16),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 1.5 / 5,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 20),
                    child: CustomText(
                      textAlign: TextAlign.left,
                      text:
                          'This is your Secret Recovery Phrase. Write it down on paper and keep it in a safe place. You\'ll be asked to re-enter this phrase (in order) on the next step.',
                      style: CustomTextStyles.textHeading(
                          fontWeight: FontWeight.normal,
                          color: CustomColor.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Center(
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ConfirmRecoveryPhraseScreen()));
                        },
                        isGradient: true,
                        borderRadius: 24.0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10.0),
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
