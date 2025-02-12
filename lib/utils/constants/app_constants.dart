class AppSocialLogin {
  final String name;
  final String asset;
  AppSocialLogin({required this.name, required this.asset});
}

class AppConstant {
  static const String projectId = "e973b9df55498caaed73bc364be8640b";
  static const String websiteUrl = "https://blazpay.com/";
  static const String iconsUrl = "https://rewards.blazpay.com/logo.png";
  static const String schema = "blazpay://";
  static const String appName = "Blazpay";
  static const String appDescription = "";

  static List<AppSocialLogin> socialLogins = [
    AppSocialLogin(
      name: "Google",
      asset: "assets/icons/google.svg",
    ),
    AppSocialLogin(
      name: "Twitter",
      asset: "assets/icons/twitter.svg",
    ),
    AppSocialLogin(
      name: "Facebook",
      asset: "assets/icons/facebook.svg",
    ),
    AppSocialLogin(
      name: "Reddit",
      asset: "assets/icons/reddit.svg",
    ),
    AppSocialLogin(
      name: "Discord",
      asset: "assets/icons/discord.svg",
    ),
    AppSocialLogin(
      name: "Twitch",
      asset: "assets/icons/twitch.svg",
    ),
    AppSocialLogin(
      name: "Line",
      asset: "assets/icons/line.svg",
    ),
    AppSocialLogin(
      name: "Github",
      asset: "assets/icons/github.svg",
    ),
    AppSocialLogin(
      name: "Kakao",
      asset: "assets/icons/kakao.svg",
    ),
    AppSocialLogin(
      name: "Linkdin",
      asset: "assets/icons/linkdin.svg",
    ),
    AppSocialLogin(
      name: "Apple",
      asset: "assets/icons/apple.svg",
    ),
  ];

  static const String rpcUrl = "https://rpc-mumbai.maticvigil.com/";
}
