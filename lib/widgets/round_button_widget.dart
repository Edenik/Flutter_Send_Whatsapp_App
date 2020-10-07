import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final String text;

  RoundButton({
    @required this.icon,
    @required this.onPressed,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      onPressed: onPressed,
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
