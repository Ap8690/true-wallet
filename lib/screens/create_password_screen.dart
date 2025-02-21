import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_appbar.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_text_field.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/password_warning_screen.dart';
import 'package:flutter_application_1/services/secure_storage_service/secure_storage_service.dart';
import 'package:flutter_application_1/services/sharedpref/preference_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../components/custom_text.dart';
import '../constants/custom_color.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final getIt = GetIt.I;
  late PreferenceService preferenceService;
  late SecureStorageService secureStorageService;
  late WalletBloc walletBloc;
  late AuthBloc authBloc;
  bool isSwitched = false;
  bool isChecked = false;

  @override
  void initState() {
    walletBloc = BlocProvider.of(context);
    authBloc = BlocProvider.of(context);
    preferenceService = getIt<PreferenceService>();
    secureStorageService = getIt<SecureStorageService>();
    super.initState();
  }

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
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
          backgroundColor: CustomColor.red,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: CustomColor.red,
        ),
      );
      return;
    }

    authBloc.add(SetPin(
        pin: _confirmPasswordController.text,
        wallet: walletBloc.wallet!,
        chainList: walletBloc.chains));

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PasswordWarningScreen()));
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
            progressStatuses: const [true, false, false],
          )),
      body: SingleChildScrollView(
        child: Padding(
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                width: double.infinity,
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
      ),
    );
  }
}
