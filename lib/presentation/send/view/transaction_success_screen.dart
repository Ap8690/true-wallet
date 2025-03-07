import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final String transactionHash;

  const TransactionSuccessScreen({
    Key? key,
    required this.transactionHash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: CustomColor.green,
              size: 80,
            ),
            const SizedBox(height: 20),
            CustomText(
              text: 'Transaction Hash',
              style: CustomTextStyles.textTitle(),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: transactionHash));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hash copied to clipboard'),
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
                        text: Helpers.formatLongString(transactionHash),
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
            const SizedBox(height: 40),
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeContentScreen(),
                  ),
                  (route) => false,
                );
                BlocProvider.of<WalletBloc>(context).add(const GetBalance());
              },
              isGradient: true,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              textStyle: CustomTextStyles.textCommon(color: CustomColor.white),
            ),
          ],
        ),
      ),
    );
  }
}
