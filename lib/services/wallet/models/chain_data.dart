import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';

class ChainData {
  static final List<ChainMetadata> mainChains = [
    ChainMetadata(
      logo: "https://blockfit.io/wp-content/uploads/2024/10/bfit-coin-png-2-768x768.png",
      id: "1",
      isDefault: true,
      tokens: [
        TokenMetaData(
          contract: "0x8e37D05eBdf4966D0747448636665907Cd3AAC72",
          name: "FIT24",
          isNative: true,
          symbol: "FIT24",
          decimal: 18,
        ),
      ],
      chainId: 'eip155:202424',
      explorerUrl: "https://blockfitscan.io/",
      symbol: "BFIT",
      name: 'BlockFit Network',
      rpc: 'https://rpc.blockfitscan.io/',
    ),
    ChainMetadata(
      logo: "https://avatars.githubusercontent.com/u/66309068?s=200&v=4",
      id: "10",
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
        id: "2",
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
      explorerUrl: "https://arbiscan.io/",
      logo: "https://avatars.githubusercontent.com/u/99078433?s=200&v=4",
      id: "3",
      isDefault: true,
      tokens: [
        TokenMetaData(
          contract: "0xA9d23408b9bA935c230493c40C73824Df71A0975",
          name: "Taiko Token",
          isNative: true,
          symbol: "TAIKO",
          decimal: 18,
        ),
        TokenMetaData(
          contract: "0xA51894664A773981C6C112C43ce576f315d5b1B6",
          name: "WETH",
          symbol: "weth",
          isNative: false,
          decimal: 18,
        )
      ],
      chainId: 'eip155:167000',
      symbol: "ETH",
      name: 'Taiko Mainnet',
      rpc: 'https://rpc.taiko.xyz',
    ),
    ChainMetadata(
      explorerUrl: "https://arb1.arbitrum.io/rpc",
      logo: "https://arbitrum.io/assets/arbitrum/logo_color.png",
      id: "4",
      isDefault: true,
      tokens: [
        TokenMetaData(
          contract: "0x0000000000000000000000000000000000000000",
          name: "Arbitrum",
          isNative: true,
          symbol: "ARB",
          decimal: 18,
        )
      ],
      symbol: "ARB",
      chainId: 'eip155:42161',
      name: 'Arbitrum',
      rpc: 'https://arbitrum.blockpi.network/v1/rpc/public',
    ),
    ChainMetadata(
      explorerUrl: "https://optimistic.etherscan.io/",
      logo:
          "https://cdn.prod.website-files.com/6503306c491d20f69e484470/6504447cca511cf62d89689a_image%20286.png",
      id: "5",
      isDefault: true,
      tokens: [
        TokenMetaData(
          contract: "0x0000000000000000000000000000000000000000",
          name: "Optimism",
          isNative: true,
          symbol: "OP",
          decimal: 18,
        )
      ],
      symbol: "OP",
      chainId: 'eip155:10',
      name: 'OP Mainnet',
      rpc: 'https://mainnet.optimism.io/',
    ),
    ChainMetadata(
      explorerUrl: "https://bsc-dataseed.binance.org/",
      logo: "https://avatars.githubusercontent.com/u/45615063?s=200&v=4",
      id: "6",
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
      logo: "",
      id: "7",
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
      logo: "",
      id: "8",
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
      rpc: 'https://ethereum-holesky-rpc.publicnode.com',
    ),
    ChainMetadata(
      logo: "",
      id: "9",
      tokens: [
        TokenMetaData(
          contract: "0x0000000000000000000000000000000000000000",
          name: "Polygon",
          isNative: true,
          symbol: "MATIC",
          decimal: 18,
        )
      ],
      symbol: "ETH",
      chainId: 'eip155:80001',
      name: 'Polygon Mumbai',
      isTestnet: true,
      rpc: 'https://matic-mumbai.chainstacklabs.com',
    ),
  ];

  static final List<ChainMetadata> allChains = [...mainChains, ...testChains];
}
