import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> llavenavegador =
    new GlobalKey<NavigatorState>();

class NotificacionesPush {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _mensajesStreamController =
      StreamController<NotificacionDatos>.broadcast();
  Stream<NotificacionDatos> get mensajes => _mensajesStreamController.stream;

  void initNotifications() async {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((value) {
      print('===== FCM TOKEN =====');
      print(value);
    });

    // Se acciona cuando te llega una notificación y estas dentro de ella

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('====== On message ======');
    //   String argumento = 'no-data';
    //   if (Platform.isAndroid) {
    //     argumento = message.data['mensaje'] ?? 'no-data';
    //   }
    //   _mensajesStreamController.sink.add(argumento);
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('====== On message ======');
      String argumento = 'no-data';
      int argumento1 = 0;
      String argumento2 = 'no-data';
      String argumento3 = 'no-data';
      String argumento4 = 'no-data';
      String argumento5 = 'no-data';
      int argumento6 = 0;
      String argumento7 = '';
      String argumento8 = 'no-data';
      DateTime? argumento9 = null;
      int argumento10 = 0;
      if (Platform.isAndroid) {
        // Asigna valores desde message.data con conversiones de tipo apropiadas
        argumento = message.data['mensaje'] ?? 'no-data';
        argumento1 = int.tryParse(message.data['id_sol'] ?? '0') ?? 0;
        argumento2 = message.data['no_solicitud'] ?? 'no-data';
        argumento3 = message.data['nombre'] ?? 'no-data';
        argumento4 = message.data['division'] ?? 'no-data';
        argumento5 = message.data['club'] ?? 'no-data';
        argumento6 = int.tryParse(message.data['nui'] ?? '0') ?? 0;
        argumento7 = message.data['tramite'] ?? '';
        argumento8 = message.data['observaciones'] ?? 'no-data';
        argumento9 =
            DateTime.tryParse(message.data['fecha'] ?? '') ?? DateTime(0);
        argumento10 = int.tryParse(message.data['estatus'] ?? '0') ?? 0;
      }
      NotificacionDatos argumentos = NotificacionDatos(
          mensaje: argumento,
          id_sol: argumento1,
          noSolicitud: argumento2,
          nombre: argumento3,
          division: argumento4,
          club: argumento5,
          nui: argumento6,
          tramite: argumento7,
          observaciones: argumento8,
          fechaSol: argumento9!,
          estatus: argumento10);
      _mensajesStreamController.sink.add(argumentos);
    });
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}

class NotificacionDatos {
  final String mensaje;
  final int id_sol;
  final String noSolicitud;
  final String nombre;
  final String division;
  final String club;
  final int nui;
  final String tramite;
  final String observaciones;
  final DateTime fechaSol;
  final int estatus;

  NotificacionDatos({
    required this.mensaje,
    required this.noSolicitud,
    required this.nombre,
    required this.id_sol,
    required this.division,
    required this.club,
    required this.nui,
    required this.tramite,
    required this.observaciones,
    required this.fechaSol,
    required this.estatus,
  });
}
