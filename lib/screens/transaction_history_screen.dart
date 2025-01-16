import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';

import '../components/custom_text.dart';
import '../components/custom_text_styles.dart';
import '../constants/custom_color.dart';
import '../constants/image_path.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomHomeAppbar(
            showBackWidget: true,
            showTrailingWidget: true,
            onTrailingTap: () {},
          )),
      body: Column(
        children: [
          const CustomGradientText(
              text: 'Transaction History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 30,
          ),
          Flexible(
            child: Container(
              child: ListView.builder(itemBuilder: (context, index) {
                return _buildTransactionTile(ImagePath.compassGradient, 'Fit24',
                    'ankush', '1999', '25', '\$');
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTransactionTile(
    String imagePath,
    String title,
    String subTitle,
    String amount,
    String increasedAmount,
    String currency,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 33,
                      width: 33,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.fill,
                      )),
                  Container(
                    width: 80,
                    child: Column(
                      children: [
                        CustomText(
                          text: title,
                          style: CustomTextStyles.textCommon(
                              fontWeight: FontWeight.bold,
                              color: CustomColor.black),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        CustomText(
                          text: '+$subTitle%',
                          style: CustomTextStyles.textSubLabel(
                              color: CustomColor.green),
                        )
                      ],
                    ),
                  ),
                  CustomText(
                    text: '.Stake',
                    style: CustomTextStyles.textLabel(
                      color: CustomColor.blue,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomText(
                    text: '\$ $amount',
                    style: CustomTextStyles.textCommon(
                      color: CustomColor.black,
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  CustomText(
                    text: '$increasedAmount {$currency}',
                    style: CustomTextStyles.textLabel(
                      color: CustomColor.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
