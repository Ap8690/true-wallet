import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_application_1/screens/pay_screen.dart';

class ConnectWalletScreen extends StatefulWidget {
  const ConnectWalletScreen({super.key});

  @override
  State<ConnectWalletScreen> createState() => _ConnectWalletScreenState();
}

class _ConnectWalletScreenState extends State<ConnectWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomHomeAppbar(
            showBackWidget: false,
            onBackTap: () => Navigator.of(context).pop(),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              ImagePath.blockFit,
              height: 50,
              width: 120,
            ),
            const SizedBox(height: 10),
            CustomText(
              text: "wants to connect",
              style:
                  CustomTextStyles.textHeading(fontWeight: FontWeight.normal),
            ),
            const SizedBox(width: 10),
            CustomText(
              text: 'https://www.blockfit.io',
              style: CustomTextStyles.textHeading(
                  color: CustomColor.grey, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            Image.asset(
              ImagePath.cannotVerifyIcon,
              height: 60,
              width: 120,
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Requested permissions',
                  style: CustomTextStyles.textHeading(
                      color: CustomColor.green, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                statusCheckRow('View your balance and activity', 1),
                const SizedBox(height: 20),
                statusCheckRow('Send Approval request', 2),
                const SizedBox(height: 20),
                statusCheckRow('Move funds without permission', 0),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Accounts',
                      style:
                          CustomTextStyles.textCommon(color: CustomColor.grey),
                    ),
                    CustomText(
                      text: 'Chains',
                      style:
                          CustomTextStyles.textCommon(color: CustomColor.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Non available',
                      style: CustomTextStyles.textCommon(),
                    ),
                    CustomText(
                      text: 'Non available',
                      style: CustomTextStyles.textCommon(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                CustomText(
                  text:
                      'The session cannot be approved because the wallet does not the support some or all of the proposed chains. Please inspect the console for more information',
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                rejectApproveButtons(),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<String> statusList = ['pending', 'pending', 'pending'];

  void updateStatus(int index, String status) {
    setState(() {
      statusList[index] = status;
    });
  }

  Widget statusIcon(String status) {
    if (status == 'success') {
      return Icon(Icons.check_circle, color: Colors.green);
    } else if (status == 'failed') {
      return Icon(Icons.cancel, color: Colors.red);
    } else {
      return Icon(Icons.circle, color: Colors.grey);
    }
  }

  Widget statusCheckRow(String text, int index) {
    return Row(
      children: [
        statusIcon(statusList[index]),
        const SizedBox(width: 10),
        CustomText(
          text: text,
          style: CustomTextStyles.textSubHeading(
              color: CustomColor.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  rejectApproveButtons() {
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
            text: ' Approve ',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PayScreen()));
            },
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
