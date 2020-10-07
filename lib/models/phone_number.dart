class PhoneNumber {
  final String prefix;
  final String line;
  PhoneNumber({this.prefix, this.line});

  bool isValidIsraeliPhoneNumber() {
    print(line);
    final pattern = r'^((\+|00)?972\-?|0)(([23489]|[57]\d)\-?\d{7})$';
    final regExp = RegExp(pattern);
    if (line == null || line.isEmpty) {
      return false;
    }

    if (!regExp.hasMatch(line)) {
      return false;
    }
    return true;
  }

  String get phoneNumberWithPrefix {
    final num = '+' + prefix + line.substring(1);
    return num;
  }
}
