import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../models/phone_number.dart';
import '../widgets/text_input_widget.dart';

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
  PhoneNumber _phoneNumber;

  Color grandientStart = Color(0xFF128C7E);
  Color grandientEnd = Color(0xFF075E54);

  void _sendWhatsappMessage(String number) {
    String phoneNumberWithPrefix;
    _phoneNumber = PhoneNumber(prefix: '972', line: number);

    if (!_phoneNumber.isValidIsraeliPhoneNumber()) {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please Provide an Real Israeli Phone Number.'),
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                  focusNode: _phoneFocus,
                  icon: Icons.phone_iphone,
                  onSubmit: (term) {
                    _fieldFocusChange(context, _phoneFocus, _messageFocus);
                  },
                ),
                TextInput(
                  controller: _messageController,
                  hintText: "Enter Your Message",
                  textInputAction: TextInputAction.done,
                  focusNode: _messageFocus,
                  icon: Icons.message,
                  maxLength: 300,
                  maxLines: 5,
                  onSubmit: (val) {
                    _messageFocus.unfocus();
                    _sendWhatsappMessage(
                        _phoneController.text.replaceAll('-', '').trim());
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton.icon(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () => _sendWhatsappMessage(
                      _phoneController.text.replaceAll('-', '').trim()),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Send Whatsapp Message',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
