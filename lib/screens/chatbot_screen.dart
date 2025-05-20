import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/services/dialogflow_service.dart';
import 'package:splash_animated/services/dialogflow_auth.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class chatBotScreen extends StatefulWidget {
  final DialogflowService dialogflow;
  final nombre;
  final division;
  final club;
  final id_afiliado;
  const chatBotScreen({
    super.key,
    required this.dialogflow,
    this.nombre,
    this.division,
    this.club,
    this.id_afiliado,
  });

  @override
  State<chatBotScreen> createState() => _chatBotScreenState();
}

class _chatBotScreenState extends State<chatBotScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  List<String> options = [];
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    // Agregar el primer mensaje del bot al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialBotMessage();
    });
  }

  void _sendInitialBotMessage() async {
    // Mensaje inicial con datos personalizados
    String firstMessage =
        "¡Hola ${widget.nombre}! Antes de continuar necesito algunos datos, ¿Tu equipo actual es ${widget.club} que pertenece a ${widget.division}?";

    // Agregar primer mensaje del bot con las opciones
    String botTime = DateFormat('hh:mm a').format(DateTime.now());
    setState(() {
      messages.add(
          {"sender": "bot", "message": firstMessage, "timestamp": botTime});
    });

    // Esperar la respuesta del bot (por si se necesita una respuesta adicional)
    var response = await widget.dialogflow
        .sendEventMessage(); // Puedes enviar un evento al bot si es necesario

    // Si el bot tiene una respuesta de texto, la agregamos
    if (response['text'] != null && response['text'].isNotEmpty) {
      setState(() {
        messages.add({
          "sender": "bot",
          "message": response['text'],
          "timestamp": botTime
        });
      });
    }

    // Si el bot tiene opciones, las agregamos (Sí, No)
    if (response['options'] != null && response['options'].isNotEmpty) {
      setState(() {
        messages.add({
          "sender": "bot",
          "message": "", // Mensaje vacío para solo mostrar las opciones
          "timestamp": botTime,
          "type": "options",
          "options": response['options'].join(',') // Opciones de respuesta
        });
      });
    }
  }

  void sendMessage() async {
    String text = _controller.text;
    if (text.isEmpty) return;
    String time = DateFormat('hh:mm a').format(DateTime.now());

    // Agrega el mensaje del usuario
    setState(() {
      messages.add({"sender": "user", "message": text, "timestamp": time});
      _controller.clear();
    });

    // Enviar al bot
    var response = await widget.dialogflow.sendMessage(text);
    String botTime = DateFormat('hh:mm a').format(DateTime.now());

    print('Respuesta completa del bot: $response');

    // ⚠️ Primero agrega texto del bot si viene
    if (response['text'] != null && response['text'].isNotEmpty) {
      setState(() {
        messages.add({
          "sender": "bot",
          "message": response['text'],
          "timestamp": botTime
        });
      });
    }

    // ⚠️ Después agrega opciones si vienen
    if (response['options'] != null && response['options'].isNotEmpty) {
      setState(() {
        messages.add({
          "sender": "bot",
          "message": "", // Mensaje vacío para solo mostrar los botones
          "timestamp": botTime,
          "type": "options",
          "options": response['options'].join(',')
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("tenemos a ${widget.nombre}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot AMFPro"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.red,
            ), // Ícono de salida
            onPressed: _closeChat, // Llama a la función para cerrar el chat
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo_chat.png'), // Ruta de la imagen
            fit: BoxFit.fill,
            alignment: Alignment(
                -1, 1.0), // Opcional: ajusta la imagen al tamaño del contenedor
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isUser = messages[index]["sender"] == "user";

                    // Verifica si este mensaje es de opciones
                    bool isOptions = messages[index]['type'] == 'options';
                    List<String> localOptions = [];
                    if (isOptions) {
                      localOptions = messages[index]['options']!.split(',');
                    }

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser)
                            Container(
                              padding: EdgeInsets.all(8),
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/avatar_bot5.jpg"),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: isUser ? Color(0xFF4FC028) : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  // 🔥 Mostrar dropdown si es tipo opciones
                                  if (isOptions)
                                    DropdownButton<String>(
                                      value:
                                          selectedOption, // Opción seleccionada
                                      hint: Text(
                                        "Selecciona una opción",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      dropdownColor: Color(0xFF4FC028), // Verde
                                      style: TextStyle(color: Colors.white),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          _controller.text = newValue;
                                          sendMessage(); // Envía la respuesta seleccionada
                                        }
                                      },
                                      items: localOptions
                                          .map<DropdownMenuItem<String>>(
                                              (String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                    ),

                                  // 🔥 Mostrar texto si no es opciones
                                  if (!isOptions)
                                    Text(
                                      messages[index]["message"]!,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                      softWrap: true,
                                    ),

                                  SizedBox(height: 4),

                                  Text(
                                    messages[index]["timestamp"]!,
                                    style: TextStyle(
                                        fontSize: 8, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: "Escribe un mensaje...",
                          filled: true,
                          fillColor: Color(0xFF8ED550),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25)),
                          focusColor: Color(0xFF8ED550)),
                    ),
                  ),
                  Ink(
                    decoration: const ShapeDecoration(
                        color: Color(0xFF8ED550), shape: CircleBorder()),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.send),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Función para cerrar el chat
  void _closeChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Finalizar conversación"),
          content: Text("¿Estás seguro de que quieres salir del chat?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo sin salir
              },
            ),
            TextButton(
              child: Text("Salir"),
              onPressed: () {
                setState(() {
                  messages.clear(); // Borra los mensajes al salir
                });
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.of(context).pop(); // Vuelve a la pantalla anterior
                Navigator.pushNamed(context, 'homeroute');
              },
            ),
          ],
        );
      },
    );
  }
}
