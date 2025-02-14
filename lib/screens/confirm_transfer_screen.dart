import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';

import '../components/custom_gradient_text.dart';
import '../components/custom_home_appbar.dart';
import '../components/custom_text.dart';
import '../constants/custom_color.dart';

class ConfirmTransferScreen extends StatefulWidget {
  final String senderAccount;
  final String receiverAccount;
  final String amount;
  const ConfirmTransferScreen({
    super.key,
    required this.senderAccount,
    required this.receiverAccount,
    required this.amount,
  });

  @override
  State<ConfirmTransferScreen> createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: CustomHomeAppbar(
              showBackWidget: false,
              centreText: 'Confirm',
              onBackTap: () => Navigator.of(context).pop(),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            CustomText(
              text: 'Confirm Transaction information',
              style: CustomTextStyles.textLabel(color: CustomColor.grey),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomText(
              text: "You Send",
              style: CustomTextStyles.textTitle(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomGradientText(
                  text: "${widget.amount}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: CustomText(
                    text: 'Fit24',
                    style: CustomTextStyles.textHeading(
                        color: CustomColor.blue, fontWeight: FontWeight.bold),
                    // '${selectedcurrency['emoji']}${selectedCurrency['currency-code']!}',
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              text: '\$ 56.37',
              style: CustomTextStyles.textHeading(color: CustomColor.green),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Details',
                  style: CustomTextStyles.textSubHeading(
                      color: CustomColor.black, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'From',
                            style: CustomTextStyles.textCommon(
                                color: CustomColor.grey),
                          ),
                          CustomText(
                            text: widget.senderAccount,
                            style: CustomTextStyles.textCommon(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'To',
                            style: CustomTextStyles.textCommon(
                                color: CustomColor.grey),
                          ),
                          CustomText(
                            text: widget.receiverAccount,
                            style: CustomTextStyles.textCommon(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Transaction Fee (0.0%)',
                            style: CustomTextStyles.textCommon(
                                color: CustomColor.grey),
                          ),
                          CustomText(
                            text: '\$2.00',
                            style: CustomTextStyles.textCommon(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Amount',
                            style: CustomTextStyles.textCommon(
                                color: CustomColor.grey),
                          ),
                          CustomText(
                            text: '\$${widget.amount}',
                            style: CustomTextStyles.textCommon(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            confirmButton()
          ]),
        ));
  }

  Widget confirmButton() {
    return CustomButton(
      text: 'Confirm',
      onPressed: () {},
      isGradient: true,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      textStyle: CustomTextStyles.textCommon(color: CustomColor.white),
    );
  }
}
