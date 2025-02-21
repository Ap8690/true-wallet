import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/components/custom_appbar.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_application_1/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/reset_wallet_phrase_screen.dart';
import 'package:flutter_application_1/services/secure_storage_service/secure_storage_service.dart';
import 'package:flutter_application_1/services/sharedpref/preference_service.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:flutter_application_1/services/wallet/models/wallet_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../components/custom_text.dart';
import '../components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final getIt = GetIt.I;
  late final PreferenceService preferenceService;
  late final WalletBloc walletBloc;
  late final AuthBloc authBloc;
  late final SecureStorageService secureStorageService;
  final TextEditingController _passwordController = TextEditingController();
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    preferenceService = getIt<PreferenceService>();
    secureStorageService = getIt<SecureStorageService>();
  }

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      print('Toggle is ${isSwitched ? 'On' : 'Off'}');
    });
  }

  void _initializeWallet(VerifyPinSuccess state) {
    final walletJson = jsonDecode(state.walletMetaString);
    final chainJson = jsonDecode(state.chainMetaString);

    walletBloc.add(
      InitializeWallet(
        wallet: CryptoWallet.fromJson(walletJson),
        chainList: ChainMetadata.fromJsonList(chainJson),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(40), child: CustomAppbar()),
      body: SingleChildScrollView(
        child: MultiBlocListener(
          listeners: [
            BlocListener<WalletBloc, WalletState>(
              listener: (context, state) {
                if (state is InitializeWalletSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeContentScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is VerifyPinLoading) {
                  print("loading...");
                  const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is VerifyPinSuccess) {
                  print("done");
                  _initializeWallet(state);
                } else if (state is VerifyPinFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wrong password. Please try again.'),
                      backgroundColor: CustomColor.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
          child: Column(
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
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
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
                              text: 'Unlock with Fingerprint ?',
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
                            onPressed: () {
                              authBloc.add(VerifyPin(_passwordController.text));
                            },
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: CustomText(
                              textAlign: TextAlign.center,
                              text:
                                  "Wallet won't unlock? You can reset your wallet",
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
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetWalletPhraseScreen()),
                                  (Route<dynamic> route) => false);
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
        ),
      ),
    );
  }
}
