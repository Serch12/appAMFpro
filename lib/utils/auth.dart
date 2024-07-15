import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  Future createAcount(String correo, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: correo, password: pass);
      print(userCredential.user);
      final Map<String, dynamic> userData = {
        'token': userCredential.user?.uid,
        'correo': userCredential
            .user?.email // Reemplaza con el nombre de usuario real
      };
      final String userDataString = jsonEncode(userData);
      await storage.write(key: 'user_data', value: userDataString);
      return (userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      //entra si el password es muy corto
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
        return 1;
      } else if (e.code == 'email-already-in-use') {
        print('El correo ingresado ya existe.');
        return 2;
      }
    } catch (e) {
      print(e);
    }
  }

  Future singInEmailAndPassword(String correo, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: correo, password: password);
      final a = userCredential.user;
      if (a?.uid != null) {
        return a?.uid;
      }
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 1;
      } else if (e.code == 'wrong-password') {
        return 2;
      }
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
