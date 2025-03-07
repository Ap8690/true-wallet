import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/confirm_recovery_phrase_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_gradient_text.dart';
import '../components/custom_text_styles.dart';
import '../constants/custom_color.dart';

class SecureYourWalletScreen extends StatefulWidget {
  const SecureYourWalletScreen({super.key});

  @override
  State<SecureYourWalletScreen> createState() => _SecureYourWalletScreenState();
}

class _SecureYourWalletScreenState extends State<SecureYourWalletScreen> {
  late WalletBloc walletBloc;
  List<String> recoveryPhrases = [];

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of(context);
    recoveryPhrases = generateRecoveryPhrases();
  }

  List<String> generateRecoveryPhrases() {
    List<String> phrases = walletBloc.wallet!.seedPhrase.split(" ");
    return phrases;
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
            progressStatuses: const [true, true, false],
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 2.8 / 7,
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
                        horizontal: 10.0, vertical: 6),
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
              height: MediaQuery.of(context).size.height * 1.4 / 6,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 10),
                    child: CustomText(
                      textAlign: TextAlign.left,
                      text:
                          'This is your Secret Recovery Phrase. Write it down on paper and keep it in a safe place. You\'ll be asked to re-enter this phrase (in order) on the next step.',
                      style: CustomTextStyles.textCommon(
                          fontWeight: FontWeight.normal,
                          color: CustomColor.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Center(
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ConfirmRecoveryPhraseScreen(
                                    seedPhrase: recoveryPhrases,
                                  )));
                        },
                        isGradient: true,
                        borderRadius: 24.0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 6.0),
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
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
