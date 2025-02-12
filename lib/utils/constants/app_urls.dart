class AppUrls {
  // static const baseUrl = 'https://api-staging.blazpay.com';
  // static const baseUrl = 'https://a645-103-184-194-92.ngrok-free.app/api';

  static const baseUrl = 'https://api-v2.blazpay.com/api';
  static const login = '$baseUrl/auth/mlogin';
  static const checkAddress = '$baseUrl/auth/check-address';
  static const createProfile = '$baseUrl/user/profile';
  static const validateUsername = '$baseUrl/auth/check-username';
  static const carousel = '$baseUrl/admin/carousel';
static const getProfile = '$baseUrl/user/profile';
  // 1inch -> 6.5inch
  static const oneInchBase = 'https://api.1inch.dev';
  static const oneInchTokens = '$oneInchBase/swap/v6.0/1/tokens';
  static oneInchQuote(String chain) => '$oneInchBase/swap/v6.0/{}/tokens';

  // Kyber -> Cyber
  static const kyberBase = 'https://aggregator-api.kyberswap.com';
  //router protocol
  static const routerProtocolBase =
      'https://api-beta.pathfinder.routerprotocol.com/api';

  static const chatWebhookBaseUrl = "ws://api-v2.blazpay.com";
}
