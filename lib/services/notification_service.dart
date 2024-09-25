import 'package:flutter/material.dart';

class NotificationsService {
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
      duration: Duration(seconds: 2),
    );

    messengerKey.currentState?..showSnackBar(snackBar);
  }
}
