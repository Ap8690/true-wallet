import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/custom_loader.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/presentation/networks/bloc/networks_bloc.dart';
import 'package:flutter_application_1/presentation/networks/screens/add_chain_screen.dart';
import 'package:flutter_application_1/presentation/networks/screens/view_chain_details.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ChainSelectionWidget extends StatefulWidget {
  final double? width;
  const ChainSelectionWidget({super.key, this.width});

  @override
  State<ChainSelectionWidget> createState() => _ChainSelectionWidgetState();
}

class _ChainSelectionWidgetState extends State<ChainSelectionWidget> {
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
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SelectChain();
            }));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CustomColor.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  walletBloc.selectedChain.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class SelectChain extends StatefulWidget {
  const SelectChain({super.key});

  @override
  State<SelectChain> createState() => _SelectChainState();
}

class _SelectChainState extends State<SelectChain> {
  late WalletBloc walletBloc;
  late NetworksBloc networksBloc;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    walletBloc = BlocProvider.of(context);
    networksBloc = BlocProvider.of(context);
    super.initState();
  }

  String formatLongString(String input) {
    if (input.length <= 10) {
      return input;
    } else {
      String firstPart = input.substring(0, 7);
      String lastPart = input.substring(input.length - 5);
      return '$firstPart...$lastPart';
    }
  }

  bool isNewChainButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ChainSelectWiget(context),
        body: Stack(
          children: [
            BlocListener<NetworksBloc, NetworksState>(
              listener: (context, state) {
                if (state is RemoveChainSuccess) {
                  walletBloc.chains = state.chainList;
                  walletBloc.add(RefreshState());
                }
                if (state is AddChainSuccess) {
                  setState(() {
                    isNewChainButtonPressed = false;
                  });
                }
                if (state is SaveChainSuccess) {
                  setState(() {
                    walletBloc.chains = state.chainList;
                  });
                  walletBloc.add(RefreshState());
                  // Navigator.of(context).pop();
                  setState(() {});
                }
                if (state is RemoveChainSuccess) {
                  setState(() {
                    walletBloc.chains = state.chainList;
                  });
                  walletBloc.add(RefreshState());
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: BlocConsumer<WalletBloc, WalletState>(
                  listener: (context, state) {
                    if (state is StateRefreshed) {}
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
                  builder: (context, state) =>
                      BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SearchBar(
                            backgroundColor: MaterialStateProperty.all(
                              CustomColor.whiteLight,
                            ),
                            hintText: "Search by chain",
                            hintStyle: const WidgetStatePropertyAll(TextStyle(
                                color: CustomColor.grey, fontSize: 14)),
                            leading: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.search,
                                color: CustomColor.grey,
                              ),
                            ),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(
                                        color: CustomColor.blue))),
                          ),
                          const TabBar(
                              indicatorColor: CustomColor.blue,
                              labelColor: CustomColor.blue,
                              unselectedLabelColor: CustomColor.grey,
                              dividerColor: CustomColor.black,
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: [
                                Tab(
                                  text: "Mainnet",
                                ),
                                Tab(
                                  text: "Testnet",
                                ),
                                Tab(
                                  text: "Custom",
                                ),
                              ]),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: TabBarView(children: [
                              ListView.builder(
                                controller: controller,
                                shrinkWrap: true,
                                itemCount: walletBloc.chains.length,
                                itemBuilder: (context, index) {
                                  if (!walletBloc.chains[index].isTestnet &&
                                      walletBloc.chains[index].isDefault) {
                                    final isSelected =
                                        walletBloc.chains[index].id ==
                                            walletBloc.selectedChain.id;
                                    return ChainTile(
                                        onRemove: () {
                                          networksBloc.add(RemoveChain(
                                              chain: walletBloc.chains[index]));
                                        },
                                        onTap: isSelected
                                            ? () {
                                                Navigator.of(context).pop();
                                              }
                                            : () {
                                                walletBloc.add(ChangeChain(
                                                    chain: walletBloc
                                                        .chains[index]));
                                                Navigator.of(context).pop();
                                              },
                                        isSelected: isSelected,
                                        chainData: walletBloc.chains[index]);
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              ListView.builder(
                                controller: controller,
                                shrinkWrap: true,
                                itemCount: walletBloc.chains.length,
                                itemBuilder: (context, index) {
                                  if (walletBloc.chains[index].isTestnet) {
                                    final isSelected =
                                        walletBloc.chains[index].id ==
                                            walletBloc.selectedChain.id;
                                    return ChainTile(
                                        onRemove: () {
                                          networksBloc.add(RemoveChain(
                                              chain: walletBloc.chains[index]));
                                        },
                                        onTap: isSelected
                                            ? () {
                                                Navigator.of(context).pop();
                                              }
                                            : () {
                                                walletBloc.add(ChangeChain(
                                                    chain: walletBloc
                                                        .chains[index]));
                                                Navigator.of(context).pop();
                                              },
                                        isSelected: isSelected,
                                        chainData: walletBloc.chains[index]);
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              isNewChainButtonPressed
                                  ? const AddChainScreenWidget()
                                  : ListView(
                                      children: [
                                        ListView.builder(
                                          controller: controller,
                                          shrinkWrap: true,
                                          itemCount: walletBloc.chains.length,
                                          itemBuilder: (context, index) {
                                            if (!walletBloc
                                                    .chains[index].isDefault &&
                                                !walletBloc
                                                    .chains[index].isTestnet) {
                                              final isSelected = walletBloc
                                                      .chains[index].id ==
                                                  walletBloc.selectedChain.id;
                                              return ChainTile(
                                                  onRemove: () {
                                                    networksBloc.add(
                                                        RemoveChain(
                                                            chain: walletBloc
                                                                    .chains[
                                                                index]));
                                                  },
                                                  onTap: isSelected
                                                      ? () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      : () {
                                                          walletBloc.add(ChangeChain(
                                                              chain: walletBloc
                                                                      .chains[
                                                                  index]));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                  isSelected: isSelected,
                                                  chainData:
                                                      walletBloc.chains[index]);
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: CustomButton(
                                            text: "Add New Chain",
                                            onPressed: () {
                                              setState(() {
                                                isNewChainButtonPressed = true;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                            ]),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar ChainSelectWiget(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: CustomColor.blue,
          )),
      backgroundColor: CustomColor.white,
      actions: [
        walletBloc.selectedChain.logo == "" ||
                walletBloc.selectedChain.logo == null
            ? Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(
                  Icons.link,
                  size: 15,
                  color: Colors.white,
                ))
            : CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey[100],
                backgroundImage: NetworkImage(walletBloc.selectedChain.logo!),
              ),
        SizedBox(
          width: 8,
        ),
        Text(
          walletBloc.selectedChain.name.substring(0, 3),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: CustomColor.black,
          size: 28,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

class ChainTile extends StatelessWidget {
  final ChainMetadata chainData;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const ChainTile({
    super.key,
    required this.chainData,
    required this.isSelected,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? CustomColor.lightBlue : CustomColor.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? CustomColor.blue : CustomColor.transparent)),
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
                  color: CustomColor.white.withOpacity(0.95),
                  shadowColor: CustomColor.grey,
                  elevation: 5,
                  offset: const Offset(0, 0),
                  onSelected: (value) {},
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  ViewChainScreen(chain: chainData));
                        },
                        child: const Text(
                          "View Chain Details",
                          style: TextStyle(color: CustomColor.black),
                        ),
                      ),
                      if (!chainData.isDefault)
                        PopupMenuItem(
                          onTap: onRemove,
                          child: const Text(
                            "Remove Chain",
                            style: TextStyle(color: CustomColor.black),
                          ),
                        )
                    ];
                  },
                  child: Icon(
                    Icons.edit,
                    color: CustomColor.black,
                    size: 25,
                  ),
                ),
              ],
            ),
            leading: chainData.logo == "" || chainData.logo == null
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.link,
                      size: 30,
                      color: Colors.white,
                    ))
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: NetworkImage(chainData.logo!),
                  ),
            title: Row(
              children: [
                Text(
                  chainData.name,
                  style: TextStyle(color: CustomColor.black, fontSize: 14),
                ),
                SizedBox(width: 10),
                chainData.isDefault
                    ? Icon(
                        Icons.lock,
                        color: CustomColor.grey,
                        size: 15,
                      )
                    : const SizedBox()
              ],
            ),
            subtitle: Text(
              "Chain Id: ${chainData.chainId}",
              style: TextStyle(color: CustomColor.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
