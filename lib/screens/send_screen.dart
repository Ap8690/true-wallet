import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/confirm_transfer_screen.dart';

import '../components/custom_button.dart';
import '../components/custom_home_appbar.dart';
import '../components/custom_text.dart';
import '../components/custom_text_field.dart';
import '../components/custom_text_styles.dart';
import '../constants/custom_color.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final TextEditingController _senderAccountController =
      TextEditingController();
  final TextEditingController _receiverAccountController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final FocusNode _senderFocusNode = FocusNode();
  final FocusNode _receiverFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void dispose() {
    _senderAccountController.dispose();
    _receiverAccountController.dispose();
    _amountController.dispose();
    _senderFocusNode.dispose();
    _receiverFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomHomeAppbar(
            showBackWidget: false,
            centreText: 'Send',
            onBackTap: () => Navigator.of(context).pop(),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              text: "Your Balance",
              style: CustomTextStyles.textTitle(),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "827.97",
                  style:
                      CustomTextStyles.textHeading(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: CustomText(
                    text: 'Fit24',
                    style: CustomTextStyles.textHeading(
                        color: CustomColor.blue, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            CustomText(
              text: '\$ 56.37',
              style: CustomTextStyles.textHeading(color: CustomColor.green),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'From',
                  style: CustomTextStyles.textCommon(
                      color: CustomColor.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  prefixText: 'Account : ',
                  controller: _senderAccountController,
                  isFullSize: true,
                  isPassword: false,
                  borderColour: CustomColor.grey,
                  focusedBorderColor: CustomColor.grey,
                  focusNode: _senderFocusNode,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_receiverFocusNode);
                  },
                ),
                const SizedBox(height: 20),
                CustomText(
                  text: 'To',
                  style: CustomTextStyles.textCommon(
                      color: CustomColor.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  prefixText: 'Account : ',
                  controller: _receiverAccountController,
                  isFullSize: true,
                  isPassword: false,
                  borderColour: CustomColor.grey,
                  focusedBorderColor: CustomColor.grey,
                  focusNode: _receiverFocusNode,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              focusNode: _amountFocusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
              decoration: const InputDecoration(
                hintText: "",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            sendButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget sendButton() {
    return CustomButton(
      text: 'Send',
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ConfirmTransferScreen(
                  senderAccount: _senderAccountController.text,
                  receiverAccount: _receiverAccountController.text,
                  amount: _amountController.text,
                )));
      },
      isGradient: true,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      textStyle: CustomTextStyles.textCommon(color: CustomColor.white),
    );
  }
}
