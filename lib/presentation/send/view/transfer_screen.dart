import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_application_1/presentation/send/view/send_screen.dart';

import '../../../components/custom_button.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Your Balance",
                    style: CustomTextStyles.textTitle(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "827.97",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: CustomText(
                          text: 'Fit24',
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
                    style:
                        CustomTextStyles.textHeading(color: CustomColor.green),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  sendReceiveButtons(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: 'Fit24 Activity',
                    style: CustomTextStyles.textTitle()),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.47,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return _buildFitActivityTile(
                        ImagePath.debitIcon, 'Fit24', '25');
                  }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  sendReceiveButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Receive',
            onPressed: () {},
            isGradient: false,
            backgroundColor: CustomColor.grey,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            textStyle: CustomTextStyles.textCommon(color: CustomColor.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomButton(
            text: ' Send ',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SendScreen()));
            },
            isGradient: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: CustomTextStyles.textSubLabel(color: CustomColor.white),
          ),
        ),
      ],
    );
  }

  Widget _buildFitActivityTile(
    String imagePath,
    String title,
    String amount,
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
                    child: Center(
                      child: CustomText(
                        text: title,
                        style: CustomTextStyles.textCommon(
                            fontWeight: FontWeight.bold,
                            color: CustomColor.black),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomText(
                    text: '\$ $amount',
                    style: CustomTextStyles.textCommon(
                      color: CustomColor.green,
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
