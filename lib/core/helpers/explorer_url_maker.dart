String explorerUrlMaker(String txHash, String explorerUrl) {
  print("$explorerUrl/tx/$txHash");
  return "$explorerUrl/tx/$txHash";
}

String makeExplorerUrl(String txHash, String explorerUrl) {
  print("$explorerUrl/tx/$txHash");
  if (explorerUrl.contains("0x")) {
    return explorerUrl;
  } else {
    return "$explorerUrl/tx/$txHash";
  }
}
