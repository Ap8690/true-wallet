import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/presentation/receive/view/receive_screen.dart';
import 'package:flutter_application_1/presentation/send/view/send_screen.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/transaction_history_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

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
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of(context);
    walletBloc.add(const GetBalance());

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        walletBloc.add(const GetBalance());
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<WalletBloc>().add(const GetBalance());
          return Future.delayed(const Duration(milliseconds: 800));
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            BlocBuilder<WalletBloc, WalletState>(
              buildWhen: (previous, current) =>
                  current is GetBalanceSuccess || current is GetBalanceLoading,
              builder: (context, state) {
                final balance = walletBloc.selectedToken.balance;
                final symbol = walletBloc.selectedToken.symbol;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                color: CustomColor.lightBlue,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          CustomText(
                                            text: 'Account 1',
                                            style:
                                                CustomTextStyles.textCommon(),
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${walletBloc.selectedAccount!.address.substring(0, 6)}...${walletBloc.selectedAccount!.address.substring(walletBloc.selectedAccount!.address.length - 4)}',
                                                  style: const TextStyle(
                                                    fontSize: 8,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: walletBloc
                                                                .selectedAccount!
                                                                .address));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Address copied to clipboard"),
                                                        duration: Duration(
                                                            seconds: 1),
                                                      ),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    ImagePath.copyIcon,
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                )
                                              ],
                                            ),
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
                          Center(
                            child: Column(
                              children: [
                                CustomText(
                                  text: "Your Balance",
                                  style: CustomTextStyles.textTitle(),
                                ),
                                const SizedBox(height: 10),
                                state is GetBalanceLoading
                                    ? const CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: balance.toStringAsFixed(6),
                                            style:
                                                CustomTextStyles.textSubTitle(),
                                          ),
                                          const SizedBox(width: 8),
                                          CustomText(
                                            text: symbol,
                                            style:
                                                CustomTextStyles.textSubTitle(
                                              color: CustomColor.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                if (state is GetBalanceFail)
                                  CustomText(
                                    text: state.message,
                                    style: CustomTextStyles.textLabel(
                                      color: CustomColor.red,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          SizedBox(
                            height: 180,
                            child:
                                ListView.builder(itemBuilder: (context, index) {
                              return _buildTransactionCard(ImagePath.copyIcon,
                                  'Fit24', '1.43', '56.37', '12', 'Fit24');
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
                                    builder: (context) =>
                                        const TransactionHistoryScreen()));
                              },
                              isGradient: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 8),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomText(
                            text: 'Actions',
                            style: CustomTextStyles.textSubTitle(
                                color: CustomColor.black),
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ReceiveScreen()));
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SendScreen()));
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
