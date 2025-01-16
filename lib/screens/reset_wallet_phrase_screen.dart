import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import '../app.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_text.dart';
import '../components/custom_text_field.dart';
import '../constants/custom_color.dart';

class ResetWalletPhraseScreen extends StatefulWidget {
  const ResetWalletPhraseScreen({super.key});

  @override
  State<ResetWalletPhraseScreen> createState() =>
      _ResetWalletPhraseScreenState();
}

class _ResetWalletPhraseScreenState extends State<ResetWalletPhraseScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool isSwitched = false;
  List<String> recoveryPhrases = [];

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      print('Toggle is ${isSwitched ? 'On' : 'Off'}');
    });
  }

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
          preferredSize: const Size.fromHeight(100),
          child: CustomAppbar(
            toolBarHeight: 100,
            showCenterWidget: true,
            showBackWidget: true,
            onBackArrowTap: () => Navigator.of(context).pop(),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  child: CustomGradientText(
                textAlign: TextAlign.center,
                text: 'Import From Secret Recovery Phrase',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              )),
              const SizedBox(
                height: 16,
              ),
              CustomText(
                text: 'Secret Recovery Phrase',
                style: CustomTextStyles.textCommon(),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 2.3 / 7,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 6,
                    childAspectRatio: 3.9,
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
                      textStyle: const TextStyle(
                          color: CustomColor.black, fontSize: 16),
                    );
                  },
                ),
              ),
              CustomText(
                text: 'Password',
                style: CustomTextStyles.textSubHeading(
                    color: CustomColor.grey, fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 6,
              ),
              CustomTextField(
                controller: _passwordController,
                isFullSize: true,
                isPassword: true,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomText(
                text: 'Confirm Password',
                style: CustomTextStyles.textSubHeading(
                    color: CustomColor.grey, fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 6,
              ),
              CustomTextField(
                controller: _confirmPasswordController,
                isFullSize: true,
                isPassword: true,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'UnLock with Fingerprint ?',
                    style: CustomTextStyles.textCommon(
                        color: CustomColor.black, fontWeight: FontWeight.bold),
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
                height: 16,
              ),
              Center(
                child: CustomButton(
                  text: 'Continue',
                  isGradient: true,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeContentScreen()));
                  },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 6),
                  textStyle:
                      CustomTextStyles.textSubHeading(color: CustomColor.white),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
