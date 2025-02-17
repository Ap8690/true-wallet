
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/presentation/networks/bloc/networks_bloc.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ViewChainScreen extends StatefulWidget {
  final ChainMetadata chain;
  static const routeName = "view_chain_screen";
  const ViewChainScreen({super.key, required this.chain});

  @override
  State<ViewChainScreen> createState() => _ViewChainScreenState();
}

class _ViewChainScreenState extends State<ViewChainScreen> {
  final TextEditingController rpcController = TextEditingController();
  final TextEditingController chainIdController = TextEditingController();
  final TextEditingController symbolController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? rpcError;
  late NetworksBloc networksBloc;
  late WalletBloc walletBloc;
  bool isActive = false;
  bool isRpcValidated = true;

  @override
  void initState() {
    networksBloc = BlocProvider.of(context);
    walletBloc = BlocProvider.of(context);

    nameController.text = widget.chain.name;
    rpcController.text = widget.chain.rpc;
    chainIdController.text = widget.chain.chainId.split(":").last;
    symbolController.text = widget.chain.symbol;
    super.initState();
  }

  void validateRpc() {
    if (Uri.tryParse(rpcController.text) == null) {
      rpcError = "RPC URL must contain http:// or https://";
      setState(() {});
      return;
    }
    networksBloc.add(GetChainId(rpc: rpcController.text));
  }

  validateButton() {
    if (isRpcValidated &&
        nameController.text.isNotEmpty &&
        symbolController.text.isNotEmpty) {
      isActive = true;
    } else {
      isActive = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NetworksBloc, NetworksState>(
      listener: (context, state) {
        if (state is GetChainIdSuccess) {
          chainIdController.text = state.chainId;
          isRpcValidated = true;
          validateButton();
        }
        if (state is SaveChainSuccess) {
          print("state is SaveChainSuccess");
          walletBloc.chains = state.chainList;
          walletBloc.add(RefreshState());
          Navigator.of(context).pop();
          setState(() {});
        }
        if (state is GetChainIdFail) {
          rpcError = state.message;
          setState(() {});
        }
        
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.red,
                  ]),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    "This will allow this network to be used with Blazpay",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.chain.logo == "" || widget.chain.logo == null
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
                                  backgroundImage:
                                      NetworkImage(widget.chain.logo!),
                                ),
                          SizedBox(width: 10),
                          Text(
                            widget.chain.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Network Name",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(height: 25),
                          Text("Network URL",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(height: 25),
                          Text("Chain ID",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(height: 25),
                          Text("Currency Symbol",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          children: [
                            TextField(
                              readOnly: widget.chain.isDefault ? true : false,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              controller: nameController,
                              decoration: const InputDecoration(
                                hintText: "Network Name",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            Focus(
                              onFocusChange: (value) {
                                if (!value) {
                                  validateRpc();
                                }
                              },
                              child: TextField(
                                readOnly: widget.chain.isDefault ? true : false,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                onChanged: (p0) {
                                  isRpcValidated = false;
                                  if (rpcError != null) {
                                    rpcError = null;
                                    setState(() {});
                                  }
                                },
                                controller: rpcController,
                                decoration: const InputDecoration(
                                  hintText: "Network URL",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            if (rpcError != null) ...[
                              SizedBox(height: 5),
                              Text(
                                rpcError ?? "",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            TextField(
                              readOnly: true,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              controller: chainIdController,
                              decoration: const InputDecoration(
                                hintText: "Chain ID",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            TextField(
                              readOnly: widget.chain.isDefault ? true : false,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              onChanged: (p0) {
                                validateButton();
                              },
                              controller: symbolController,
                              decoration: const InputDecoration(
                                hintText: "Currency Symbol",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      side: const BorderSide(color:Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  widget.chain.isDefault
                      ? Container()
                      : CustomButton(
                          onPressed: () {
                            networksBloc.add(SaveChain(
                                chain: ChainMetadata(
                              id: widget.chain.id,
                              tokens: widget.chain.tokens,
                              chainId: chainIdController.text,
                              symbol: symbolController.text,
                              name: nameController.text,
                              rpc: rpcController.text,
                              isTestnet: widget.chain.isTestnet,
                            )));
                          },
                          text: "Save",
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
