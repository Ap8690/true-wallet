
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/constants/custom_color.dart';
import 'package:flutter_application_1/presentation/networks/bloc/networks_bloc.dart';
import 'package:flutter_application_1/presentation/networks/screens/custom_text_field.dart';
import 'package:flutter_application_1/presentation/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddChainScreenWidget extends StatefulWidget {
  static const routeName = "add_chain_screen";
  const AddChainScreenWidget({super.key});

  @override
  State<AddChainScreenWidget> createState() => _AddChainScreenWidgetState();
}

class _AddChainScreenWidgetState extends State<AddChainScreenWidget> {
  final TextEditingController rpcController = TextEditingController();
  final TextEditingController chainIdController = TextEditingController();
  final TextEditingController symbolController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? rpcError;
  late NetworksBloc networksBloc;
  late WalletBloc walletBloc;
  bool isActive = false;
  bool isRpcValidated = false;

  @override
  void initState() {
    networksBloc = BlocProvider.of(context);
    walletBloc = BlocProvider.of(context);
    super.initState();
  }

  void validateRpc() {
    if (Uri.tryParse(rpcController.text) == null) {
      rpcError = "RPC url must contains http:// or https://";
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

  bool newChainPressed = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NetworksBloc, NetworksState>(
        listener: (context, state) {
      if (state is GetChainIdSuccess) {
        chainIdController.text = state.chainId;
        isRpcValidated = true;
        validateButton();
      }
      if (state is AddChainSuccess) {
        walletBloc.chains = state.chainList;
        walletBloc.add(RefreshState());

        Navigator.of(context).pop();
      }
      if (state is GetChainIdFail) {
        rpcError = state.message;
        setState(() {});
      }

      if (state is RemoveChainSuccess) {
        setState(() {
          walletBloc.chains = state.chainList;
        });
        walletBloc.add(RefreshState());
      }
    }, builder: (context, state) {
      return Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(10),
            children: [
              CustomTextfield(
                
                borderColor: CustomColor.blue,
                controller: nameController,
                hintText: "Network Name",
                onTap: () {
                  validateButton();
                },
              ),
              SizedBox(
                height: 10,
              ),
              Focus(
                child: CustomTextfield(
                  length: 100,
                  borderColor: CustomColor.blue,
                  controller: rpcController,
                  onChange: (p0) {
                    isRpcValidated = false;
                    if (rpcError != null) {
                      rpcError = null;
                      setState(() {});
                    }
                  },
                  suffix: state is GetChainIdLoading
                      ? const CircularProgressIndicator(
                          color: CustomColor.blue,
                        )
                      : null,
                  hintText: "RPC URL",
                ),
                onFocusChange: (value) {
                  if (!value) {
                    validateRpc();
                  }
                },
              ),
              if (rpcError != null) ...[
                SizedBox(
                  height: 5,
                ),
                Text(
                  rpcError ?? "",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              SizedBox(
                height: 10,
              ),
              CustomTextfield(
                borderColor:CustomColor.blue,
                controller: chainIdController,
                hintText: "Chain ID",
                focusOnTap: false,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextfield(
                borderColor: CustomColor.blue,
                onChange: (p0) {
                  validateButton();
                },
                controller: symbolController,
                hintText: "Currency Symbol",
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    top: BorderSide(
                      color: CustomColor.green,
                      width: 2,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      const Icon(Icons.warning_rounded, color: Colors.red),
                      SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Security Tip",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: const Text(
                    "A malicious network provider can lie about the state of the blockchain and record your network activity. only add custom networks you trust.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(double.infinity, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text(
                    "Cancel",
                    style:
                        TextStyle(color: CustomColor.red, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: "Save",
                onPressed: () {
                  if (isActive) {
                    networksBloc.add(AddChain(
                        chain: ChainMetadata(
                      id: uuid.v1(),
                      tokens: [
                        TokenMetaData(
                          contract:
                              "0x0000000000000000000000000000000000000000",
                          symbol: symbolController.text,
                          name: nameController.text,
                          isNative: true,
                          decimal: 18,
                        ),
                      ],
                      chainId: 'eip155:${chainIdController.text}',
                      symbol: symbolController.text,
                      name: nameController.text,
                      rpc: rpcController.text,
                    )));
                  }
                },
              )
            ],
          ),
        ],
      );
    });
  }
}
