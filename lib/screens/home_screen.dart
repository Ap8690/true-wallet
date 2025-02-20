import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/presentation/receive/view/receive_screen.dart';
import 'package:flutter_application_1/presentation/send/view/pay_screen.dart';
import 'package:flutter_application_1/presentation/send/view/send_screen.dart';
import 'package:flutter_application_1/presentation/send/view/transfer_screen.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/dapp_view.dart';
import 'package:flutter_application_1/screens/transaction_history_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/custom_text.dart';
import '../components/custom_text_styles.dart';
import '../constants/custom_color.dart';
import '../constants/image_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WalletBloc walletBloc;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        print(walletBloc.selectedAccount!.address);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: CustomHomeAppbar(
              showBackWidget: true,
              showTrailingWidget: true,
              onTrailingTap: () {},
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColor.white,
                      border: Border.all(
                        color: CustomColor.offWhite,
                        width: 2,
                      )),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: CustomColor.lightBlue,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                CustomText(
                                  text: 'Account 1',
                                  style: CustomTextStyles.textCommon(),
                                ),
                              ],
                            ),
                            Transform.rotate(
                              angle: 90 * (3.14 / 180),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: CustomColor.offWhite,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 5,
                          color: CustomColor.offWhite,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Address : ',
                              style: CustomTextStyles.textSubLabel(
                                  color: CustomColor.black),
                            ),
                            Container(
                                height: 20,
                                decoration: BoxDecoration(
                                    color: CustomColor.lightBlue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Text(
                                      walletBloc.selectedAccount!.address,
                                      style: const TextStyle(
                                        fontSize: 8,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Image.asset(
                                      ImagePath.copyIcon,
                                      height: 10,
                                      width: 10,
                                    )
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CustomText(
                          text: "${walletBloc.selectedAccount?.balance ?? 0} ${walletBloc.selectedToken.symbol}",
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
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: CustomColor.blue, width: 1)),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              CustomText(
                                text: 'Portfolio',
                                style: CustomTextStyles.textLabel(
                                    color: CustomColor.blue),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                ImagePath.navigatorIcon,
                                height: 10,
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return _buildTransactionCard(ImagePath.copyIcon, 'Fit24',
                        '1.43', '56.37', '12', 'Fit24');
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: CustomButton(
                    text: 'Buy',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const TransactionHistoryScreen()));
                    },
                    isGradient: true,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomText(
                  text: 'Actions',
                  style: CustomTextStyles.textSubTitle(color: CustomColor.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ReceiveScreen()));
                          },
                          child: Image.asset(
                            ImagePath.receiveImage,
                            height: 100,
                            width: 80,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SendScreen()));
                          },
                          child: Image.asset(
                            ImagePath.sendImage,
                            height: 100,
                            width: 80,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 20,
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

  Widget _buildTransactionCard(
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
                  SizedBox(
                      height: 33,
                      width: 33,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
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
