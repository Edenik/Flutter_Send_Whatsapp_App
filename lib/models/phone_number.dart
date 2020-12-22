class IsraeliPhoneNumber {
  final String prefix;
  final String line;
  final String pattern = r'^((\+|00)?972\-?|0)(([23489]|[57]\d)\-?\d{7})$';

  IsraeliPhoneNumber({this.prefix, this.line});

  bool isValidIsraeliPhoneNumber() {
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
    String num;
    if (line.contains('+972')) {
      num = line.substring(4);
    } else if (line.contains('972')) {
      num = line.substring(3);
    } else {
      num = line.substring(1);
    }
    final String phoneNumber = '+' + prefix + num;
    return phoneNumber;
  }
}
