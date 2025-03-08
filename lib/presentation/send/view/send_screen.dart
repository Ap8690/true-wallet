import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_field.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/core/helpers/media_query_helper.dart';
import 'package:flutter_application_1/presentation/send/view/confirm_transfer_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';

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

  late WalletBloc walletBloc;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
    _senderAccountController.text = walletBloc.selectedAccount?.address ?? '';
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CustomText(
                  text: "Your Balance",
                  style: CustomTextStyles.textTitle(),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                      children: [
                        CustomText(
                          text:
                              "${walletBloc.selectedAccount?.balance.toStringAsFixed(2) ?? 0} ${walletBloc.selectedToken.symbol}",
                          style: CustomTextStyles.textSubTitle(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          text: '+\$5 (+3.14%)',
                          style: CustomTextStyles.textLabel(
                              color: CustomColor.grey,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
              const SizedBox(height: 30),
              _accountField('From', _senderAccountController, _senderFocusNode,
                  _receiverFocusNode),
              const SizedBox(height: 20),
              _accountField('To', _receiverAccountController,
                  _receiverFocusNode, _amountFocusNode),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        SizedBox(
                          width: MediaQueryHelper.getWidth(context) * 0.3,
                          child: TextField(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32
                            ),
                            decoration: const InputDecoration(
                              hintText: "0.00",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          
                          width: MediaQueryHelper.getWidth(context) * 0.3,
                          child: Text(
                            walletBloc.selectedToken.symbol,
                            style: const TextStyle(
                              color: CustomColor.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 32
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 40),
              Center(child: _confirmButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountField(String label, TextEditingController controller,
      FocusNode focusNode, FocusNode? nextFocusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          style: CustomTextStyles.textCommon(
              color: CustomColor.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          prefixText: 'Account : ',
          controller: controller,
          isFullSize: true,
          isPassword: false,
          borderColour: CustomColor.grey,
          focusedBorderColor: CustomColor.grey,
          focusNode: focusNode,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
      ],
    );
  }

  Widget _confirmButton() {
    return CustomButton(
      text: 'Continue',
      onPressed: () {
        if (_amountController.text.isNotEmpty &&
            _receiverAccountController.text.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmTransferScreen(
                senderAccount: _senderAccountController.text,
                receiverAccount: _receiverAccountController.text,
                amount: _amountController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all fields'),
            ),
          );
        }
      },
      isGradient: true,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      textStyle: CustomTextStyles.textCommon(color: CustomColor.white),
    );
  }
}
