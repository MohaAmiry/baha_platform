mixin SharedUserOperations {
  static final RegExp mailValidator = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool isValidURL(String url) {
    return Uri.parse(url).hasAbsolutePath;
  }

  bool isValidEmail(String val) => mailValidator.hasMatch(val);

  bool isValidPassword(String val) => val.length > 6;

  bool isValidUserName(String val) => val.isNotEmpty;

  bool isValidWeight(String val) => (double.tryParse(val) ?? -1) > 0;

  bool isValidHeight(String val) => (double.tryParse(val) ?? -1) > 0;

  bool isValidBirth(String val) => (int.tryParse(val) ?? -1) > 1900;

  bool isValidMaxOrders(String val) => (int.tryParse(val) ?? -1) > 0;

  bool isValidNumber(String val) => val.startsWith("05") && val.length == 10;

  bool isValidNumericDouble(String val) => (double.tryParse(val) ?? -1) > 0;

  bool isValidNumericInt(String val) => (int.tryParse(val) ?? -1) > 0;
}
