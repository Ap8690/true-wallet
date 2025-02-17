import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/exceptions/exceptions.dart';
import 'package:flutter_application_1/core/utils/chain_utils.dart';
import 'package:flutter_application_1/services/send/models/wallet_gas_fees.dart';
import 'package:flutter_application_1/services/sharedpref/preference_service.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class SendService {
  final Client httpClient = Client();
  final PreferenceService preferenceService = GetIt.I<PreferenceService>();

  Future<Either<AppException, String>> sendTransaction({
    required Credentials credentials,
    required TokenMetaData token,
    required ChainMetadata chain,
    required Transaction transaction,
    required bool isNative,
    required String explorerUrl,
  }) async {
    try {
      final client = Web3Client(chain.rpc, httpClient);

      // Enhanced logging
      _logTransactionDetails(
        credentials: credentials,
        token: token,
        chain: chain,
        transaction: transaction,
        isNative: isNative,
      );

      String txHash;

      if (token.contract == address00 ||
          token.contract == addressEE ||
          token.contract == address10) {
        txHash = await _sendNativeTransaction(
            client, credentials, transaction, chain);
      } else {
        txHash = await _sendERC20Transaction(
          client: client,
          credentials: credentials,
          token: token,
          chain: chain,
          transaction: transaction,
          explorerUrl: explorerUrl,
        );
      }


      print(txHash);

      final receipt = await _waitForReceipt(client, txHash);
      if (receipt == null) {
        print("Transaction failed: No receipt received.");
        return left(SwapException(message: "Transaction failed or timed out"));
      }

      return receipt.status ?? false
          ? right(txHash)
          : left(SwapException(message: "Transaction failed"));
    } catch (e) {
      print('Transaction Error: $e');

      return left(WalletException(message: e.toString()));
    }
  }

  Future<TransactionReceipt?> _waitForReceipt(
      Web3Client client, String txHash) async {
    const pollingInterval = Duration(seconds: 5);
    const maxAttempts = 60;
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        final receipt = await client.getTransactionReceipt(txHash);
        if (receipt != null) {
          return receipt;
        }
      } catch (e) {
        print("Error while fetching receipt: $e");
      }

      attempts++;
      await Future.delayed(pollingInterval);
    }

    return null;
  }

  Future<String> _sendNativeTransaction(
      Web3Client client,
      Credentials credentials,
      Transaction transaction,
      ChainMetadata chain) async {
    print("Sending native transaction");
    return await client.sendTransaction(
      credentials,
      transaction,
      chainId: int.parse(chain.chainId.split(":").last),
    );
  }

  bool _isValidAddress(String address) {
    if (!address.startsWith('0x')) return false;
    if (address.length != 42) return false;
    try {
      EthereumAddress.fromHex(address);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<BigInt> getAllowance(String rpcUrl, String tokenAddress,
      String ownerAddress, String spenderAddress, BigInt value) async {
    if (!await hasInternet()) {
      print("No internet. Cannot fetch allowance.");
      return BigInt.zero;
    }

    print("=== Allowance Check Debug ===");
    print("RPC URL: $rpcUrl");
    print("Token Address: $tokenAddress");
    print("Owner Address: $ownerAddress");
    print("Spender Address: $spenderAddress");
    print("Value: $value");

    if (tokenAddress.toLowerCase() ==
        "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee") {
      print("Native token detected, returning max allowance");
      return BigInt.from(2).pow(256) - BigInt.one;
    }

    final client = Web3Client(rpcUrl, httpClient);

    try {
      var abi = await rootBundle.loadString("assets/abi/erc20.json");
      print("ABI loaded successfully");

      final contractAbi = ContractAbi.fromJson(abi, "ERC20");
      final contractAddress = EthereumAddress.fromHex(tokenAddress);

      print("Creating contract instance");
      final contract = DeployedContract(contractAbi, contractAddress);

      print("Getting allowance function");
      final allowanceFunction = contract.function("allowance");

      print("Making contract call");
      final result = await client.call(
        sender: EthereumAddress.fromHex(ownerAddress),
        contract: contract,
        function: allowanceFunction,
        params: [
          EthereumAddress.fromHex(ownerAddress),
          EthereumAddress.fromHex(spenderAddress),
        ],
      );

      print("Call result: $result");
      if (result.isNotEmpty) {
        final allowance = result.first as BigInt;
        print("Current allowance: $allowance");
        return allowance;
      } else {
        print("Empty result received");
        return BigInt.zero;
      }
    } catch (e, stackTrace) {
      print("=== Allowance Error ===");
      print("Error: $e");
      print("Stack trace: $stackTrace");

      if (!_isValidAddress(ownerAddress) ||
          !_isValidAddress(spenderAddress) ||
          !_isValidAddress(tokenAddress)) {
        print("Invalid address format detected");
        return BigInt.zero;
      }

      return BigInt.zero;
    } finally {
      print("Cleaning up client");
      client.dispose();
    }
  }

  Future<String> approveSpender(
      String rpcUrl,
      String tokenAddress,
      Credentials credentials,
      String spenderAddress,
      BigInt amount,
      String chainId,
      String walletAddress) async {
    if (!await hasInternet()) {
      print("No internet. Cannot approve spender.");
      return "";
    }

    final client = Web3Client(rpcUrl, Client());

    try {
      var abi = await rootBundle.loadString("assets/abi/erc20.json");

      final contractAbi = ContractAbi.fromJson(abi, "ERC20");
      final contractAddress = EthereumAddress.fromHex(tokenAddress);
      final contract = DeployedContract(contractAbi, contractAddress);

      final approveFunction = contract.function("approve");

      final data = contract.function("approve").encodeCall([
        EthereumAddress.fromHex(spenderAddress),
        amount,
      ]);

      final gasEstimate = await client.estimateGas(
        sender: credentials.address,
        to: contractAddress,
        data: data,
      );

      print("Estimated gas: $gasEstimate");

      final gasPrice = await client.getGasPrice();
      print("Current gas price: ${gasPrice.getInWei}");

      final gasLimit = (gasEstimate * BigInt.from(120)) ~/ BigInt.from(100);
      print("Gas limit with buffer: $gasLimit");

      final transactionHash = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: approveFunction,
          parameters: [
            EthereumAddress.fromHex(spenderAddress),
            amount,
          ],
          maxGas: gasLimit.toInt(),
          gasPrice: gasPrice,
        ),
        chainId: int.parse(chainId),
      );

      print("lallowance : $transactionHash");
      return transactionHash;
    } catch (e) {
      print("Error during approve: $e");
      return "";
    } finally {
      client.dispose();
    }
  }

  Future<String> approveTokenSpender({
    required String rpcUrl,
    required String tokenContractAddress,
    required Credentials credentials,
    required String spenderAddress,
    required BigInt amount,
    required int chainId,
  }) async {
    try {
      // Initialize Web3 client
      final client = Web3Client(rpcUrl, Client());

      // Load ERC20 ABI
      String abiCode = await rootBundle.loadString('assets/abi/erc20.json');
      final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'ERC20'),
        EthereumAddress.fromHex(tokenContractAddress),
      );

      // Get the approve function
      final approveFunction = contract.function('approve');

      // Determine the amount to approve
      BigInt approvalAmount;
      if (amount == BigInt.zero) {
        // If no specific amount is provided, use max approval
        approvalAmount = BigInt.parse(
            "115792089237316195423570985008687907853269984665640564039457584007913129639935");
      } else {
        approvalAmount = amount;
      }

      // Get current gas price
      final gasPrice = await client.getGasPrice();

      // Estimate gas limit
      final gasLimit = await client.estimateGas(
        sender: credentials.address,
        to: EthereumAddress.fromHex(tokenContractAddress),
        data: approveFunction.encodeCall(
            [EthereumAddress.fromHex(spenderAddress), approvalAmount]),
      );

      // Send approval transaction
      final txHash = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: approveFunction,
          parameters: [EthereumAddress.fromHex(spenderAddress), approvalAmount],
          gasPrice: gasPrice,
          maxGas: gasLimit.toInt(),
        ),
        chainId: chainId,
      );

      // Wait for transaction receipt
      final receipt = await _waitForReceipt(client, txHash);

      if (receipt == null) {
        print("Token Approval failed: No receipt received.");
        throw Exception("Token Approval failed: No receipt received.");
      }

      // Check transaction status
      if (receipt.status ?? false) {
        print("Token Approval Successful: $txHash");
        return txHash;
      } else {
        print("Token Approval failed");
        throw Exception("Token Approval Transaction failed");
      }
    } catch (e) {
      print('Error in approveTokenSpender: $e');
      rethrow;
    }
  }

