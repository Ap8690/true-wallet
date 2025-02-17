
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_loader.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/screens/custom_bottom_sheet.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:flutter_application_1/services/wallet/models/wallet_model.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSelectionWidget extends StatefulWidget {
  final double? width;
  final bool showBalance;
  const AccountSelectionWidget(
      {super.key, this.width, this.showBalance = false});

  @override
  State<AccountSelectionWidget> createState() => _AccountSelectionWidgetState();
}

class _AccountSelectionWidgetState extends State<AccountSelectionWidget> {
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
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                customBottomSheet(
                    context,
                    (controller) => SelectAccountBottomSheetWidget(
                          controller: controller,
                        ));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.pink,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            walletBloc.selectedAccount?.name ?? "",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      widget.showBalance
                          ? Text(
                              'Balance: ${walletBloc.selectedAccount?.balance ?? 0} ${walletBloc.selectedChain.tokens.first.symbol}',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            )
                          : Text(
                              Helpers.formatLongString(
                                  walletBloc.selectedAccount?.address ?? ""),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SelectAccountBottomSheetWidget extends StatefulWidget {
  final ScrollController controller;
  const SelectAccountBottomSheetWidget({
    super.key,
    required this.controller,
  });

  @override
  State<SelectAccountBottomSheetWidget> createState() =>
      _SelectAccountBottomSheetWidgetState();
}

class _SelectAccountBottomSheetWidgetState
    extends State<SelectAccountBottomSheetWidget> {
  late WalletBloc walletBloc;

  @override
  void initState() {
    walletBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.blue),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is GetWalletLoading) {
            CustomLoader.show(context);
          }
          if (state is GetWalletFail) {
            CustomLoader.hide(context);
          }
          if (state is GetWalletSuccess) {
            CustomLoader.hide(context);
          }
        },
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Accounts",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade900),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                controller: widget.controller,
                shrinkWrap: true,
                itemCount: walletBloc.wallet?.accounts.length,
                itemBuilder: (context, index) {
                  final isSelected = walletBloc.selectedAccount?.address ==
                      walletBloc.wallet?.accounts[index].address;
                  return AccountTile(
                      chain: walletBloc.selectedChain,
                      onTap: isSelected
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : () {
                              Navigator.of(context).pop();
                              walletBloc.add(ChangeAccount(
                                  account: walletBloc.wallet!.accounts[index]));
                            },
                      isSelected: isSelected,
                      account: walletBloc.wallet?.accounts[index]);
                },
              ),
            ),
            CustomButton(
              text: "Create New Account",
              onPressed: () {
                walletBloc.add(const AddAccount());
              },
            )
          ],
        ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final CryptoAccount? account;
  final bool isSelected;
  final ChainMetadata chain;
  final VoidCallback onTap;
  const AccountTile(
      {super.key,
      required this.account,
      required this.isSelected,
      required this.onTap,
      required this.chain});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade900 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            contentPadding: EdgeInsets.zero,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.blue,
                      )
                    : const SizedBox(),
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  padding: const EdgeInsets.all(20),
                  color: Colors.black.withOpacity(0.8),
                  shadowColor: Colors.grey.shade600,
                  elevation: 5,
                  offset: const Offset(0, 0),
                  onSelected: (value) {},
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          Navigator.of(context)
                            ..pop();
                        },
                        child: const Text(
                          "Account Details",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        child: Text(
                          "Show Private Key",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ];
                  },
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.pink,
              ),
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
            title: Text(
              account?.name ?? "",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            subtitle: Text(
              "${account?.balance ?? 0} Token Balance",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
