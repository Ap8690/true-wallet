import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';

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
}
