import 'package:flutter_application_1/services/wallet/models/wallet_model.dart';
import 'package:get_it/get_it.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class UpdateEvent extends EventArgs {
  final bool loading;

  UpdateEvent({required this.loading});
}

class EventArgs { //TODO import this class
}

abstract class IWeb3WalletService extends Disposable {
  void create();
  Future<void> init(CryptoWallet wallet);

  Web3Wallet get web3wallet;
}
