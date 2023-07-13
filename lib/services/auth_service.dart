import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  //token para autenticar en firebase
  final String _firebaseToken = 'AIzaSyCEYmh0MZ8fonxbUjZrmH46PZ3Q_rTH6nk';

  final storage = new FlutterSecureStorage();

  //si retornamos algo es un error. Si no, todo bien.
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(
        this._baseUrl, '/v1/accounts:signUp', {'key': this._firebaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if (decodedResp.containsKey('idToken')) {
      // token hay que guardarlo en un lugar seguro
      // return decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  //si retornamos algo es un error. Si no, todo bien.
  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(this._baseUrl, '/v1/accounts:signInWithPassword',
        {'key': this._firebaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    // print(decodedResp);
    // return 'Error de login';
    if (decodedResp.containsKey('idToken')) {
      // token hay que guardarlo en un lugar seguro
      // return decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> autenticacion() async {
    return await storage.read(key: 'token') ?? '';
  }
}
