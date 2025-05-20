import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class DialogflowAuth {
  late String projectId;
  late String privateKey;
  late String clientEmail;

  // 🔹 Carga credenciales desde un archivo JSON
  Future<void> loadCredentials() async {
    String jsonString = await rootBundle.loadString('assets/credentials.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    projectId = jsonData['project_id'];
    privateKey =
        jsonData['private_key'].replaceAll(r'\n', '\n'); //corrige el formato
    clientEmail = jsonData['client_email'];
  }

  // 🔹 Obtiene un token de acceso con la clave privada
  Future<String> getAccessToken() async {
    final url = Uri.parse("https://oauth2.googleapis.com/token");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "assertion": _createJwt(),
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception("Error al obtener Access Token: ${response.body}");
    }
  }

  // 🔹 Genera un JWT válido para la autenticación
  String _createJwt() {
    final iat = DateTime.now().millisecondsSinceEpoch ~/
        1000; // Tiempo actual en segundos
    final exp = iat + 3600; // Expira en 1 hora

    final jwt = JWT(
      {
        "iss": clientEmail, // ✅ Cuenta de servicio como emisor
        "sub": clientEmail, // ✅ También la cuenta de servicio
        "aud": "https://oauth2.googleapis.com/token", // ✅ Endpoint correcto
        "iat": iat,
        "exp": exp,
        "scope":
            "https://www.googleapis.com/auth/dialogflow" // 🔥 Scope correcto
      },
    );

    return jwt.sign(
      RSAPrivateKey(privateKey),
      algorithm: JWTAlgorithm.RS256,
    );
  }
}
