import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'screens.dart';
import 'package:http/http.dart' as http;

class ListaContratosScreen extends StatefulWidget {
  const ListaContratosScreen({Key? key}) : super(key: key);

  @override
  State<ListaContratosScreen> createState() => _ListaContratosScreenState();
}

class _ListaContratosScreenState extends State<ListaContratosScreen> {
  String? username;
  final String _urlBase = 'test-intranet.amfpro.mx';
  dynamic jugador = [];
  List<Map<String, dynamic>> lista = [];
  int? id_afi;
  String? nombre;
  String? apellidoPaterno;
  String? apellidoMaterno;

  @override
  void initState() {
    super.initState();
    cargarUsername();
  }

  void cargarUsername() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final userDataString = await authService.autenticacion();

    if (userDataString != null) {
      final Map<String, dynamic> userData = json.decode(userDataString);
      final String? userEmail = userData['correo'];

      if (userEmail != null) {
        obtenerDatosDeAPI(userEmail);
      } else {
        setState(() {
          print('No se encontró el campo "correo" en userData.');
          username = 'Usuario Desconocido';
        });
      }
    } else {
      setState(() {
        print('El valor de userDataString es nulo.');
        username = 'Usuario Desconocido'; // Asigna un valor predeterminado
      });
    }
  }

  void obtenerDatosDeAPI(String userEmail) async {
    final url = Uri.http(_urlBase, '/api/datos-afiliados/correo/$userEmail');
    final respuesta = await http.get(url);
    setState(() {
      username = userEmail;
      jugador = json.decode(respuesta.body);
      id_afi = jugador['data']['id'];
      nombre = jugador['data']['nombre'];
      apellidoPaterno = jugador['data']['apellido_paterno'];
      apellidoMaterno = jugador['data']['apellido_materno'];
      obtenerSolicitudesDeAPI(jugador['data']['id']);
    });
  }

  void obtenerSolicitudesDeAPI(int id) async {
    id_afi = id;
    final url = Uri.http(_urlBase, '/api/lista_contratos/$id_afi');
    final respuesta2 = await http.get(url);
    setState(() {
      lista = List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
    });
    print(lista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF211A46),
          // title: Image.asset(
          //   'assets/logo3.png',
          //   width: 80,
          //   height: 50,
          // ),
          title: Center(
            child: Text(
              '',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  // Acción al presionar el IconButton
                  Navigator.pushReplacementNamed(context, 'homeroute');
                },
                icon: Image.asset('assets/logoblanco.png'),
              ),
            ),
          ]),
      body: FutureBuilder(
          // Reducimos la duración del tiempo de carga a medio segundo
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            // Verifica si el Future ha completado
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      for (final item in lista)
                        Card(
                          elevation: 5.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: ListTile(
                            title: Text(item['club']),
                            subtitle: Text(
                                'Fecha de Inicio: ${item["fecha_inicio"]}'),
                            // Agrega más detalles según sea necesario
                            onTap: () {
                              // Acciones al seleccionar un contrato
                              // Puedes abrir una pantalla de detalles o realizar otras acciones
                            },
                          ),
                        )
                    ],
                  ),
                ),
              );
            } else {
              // Muestra un indicador de carga mientras se está cargando
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Cargando',
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF211A46)),
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acciones al presionar el botón flotante (agregar contrato)
          // Puedes abrir una pantalla de creación de contrato o realizar otras acciones
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ContratoScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
