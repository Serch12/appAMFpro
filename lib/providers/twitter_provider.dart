import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TwitterProvider extends ChangeNotifier {
  List<dynamic> listadoPublicaciones = [];
  TwitterProvider() {
    print('Twitter provider');
    this.getPublicacionesTwitter();
  }

  getPublicacionesTwitter() async {
    var baseUrl = Uri.https(
        'api.twitter.com',
        '/1.1/statuses/user_timeline.json',
        {'screen_name': 'Emm120195', 'count': '10'});
    String _token =
        'AAAAAAAAAAAAAAAAAAAAANz2mwEAAAAATGYLmj4QcDetx9BxSrcg21AThEY%3DCi0hckasrVDtpClOXTsP423TLUkqSO7hYG5oTgSnaYPZA3jk2G';
    final response = await http.get(baseUrl, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });
    listadoPublicaciones = json.decode(response.body);
    notifyListeners();
  }
}
