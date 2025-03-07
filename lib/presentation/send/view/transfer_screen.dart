import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/constants/image_path.dart';

import '../../../components/custom_button.dart';
import '../../receive/view/receive_screen.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import 'send_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  WalletBloc? _walletBloc;

  @override
  Widget build(BuildContext context) {
    _walletBloc = BlocProvider.of<WalletBloc>(context);

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
                  const SizedBox(height: 10),
                  BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      final token = _walletBloc?.selectedToken;

                      if (state is GetBalanceLoading) {
                        return const CircularProgressIndicator();
                      }

                      if (token == null) {
                        return CustomText(
                          text: "Wallet not initialized",
                          style: TextStyle(color: CustomColor.red),
                        );
                      }

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: token.balance.toStringAsFixed(6),
                                style: CustomTextStyles.textHeading(),
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: token.symbol,
                                style: CustomTextStyles.textHeading(
                                  color: CustomColor.green,
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
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomText(
                    text: '\$ ${_calculateUsdValue()}',
                    style:
                        CustomTextStyles.textHeading(color: CustomColor.green),
                  ),
                  const SizedBox(height: 20),
                  sendReceiveButtons(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: '${_walletBloc?.selectedToken.symbol ?? ""} Activity',
                  style: CustomTextStyles.textTitle(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.47,
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return _buildFitActivityTile(
                        ImagePath.debitIcon,
                        _walletBloc?.selectedToken.symbol ?? "",
                        _walletBloc?.selectedToken.balance.toStringAsFixed(2) ??
                            "0.00",
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String _calculateUsdValue() {
    if (_walletBloc == null) return "0.00";
    return (_walletBloc!.selectedToken.balance * 1).toStringAsFixed(2);
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
                  SizedBox(
                    height: 33,
                    width: 33,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Center(
                      child: CustomText(
                        text: title,
                        style: CustomTextStyles.textCommon(
                          fontWeight: FontWeight.bold,
                          color: CustomColor.black,
                        ),
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

  Widget sendReceiveButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Receive',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ReceiveScreen(),
                ),
              );
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
            text: 'Send',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SendScreen(),
                ),
              );
            },
            isGradient: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: CustomTextStyles.textSubLabel(color: CustomColor.white),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _walletBloc?.add(const GetBalance());
      }
    });
  }
}
