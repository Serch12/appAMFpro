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
    final Map<String, dynamic> userData = {
      'token': decodedResp['idToken'],
      'correo': decodedResp['email'], // Reemplaza con el nombre de usuario real
    };
    final String userDataString = json.encode(userData);
    // return 'Error de login';
    if (decodedResp.containsKey('idToken')) {
      // token hay que guardarlo en un lugar seguro
      // return decodedResp['idToken'];
      await storage.write(key: 'user_data', value: userDataString);
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
    final Map<String, dynamic> userData = {
      'token': decodedResp['idToken'],
      'correo': decodedResp['email'], // Reemplaza con el nombre de usuario real
    };
    final String userDataString = json.encode(userData);
    // return 'Error de login';
    if (decodedResp.containsKey('idToken')) {
      // token hay que guardarlo en un lugar seguro
      // return decodedResp['idToken'];
      await storage.write(key: 'user_data', value: userDataString);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'user_data');
    return;
  }

  Future<String> autenticacion() async {
    return await storage.read(key: 'user_data') ?? '';
  }
}
