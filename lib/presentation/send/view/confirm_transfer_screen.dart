import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_gradient_text.dart';
import 'package:flutter_application_1/components/custom_home_appbar.dart';
import 'package:flutter_application_1/components/custom_text.dart';
import 'package:flutter_application_1/components/custom_text_styles.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/presentation/send/bloc/send_bloc.dart';
import 'package:flutter_application_1/presentation/send/view/transaction_success_screen.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';

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
  late WalletBloc walletBloc;
  late SendBloc sendBloc;
  String _networkFees = "Calculating...";
  bool isLoading = false;
  int _maxGas = 0;
  late EtherAmount gasPrice;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
    sendBloc = BlocProvider.of<SendBloc>(context);
    _calculateGasFees();
  }

  void _calculateGasFees() {
    print(walletBloc.selectedChain.rpc);
    print(walletBloc.selectedToken.decimal);
    sendBloc.add(GetGasFee(
      value: BigInt.from(double.parse(widget.amount) * 
          pow(10, walletBloc.selectedToken.decimal)),
      receiver: EthereumAddress.fromHex(widget.receiverAccount),
      sender: EthereumAddress.fromHex(widget.senderAccount),
      rpc: walletBloc.selectedChain.rpc,
      isNative: true,
      decimal: walletBloc.selectedToken.decimal,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendBloc, SendState>(
      listener: (context, state) {
        if (state is SendTransactionLoading) {
          setState(() => isLoading = true);
        } else if (state is SendTransactionSuccess) {
          // Navigate to success screen with hash
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionSuccessScreen(
                transactionHash: state.hash,
              ),
            ),
          );
        } else if (state is SendTransactionFails) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: CustomHomeAppbar(
              showBackWidget: false,
              centreText: 'Confirm',
              onBackTap: () => Navigator.of(context).pop(),
            )),
        body: Stack(
          children: [
            Padding(
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
                        text: walletBloc.selectedToken.symbol,
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
                                text:  Helpers.formatLongString(widget.senderAccount),
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
                                text:  Helpers.formatLongString(widget.receiverAccount),
                                style: CustomTextStyles.textCommon(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          BlocBuilder<SendBloc, SendState>(
                            builder: (context, state) {
                              if (state is GetGasFeeSuccess) {
                                gasPrice = state.gasFee.gasFees;
                                _maxGas = state.gasFee.maxGas;
                                _networkFees = 
                                  "${state.gasFee.gasFeesInDollars.toStringAsFixed(7)} ${walletBloc.selectedToken.symbol}";
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: 'Transaction Fee (0.0%)',
                                    style: CustomTextStyles.textCommon(
                                        color: CustomColor.grey),
                                  ),
                                  CustomText(
                                    text: _networkFees,
                                    style: CustomTextStyles.textCommon(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            },
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
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget confirmButton() {
    return CustomButton(
      text: 'Confirm',
      onPressed: () {
        final transaction = Transaction(
          maxGas: _maxGas,
          from: EthereumAddress.fromHex(widget.senderAccount),
          to: EthereumAddress.fromHex(widget.receiverAccount),
          value: EtherAmount.fromBigInt(
            EtherUnit.wei,
            BigInt.from(double.parse(widget.amount) * 
                pow(10, walletBloc.selectedToken.decimal)),
          ),
          gasPrice: gasPrice,
        );

        sendBloc.add(SendTransaction(
          explorerUrl: walletBloc.selectedChain.explorerUrl ?? "",
          token: walletBloc.selectedToken,
          chain: walletBloc.selectedChain,
          transaction: transaction,
          credential: walletBloc.selectedAccount!.toCredential(),
          isNative: walletBloc.selectedToken.isNative,
        ));
      },
      isGradient: true,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      textStyle: CustomTextStyles.textCommon(color: CustomColor.white),
    );
  }
}
