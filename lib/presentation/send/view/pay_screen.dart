import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_field.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final TextEditingController _senderAccountController =
      TextEditingController();
  final TextEditingController _receiverAccountController =
      TextEditingController();
  final FocusNode _senderFocusNode = FocusNode();
  final FocusNode _receiverFocusNode = FocusNode();
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
    _senderFocusNode.dispose();
    _receiverFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomHomeAppbar(
          showBackWidget: false,
          centreAsset: ImagePath.trueWallet,
          onBackTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _accountField('From', _senderAccountController, _senderFocusNode,
                  _receiverFocusNode),
              const SizedBox(height: 20),
              _accountField(
                  'To', _receiverAccountController, _receiverFocusNode, null),
              const SizedBox(height: 20),
              _detailsContainer(),
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
            } else {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ],
    );
  }

  Widget _detailsContainer() {
    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Details',
            style: CustomTextStyles.textSubHeading(color: CustomColor.grey),
          ),
          const SizedBox(height: 20),
          _detailSection([
            _detailRow('Estimated Fee', '0.014597', CustomColor.grey),
            const SizedBox(height: 30),
            _doubleDetailRow('Market', '0.014597', CustomColor.green, 'Max Fee',
                '0.014597 BFit', CustomColor.black),
          ]),
          const SizedBox(height: 30),
          _detailSection([
            _detailRow('Total', '0.014597', CustomColor.grey),
            const SizedBox(height: 30),
            _doubleDetailRow('Amount + ', 'gas fee', CustomColor.green,
                'Max Amount', '0.014597 BFit', CustomColor.black),
          ]),
          const SizedBox(height: 30),
          rejectConfirmButtons(),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _detailSection(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _detailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          style: CustomTextStyles.textLabel(
              color: CustomColor.black, fontWeight: FontWeight.normal),
        ),
        CustomText(
          text: value,
          style: CustomTextStyles.textLabel(
              color: valueColor, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _doubleDetailRow(String label1, String value1, Color color1,
      String label2, String value2, Color color2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomText(
              text: label1,
              style: CustomTextStyles.textLabel(
                  color: CustomColor.grey, fontWeight: FontWeight.normal),
            ),
            const SizedBox(width: 4),
            CustomText(
              text: value1,
              style: CustomTextStyles.textLabel(
                  color: color1, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Row(
          children: [
            CustomText(
              text: label2,
              style: CustomTextStyles.textLabel(
                  color: CustomColor.grey, fontWeight: FontWeight.normal),
            ),
            const SizedBox(width: 4),
            CustomText(
              text: value2,
              style: CustomTextStyles.textLabel(
                  color: color2, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }

  rejectConfirmButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Reject',
            onPressed: () {},
            isGradient: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            textStyle: CustomTextStyles.textCommon(color: CustomColor.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomButton(
            text: ' Confirm ',
            onPressed: () {},
            isGradient: false,
            backgroundColor: CustomColor.grey,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: CustomTextStyles.textSubLabel(color: CustomColor.white),
          ),
        ),
      ],
    );
  }
}
