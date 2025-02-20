import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  late WalletBloc walletBloc;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final address = walletBloc.selectedAccount?.address ?? '';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomHomeAppbar(
          showBackWidget: false,
          centreText: 'Receive',
          onBackTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CustomText(
                text: "Scan QR Code",
                style: CustomTextStyles.textTitle(),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColor.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: QrImageView(
                    data: address,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomText(
                text: "Your Address",
                style: CustomTextStyles.textTitle(),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: address));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Address copied to clipboard'),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: Helpers.formatLongString(address),
                          style: CustomTextStyles.textCommon(
                            color: CustomColor.black,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.copy,
                        color: CustomColor.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 