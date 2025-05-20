import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class DialogflowService {
  final String projectId;
  final String accessToken;
  final String idAfiliado; // Agregamos el ID del afiliado

  DialogflowService(
      {required this.projectId,
      required this.accessToken,
      required this.idAfiliado});

  Future<Map<String, dynamic>> sendEventMessage() async {
    String url =
        "https://dialogflow.googleapis.com/v2/projects/$projectId/agent/sessions/$idAfiliado:detectIntent";

    Map<String, dynamic> body = {
      "queryInput": {
        "event": {
          "name": "WELCOME", // Evento que activa el Intent de Bienvenida
          "languageCode": "es"
        }
      }
    };

    return await _sendRequest(body);
  }

  Future<Map<String, dynamic>> sendMessage(String text) async {
    String url =
        "https://dialogflow.googleapis.com/v2/projects/$projectId/agent/sessions/$idAfiliado:detectIntent";

    Map<String, dynamic> body = {
      "queryInput": {
        "text": {"text": text, "languageCode": "es"}
      },
      "queryParams": {
        "payload": {
          "id_afiliado": idAfiliado // Enviamos el ID como parámetro extra
        }
      }
    };

    return await _sendRequest(body);
  }

  Future<Map<String, dynamic>> _sendRequest(Map<String, dynamic> body) async {
    String url =
        "https://dialogflow.googleapis.com/v2/projects/$projectId/agent/sessions/12345:detectIntent";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String fulfillmentText =
          jsonResponse["queryResult"]["fulfillmentText"] ?? "";
      List<String> options = [];
      String messageText = fulfillmentText;

      var fulfillmentMessages =
          jsonResponse["queryResult"]["fulfillmentMessages"];

      for (var msg in fulfillmentMessages) {
        if (msg["text"] != null &&
            msg["text"]["text"] != null &&
            msg["text"]["text"].isNotEmpty) {
          messageText = msg["text"]["text"][0];
        }

        if (msg["payload"] != null) {
          if (msg["payload"]["text"] != null &&
              msg["payload"]["text"].isNotEmpty) {
            messageText = msg["payload"]["text"];
          }

          if (msg["payload"]["options"] != null &&
              msg["payload"]["options"].isNotEmpty) {
            options = List<String>.from(msg["payload"]["options"]);
          }
        }
      }

      print("Texto final a mostrar: $messageText");
      print("Opciones detectadas: $options");

      return {"text": messageText, "options": options};
    } else {
      return {"text": "Error en la comunicación con Dialogflow", "options": []};
    }
  }
}