// Modify the existing _sendERC20Transaction to use improved approval
  Future<String> _sendERC20Transaction({
    required Web3Client client,
    required Credentials credentials,
    required TokenMetaData token,
    required ChainMetadata chain,
    required Transaction transaction,
    required String explorerUrl,
  }) async {
    print("Sending ERC20 transaction");
    try {
      String abiCode = await rootBundle.loadString('assets/abi/erc20.json');
      final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'ERC20'),
        EthereumAddress.fromHex(token.contract),
      );
      final transferFunction = contract.function('transfer');

      // Carefully convert transaction value considering token decimals
      BigInt tokenAmount =
          _calculateTokenAmount(transaction.value, token.decimal);

      // Check token allowance
      BigInt currentAllowance = await getAllowance(chain.rpc, token.contract,
          credentials.address.toString(), transaction.to!.hex, tokenAmount);

      print('Current Allowance: $currentAllowance');
      print('Required Amount: $tokenAmount');

      // Automatic approval if allowance is insufficient
      if (currentAllowance < tokenAmount) {
        // Attempt to approve the exact required amount
        await approveTokenSpender(
          rpcUrl: chain.rpc,
          tokenContractAddress: token.contract,
          credentials: credentials,
          spenderAddress: transaction.to!.hex,
          amount: tokenAmount,
          chainId: int.parse(chain.chainId.split(":").last),
        );
      }

      // Proceed with token transfer
      final gasPrice = await client.getGasPrice();
      final gasLimit = await _estimateTokenTransferGas(client, credentials,
          contract, transferFunction, transaction.to, tokenAmount);

      final txHash = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: transferFunction,
          parameters: [transaction.to, tokenAmount],
          gasPrice: gasPrice,
          maxGas: gasLimit.toInt(),
        ),
        chainId: int.parse(chain.chainId.split(":").last),
      );

      final receipt = await _waitForReceipt(client, txHash);
      if (receipt == null) {
        print("Token Transaction failed: No receipt received.");
        return "Transaction failed: No receipt received.";
      }

      return receipt.status ?? false ? txHash : "Transaction failed";
    } catch (e) {
      print('Error in _sendERC20Transaction: $e');
      rethrow;
    }
  }

  Future<BigInt> _estimateTokenTransferGas(
      Web3Client client,
      Credentials credentials,
      DeployedContract contract,
      ContractFunction transferFunction,
      EthereumAddress? to,
      BigInt amount) async {
    try {
      final gasLimit = await client.estimateGas(
        sender: credentials.address,
        to: contract.address,
        data: transferFunction.encodeCall([to, amount]),
      );
      return gasLimit;
    } catch (e) {
      print('Gas estimation error: $e');
      // Fallback to a standard token transfer gas limit
      return BigInt.from(100000);
    }
  }

  BigInt _calculateTokenAmount(dynamic value, int decimal) {
    try {
      if (value is EtherAmount) {
        return value.getInWei;
      } else if (value is BigInt) {
        return value;
      } else {
        double doubleValue = double.parse(value.toString());
        return BigInt.from((doubleValue * pow(10, decimal)).toInt());
      }
    } catch (e) {
      print('Token amount calculation error: $e');
      throw Exception('Invalid token amount');
    }
  }

  void _logTransactionDetails({
    required Credentials credentials,
    required TokenMetaData token,
    required ChainMetadata chain,
    required Transaction transaction,
    required bool isNative,
  }) {
    print("=== Transaction Details ===");
    print("Sender: ${credentials.address}");
    print("Token: ${token.symbol}");
    print("Chain ID: ${chain.chainId}");
    print("Recipient: ${transaction.to}");
    print("Value: ${transaction.value}");
    print("Is Native: $isNative");
  }

  Future<void> _storeTransactionHistory({
    required String explorerUrl,
    required Credentials credentials,
    required Transaction transaction,
    required TokenMetaData token,
    required ChainMetadata chain,
    required String txHash,
    required String status,
  }) async {
    var chainId = chain.chainId.contains("eip155")
        ? int.parse(chain.chainId.split(":").last)
        : int.parse(chain.chainId);
    print(
        "Amount before conversion: ${transaction.value?.getInWei.toString()}");
    final rawWeiValue = transaction.value?.getInWei ?? BigInt.zero;
    print("Raw Wei value: $rawWeiValue");
    final value = rawWeiValue.toDouble() / pow(10, token.decimal);
    print("Amount: $value");
    print("Token Decimal: ${token.decimal}");
  }

  Future<Either<AppException, TransactionReceipt?>> getTransaction({
    required String rpc,
    required String hash,
  }) async {
    try {
      final client = Web3Client(rpc, Client());
      final receipt = await client.getTransactionReceipt(hash);
      print(receipt?.status);

      return right(receipt);
    } catch (e) {
      print(e);
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, WalletGasFee>> getGasFee(
    String rpc,
    int decimal, {
    required EthereumAddress sender,
    required EthereumAddress receiver,
    required BigInt value,
    bool isNative = true,
  }) async {
    try {
      print("RPC: $rpc");
      print("Decimal: $decimal");
      print("Sender: $sender");
      print("Receiver: $receiver");
      print("Value: $value");
      print("Is Native: $isNative");
      final client = Web3Client(rpc, Client());

      EtherAmount gasPrice = await client.getGasPrice();
      print("Gas Price: $gasPrice");

      BigInt gasLimit = BigInt.from(21000);
      
      print("Gas Limit: $gasLimit");

      BigInt totalGasFeeWei = gasPrice.getInWei * gasLimit;

      double totalGasFeeInToken = totalGasFeeWei.toDouble() / pow(10, decimal);

      print("Total Gas Fee in Token: $totalGasFeeInToken");

      return right(WalletGasFee(
        gasFees: EtherAmount.fromBigInt(EtherUnit.wei, totalGasFeeWei),
        gasFeesInDollars: totalGasFeeInToken,
        maxGas: gasLimit.toInt(),
      ));
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, EtherAmount>> getTokenBalance(
      String rpc, String add, String contractAddress) async {
    try {
      final address = EthereumAddress.fromHex(add);
      String abiCode = await rootBundle.loadString('assets/abi/erc20.json');

      final contract = DeployedContract(
          ContractAbi.fromJson(abiCode, 'Erc20Token'),
          EthereumAddress.fromHex(contractAddress));

      final client = Web3Client(rpc, Client());

      final balance = await client.call(
          contract: contract,
          function: contract.function('balanceOf'),
          params: [address]);

      debugPrint(balance.toString());

      return right(EtherAmount.fromBigInt(EtherUnit.wei, balance.first));
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }

  Future<Either<AppException, EtherAmount>> getCoinBalance(
      String rpc, String add) async {
    try {
      final address = EthereumAddress.fromHex(add);

      final client = Web3Client(rpc, Client());

      final balance = await client.getBalance(address);

      debugPrint(balance.toString());

      return right(balance);
    } catch (e) {
      return left(WalletException(message: e.toString()));
    }
  }
}
