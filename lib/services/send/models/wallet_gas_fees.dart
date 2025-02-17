import 'package:web3dart/web3dart.dart';

class WalletGasFee {
  final double gasFeesInDollars;
  final EtherAmount gasFees;
  final int maxGas;
  WalletGasFee(
      {required this.gasFeesInDollars,
      required this.gasFees,
      required this.maxGas});
}
