import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_gradient_text.dart';
import '../components/custom_text.dart';
import '../components/custom_text_styles.dart';
import '../constants/custom_color.dart';

class ConfirmRecoveryPhraseScreen extends StatefulWidget {
  final List<String> seedPhrase;
  const ConfirmRecoveryPhraseScreen({required this.seedPhrase, super.key});

  @override
  State<ConfirmRecoveryPhraseScreen> createState() =>
      _ConfirmRecoveryPhraseScreenState();
}

class _ConfirmRecoveryPhraseScreenState
    extends State<ConfirmRecoveryPhraseScreen> {
  late List<String> shuffledPhrases;
  List<String> selectedPhrases = [];
  bool isOrderCorrect = false;

  @override
  void initState() {
    super.initState();
    shuffledPhrases = List.from(widget.seedPhrase);
    selectedPhrases = List.filled(widget.seedPhrase.length, '');
  }

  void selectPhrase(String phrase) {
    if (selectedPhrases.contains(phrase)) return;

    setState(() {
      int emptyIndex = selectedPhrases.indexOf('');
      if (emptyIndex != -1) {
        selectedPhrases[emptyIndex] = phrase;
        checkOrder();
      }
    });
  }

  void unselectPhrase(String phrase) {
    setState(() {
      int index = selectedPhrases.indexOf(phrase);
      if (index != -1) {
        for (int i = index; i < selectedPhrases.length - 1; i++) {
          selectedPhrases[i] = selectedPhrases[i + 1];
        }
        selectedPhrases[selectedPhrases.length - 1] = '';
        checkOrder();
      }
    });
  }

  void checkOrder() {
    List<String> filledPhrases =
        selectedPhrases.where((p) => p.isNotEmpty).toList();
    isOrderCorrect = false;

    if (filledPhrases.length == widget.seedPhrase.length) {
      isOrderCorrect = true;
      for (int i = 0; i < widget.seedPhrase.length; i++) {
        if (filledPhrases[i] != widget.seedPhrase[i]) {
          isOrderCorrect = false;
          break;
        }
      }
    }
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
          progressStatuses: const [true, true, true],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: CustomGradientText(
                  text: 'Confirm Secret Recovery Phrase',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CustomColor.green),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 6,
                    childAspectRatio: 3.5,
                  ),
                  itemCount: selectedPhrases.length,
                  itemBuilder: (context, index) {
                    final phrase = selectedPhrases[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: phrase.isEmpty
                            ? CustomColor.offWhite
                            : CustomColor.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: CustomColor.green),
                      ),
                      child: Center(
                        child: phrase.isEmpty
                            ? Text('${index + 1}.')
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '${index + 1}. $phrase',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => unselectPhrase(phrase),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Icon(Icons.close, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomText(
                        textAlign: TextAlign.center,
                        text:
                            'Select each word in the order it was presented to you.',
                        style: CustomTextStyles.textHeading(
                          fontWeight: FontWeight.bold,
                          color: CustomColor.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 6,
                          childAspectRatio: 3.2,
                        ),
                        itemCount: shuffledPhrases.length,
                        itemBuilder: (context, index) {
                          final phrase = shuffledPhrases[index];
                          final isSelected = selectedPhrases.contains(phrase);
                          return CustomButton(
                            text: phrase,
                            onPressed: () {
                              if (!isSelected) {
                                selectPhrase(phrase);
                              }
                            },
                            isGradient: false,
                            backgroundColor: isSelected
                                ? CustomColor.offWhite
                                : CustomColor.white,
                            borderRadius: 24.0,
                            borderColor: CustomColor.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            textStyle: TextStyle(
                              color: isSelected
                                  ? CustomColor.grey
                                  : CustomColor.black,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: () {
                          if (isOrderCorrect) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const HomeContentScreen()));
                          }
                        },
                        isGradient: isOrderCorrect,
                        borderRadius: 24.0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 7.0),
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
