import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../components/custom_gradient_indicator.dart';
import '../components/custom_text_field.dart';
import '../constants/custom_color.dart';
import '../constants/image_path.dart';

class ExportPrivateKeyScreen extends StatefulWidget {
  const ExportPrivateKeyScreen({super.key});

  @override
  State<ExportPrivateKeyScreen> createState() => _ExportPrivateKeyScreenState();
}

class _ExportPrivateKeyScreenState extends State<ExportPrivateKeyScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _passwordController = TextEditingController();
  late TabController _tabController;
  late WalletBloc walletBloc;
  late AuthBloc authBloc;
  bool showTabBarView = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    walletBloc = BlocProvider.of<WalletBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is VerifyPinLoading) {
          setState(() => isLoading = true);
        } else if (state is VerifyPinSuccess) {
          setState(() {
            isLoading = false;
            showTabBarView = true;
          });
        } else if (state is VerifyPinFailure) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid password'),
              backgroundColor: CustomColor.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomHomeAppbar(
            showBackWidget: true,
            showTrailingWidget: true,
            onTrailingTap: () {},
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const CustomGradientText(
                      text: 'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: CustomColor.grey,
                  ),
                  const SizedBox(width: 5),
                  const CustomGradientText(
                    text: 'Export Private Key',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              CustomText(
                  text: 'Save it somewhere safe and secret',
                  style: CustomTextStyles.textCommon(color: CustomColor.grey)),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: CustomColor.lightRed,
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(color: CustomColor.red, width: 1),
                ),
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
                  child: Row(
                    children: [
                      Image.asset(
                        ImagePath.eyeRed,
                        height: 40,
                        width: 55,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomText(
                          text:
                              'Never disclose this key. Anyone with your private key can fully control your account, including transferring away any of your funds',
                          maxLines: 4,
                          softWrap: true,
                          style: CustomTextStyles.textCommon(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!showTabBarView) ...[
                // Password verification UI
                CustomText(
                  text: 'Enter your password to continue',
                  style: CustomTextStyles.textCommon(color: CustomColor.grey),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  isFullSize: true,
                ),
                const SizedBox(height: 50),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.of(context).pop(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 10),
                        ),
                        const SizedBox(width: 20),
                        CustomButton(
                          text: 'Continue',
                          onPressed: () {
                            authBloc.add(VerifyPin(_passwordController.text));
                          },
                          isGradient: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 10),
                        ),
                      ],
                    ),
                  ),
              ] else ...[
                // Keys and QR display UI after verification
                TabBar(
                  controller: _tabController,
                  indicatorColor: CustomColor.blue,
                  tabs: const [
                    Tab(text: 'Private Key'),
                    Tab(text: 'Public Key'),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildKeyDisplay(
                        walletBloc.selectedAccount!.keyPair.privateKey ?? '',
                        isPrivate: true,
                      ),
                      _buildKeyDisplay(
                        walletBloc.selectedAccount?.address ?? '',
                        isPrivate: false,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyDisplay(String key, {required bool isPrivate}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColor.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: QrImageView(
              data: key,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: key));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${isPrivate ? "Private" : "Public"} key copied'),
                  backgroundColor: CustomColor.blue,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: CustomColor.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: key,
                      style: CustomTextStyles.textCommon(),
                      maxLines: 2,
                    ),
                  ),
                  const Icon(Icons.copy, color: CustomColor.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
