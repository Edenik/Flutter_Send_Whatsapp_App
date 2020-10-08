import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../models/phone_number.dart';
import '../widgets/text_input_widget.dart';
import '../widgets/round_button_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _messageFocus = FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription _intentDataStreamSubscription;

  PhoneNumber _phoneNumber;

  final Color grandientStart = Color(0xFF075E54);
  final Color grandientEnd = Color(0xFF128C7E);

  void _sendWhatsappMessage(String number) {
    String phoneNumberWithPrefix;
    _phoneNumber = PhoneNumber(prefix: '972', line: number);

    if (!_phoneNumber.isValidIsraeliPhoneNumber()) {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text('Please Provide a Real Israeli Phone Number.'),
      ));
      return;
    } else {
      phoneNumberWithPrefix = _phoneNumber.phoneNumberWithPrefix;
    }

    FlutterOpenWhatsapp.sendSingleMessage(
        phoneNumberWithPrefix, _messageController.text.trim());
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void checkShareString(String value) {
    PhoneNumber _shareString =
        PhoneNumber(prefix: '972', line: value.replaceAll('-', '').trim());
    if (_shareString.isValidIsraeliPhoneNumber()) {
      _phoneController.text = value;
    } else {
      _messageController.text = value;
    }
  }

  @override
  void initState() {
    super.initState();

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value != null) checkShareString(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null) checkShareString(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [grandientStart, grandientEnd],
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.message,
                  size: 150,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 30,
                ),
                TextInput(
                  controller: _phoneController,
                  hintText: "Enter Phone Number",
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.phone,
                  focusNode: _phoneFocus,
                  icon: Icons.phone_iphone,
                  onSubmit: (term) {
                    _fieldFocusChange(context, _phoneFocus, _messageFocus);
                  },
                ),
                TextInput(
                  controller: _messageController,
                  hintText: "Enter Your Message",
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.none,
                  focusNode: _messageFocus,
                  icon: Icons.message,
                  maxLength: 300,
                  maxLines: 5,
                  onSubmit: null,
                ),
                SizedBox(
                  height: 15,
                ),
                RoundButton(
                  icon: Icons.send,
                  onPressed: () {
                    _messageFocus.unfocus();
                    _sendWhatsappMessage(
                        _phoneController.text.replaceAll('-', '').trim());
                  },
                  text: 'Send Whatsapp Message',
                ),
                RoundButton(
                  icon: Icons.clear,
                  onPressed: () {
                    _phoneController.clear();
                    _messageController.clear();
                  },
                  text: 'Clear',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
