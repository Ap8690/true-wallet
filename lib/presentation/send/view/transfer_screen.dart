import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_button.dart';
import '../../receive/view/receive_screen.dart';
import 'send_screen.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late WalletBloc walletBloc;

  @override
  void initState() {
    walletBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
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
      },
    );
  }

  sendReceiveButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Receive',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReceiveScreen()));
            },
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
