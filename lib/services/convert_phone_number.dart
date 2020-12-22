import 'dart:convert';

import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_send_whatsapp_app/models/phone_number.dart';

class ConvertPhoneNumber {
  String _tryParseIsraeliNumber(String value) {
    String internationalPhoneNumber;
    IsraeliPhoneNumber _israeliPhoneNumber = IsraeliPhoneNumber(
      prefix: '972',
      line: value.replaceAll(new RegExp(r'[^0-9]'), ''),
    );

    if (_israeliPhoneNumber.isValidIsraeliPhoneNumber()) {
      internationalPhoneNumber = _israeliPhoneNumber.phoneNumberWithPrefix;
    }
    return internationalPhoneNumber;
  }

  Future<String> _tryParseInternationalNumber(String value) async {
    String internationalPhoneNumber;
    try {
      final res = await FlutterLibphonenumber()
          .parse(value.replaceAll(new RegExp(r'[^0-9]'), ''));

      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      internationalPhoneNumber = encoder.convert(res['e164']);
    } catch (e) {
      //print(e);
    }

    return internationalPhoneNumber;
  }

  Future<String> tryParsePhoneNumber(String value) async {
    String internationalPhoneNumber = _tryParseIsraeliNumber(value);

    if (internationalPhoneNumber != null) {
      return internationalPhoneNumber;
    } else {
      internationalPhoneNumber = await _tryParseInternationalNumber(value);
      return internationalPhoneNumber;
    }
  }
}
