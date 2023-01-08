import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handler;
  AdaptiveFlatButton({required this.text,required this.handler});
  @override
  Widget build(BuildContext context) {
    return /*Platform.isIOS? CupertinoButton(
                        onPressed: _presentDatePicker,
                        child: Text(
                          text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ):*/
        TextButton(
      onPressed: handler as Function(),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
