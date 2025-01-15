import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_gradient_text.dart';
import '../components/custom_text.dart';
import '../components/custom_text_styles.dart';
import '../constants/custom_color.dart';

class ConfirmRecoveryPhraseScreen extends StatefulWidget {
  const ConfirmRecoveryPhraseScreen({super.key});

  @override
  State<ConfirmRecoveryPhraseScreen> createState() =>
      _ConfirmRecoveryPhraseScreenState();
}

class _ConfirmRecoveryPhraseScreenState
    extends State<ConfirmRecoveryPhraseScreen> {
  List<String> recoveryPhrases = [];
  List<String> selectedPhrases = List.filled(12, '');
  int selectedCount = 0;

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
            progressStatuses: [true, true, true],
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const Center(
                child: CustomGradientText(
              text: 'Confirm Secret Recovery Phrase',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 2.6 / 7,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 6,
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
                        horizontal: 10.0, vertical: 5),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 10),
                      child: CustomText(
                        textAlign: TextAlign.center,
                        text:
                            'Select each word in the order it was presented to you.',
                        style: CustomTextStyles.textHeading(
                            fontWeight: FontWeight.bold,
                            color: CustomColor.black),
                      ),
                    ),
                    Flexible(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 6,
                          childAspectRatio: 3.7,
                        ),
                        itemCount: recoveryPhrases.length,
                        itemBuilder: (context, index) {
                          final isSelected =
                              selectedPhrases.contains(recoveryPhrases[index]);
                          return CustomButton(
                            text: '${index + 1}. ${recoveryPhrases[index]}',
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  selectedPhrases[selectedPhrases
                                      .indexOf(recoveryPhrases[index])] = '';
                                } else if (selectedCount < 12) {
                                  selectedPhrases[selectedPhrases.indexOf('')] =
                                      recoveryPhrases[index];
                                }
                                selectedCount = selectedPhrases
                                    .where((p) => p.isNotEmpty)
                                    .length;
                              });
                            },
                            isGradient: false,
                            backgroundColor: isSelected
                                ? CustomColor.green
                                : CustomColor.offWhite,
                            borderRadius: 24.0,
                            borderColor: CustomColor.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 6),
                            textStyle: const TextStyle(
                                color: CustomColor.black, fontSize: 14),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: CustomButton(
                          text: 'Continue',
                          onPressed: selectedCount == 12
                              ? () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                                }
                              : () {
                                  print('Selected Count: $selectedCount');
                                  print('Selected Phrases: $selectedPhrases');
                                },
                          isGradient: selectedCount == 12 ? true : false,
                          borderRadius: 24.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10.0),
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectPhrase(int index, String phrase) {
    setState(() {
      if (selectedPhrases[index].isEmpty) {
        selectedPhrases[index] = phrase;
      } else {
        selectedPhrases[index] = '';
      }
      selectedCount = selectedPhrases.where((p) => p.isNotEmpty).length;
    });
  }
}
