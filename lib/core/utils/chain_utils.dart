extension ChainUtils on String {
  String get networkId {
    try {
      return split(':').length > 1 ? split(':')[1] : this;
    } catch (e) {
      return this;
    }
  }

  String get chainName {
    try {
      return split(':').first;
    } catch (e) {
      return this;
    }
  }
}

const address00 = '0x0000000000000000000000000000000000000000';
const address10 = '0x0000000000000000000000000000000000001010';
const addressEE = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee';
