import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ChainData {
  static final List<ChainMetadata> mainChains = [
    ChainMetadata(
      logo:
          "https://blockfit.io/wp-content/uploads/2024/10/bfit-coin-png-2-768x768.png#fromHistory",
      id: "1",
      isDefault: true,
      tokens: [
        TokenMetaData(
          contract: "0x0000000000000000000000000000000000000000",
          name: "BlockFit",
          isNative: true,
          symbol: "BFIT",
          decimal: 18,
        ),
        TokenMetaData(
          contract: "0x0011E559da84dde3f841e22dc33F3adbF184D84A",
          name: "WETH",
          symbol: "WETH",
          isNative: true,
          decimal: 18,
        )
      ],
      chainId: 'eip155:202424',
      explorerUrl: "https://blockfitscan.io/",
      symbol: "BFIT",
      name: 'BlockFit',
      rpc: 'https://rpc.blockfitscan.io/',
    ),
    ChainMetadata(
      logo: "https://avatars.githubusercontent.com/u/66309068?s=200&v=4",
      id: "2",
      isDefault: true,
      tokens: [
        TokenMetaData(
          contract: "0x0000000000000000000000000000000000001010",
          name: "Polygon",
          isNative: true,
          symbol: "POL",
          decimal: 18,
        ),
        TokenMetaData(
          contract: "0x0011E559da84dde3f841e22dc33F3adbF184D84A",
          name: "WETH",
          symbol: "WETH",
          isNative: true,
          decimal: 18,
        )
      ],
      chainId: 'eip155:137',
      explorerUrl: "https://polygonscan.com/",
      symbol: "POL",
      name: 'Polygon',
      rpc: 'https://polygon-rpc.com/',
    ),
    ChainMetadata(
        logo: "https://avatars.githubusercontent.com/u/6250754?s=200&v=4",
        id: "3",
        isDefault: true,
        tokens: [
          TokenMetaData(
            contract: "0x0000000000000000000000000000000000000000",
            name: "Ethereum",
            symbol: "ETH",
            isNative: true,
            decimal: 18,
          )
        ],
        symbol: "ETH",
        chainId: 'eip155:1',
        name: 'Ethereum',
        rpc: 'https://eth.drpc.org',
        explorerUrl: "https://etherscan.io/"),
    ChainMetadata(
      explorerUrl: "https://bsc-dataseed.binance.org/",
      logo: "https://avatars.githubusercontent.com/u/45615063?s=200&v=4",
      id: "4",
      isDefault: true,
      tokens: [
        TokenMetaData(
          contract: "0x0000000000000000000000000000000000000000",
          name: "BNB",
          isNative: true,
          symbol: "BNB",
          decimal: 18,
        )
      ],
      chainId: 'eip155:56',
      symbol: "BNB",
      name: 'BNB Mainnet',
      rpc: 'https://bsc-dataseed1.bnbchain.org',
    ),
  ];

  static final List<ChainMetadata> testChains = [
    ChainMetadata(
      explorerUrl: "https://sepolia.etherscan.io/",
      logo: "https://avatars.githubusercontent.com/u/6250754?s=200&v=4",
      id: "5",
      tokens: [
        TokenMetaData(
          contract: "0x0000000000000000000000000000000000000000",
          name: "Sepolia Eth",
          isNative: true,
          symbol: "sepEth",
          decimal: 18,
        )
      ],
      symbol: "ETH",
      chainId: 'eip155:11155111',
      name: 'Sepolia',
      isTestnet: true,
      rpc: 'https://ethereum-sepolia.publicnode.com',
    ),
    ChainMetadata(
      explorerUrl: "https://holesky.etherscan.io/",
      logo: "https://avatars.githubusercontent.com/u/6250754?s=200&v=4",
      id: "6",
      tokens: [
        TokenMetaData(
          contract: "0x0000000000000000000000000000000000000000",
          name: "Holesky Eth",
          isNative: true,
          symbol: "holEth",
          decimal: 18,
        )
      ],
      symbol: "ETH",
      chainId: 'eip155:17000',
      name: 'Holesky',
      isTestnet: true,
      rpc: 'https://1rpc.io/holesky',
    ),
  ];

  static final List<ChainMetadata> allChains = [...mainChains, ...testChains];

  // Add fallback RPCs for your chain
  static final List<String> blockfitRPCs = [
    "https://rpc.blockfitscan.io/",
    "https://rpc-backup.blockfitscan.io/", // Add your backup RPC
  ];

  Future<String> getWorkingRPC() async {
    for (String rpc in blockfitRPCs) {
      try {
        final client = Web3Client(rpc, Client());
        await client.getNetworkId();
        await client.dispose();
        return rpc;
      } catch (e) {
        print("RPC $rpc failed: $e");
        continue;
      }
    }
    throw Exception("No working RPC found");
  }

  Future<bool> verifyRPC(String rpc) async {
    try {
      final client = Web3Client(rpc, Client());
      try {
        final chainId = await client.getChainId();
        print("RPC verification successful for $rpc - Chain ID: $chainId");
        await client.dispose();
        return true;
      } catch (e) {
        print("RPC verification failed for $rpc: $e");
        await client.dispose();
        return false;
      }
    } catch (e) {
      print("Critical error verifying RPC $rpc: $e");
      return false;
    }
  }
}
