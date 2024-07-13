import 'package:flutter/material.dart';
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.info, color: Colors.white),
          SizedBox(width: 8.0),
          Text(
            message.substring(0,25),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.blue, // Set your preferred background color
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}