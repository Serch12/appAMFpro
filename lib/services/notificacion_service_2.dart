import 'package:flutter/material.dart';

class NotificationsService2 {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      showCloseIcon: true,
      content: Text(
        message,
        style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 5),
    );

    messengerKey.currentState?..showSnackBar(snackBar);
  }
}
