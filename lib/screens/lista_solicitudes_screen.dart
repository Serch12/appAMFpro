import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/screens/appbar_screen.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:pulsator/pulsator.dart';
import '../services/services.dart';
import 'package:http/http.dart' as http;

class ListaSolicitudesScreen extends StatefulWidget {
  const ListaSolicitudesScreen({Key? key}) : super(key: key);

  @override
  State<ListaSolicitudesScreen> createState() => _ListaSolicitudesScreenState();
}

class _ListaSolicitudesScreenState extends State<ListaSolicitudesScreen> {
  String? username;
  final String _urlBase = 'test-intranet.amfpro.mx';
  dynamic jugador = [];
  List<Map<String, dynamic>> lista = [];
  int? id_afi;
  String? nombre;
  String? apellidoPaterno;
  String? apellidoMaterno;
  int? nui;

  @override
  void initState() {
    super.initState();
    cargarUsername();
  }

  void cargarUsername() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final userDataString = await authService.autenticacion();

    // ignore: unnecessary_null_comparison
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
    if (mounted) {
      setState(() {
        username = userEmail;
        jugador = json.decode(respuesta.body);
        id_afi = jugador['data']['id'];
        nombre = jugador['data']['nombre'];
        apellidoPaterno = jugador['data']['apellido_paterno'];
        apellidoMaterno = jugador['data']['apellido_materno'];
        nui = jugador['data']['nui'];
        obtenerSolicitudesDeAPI(jugador['data']['id']);
      });
    }
  }

  void obtenerSolicitudesDeAPI(int id) async {
    id_afi = id;
    final url = Uri.http(_urlBase, '/api/lista_solicitudes/$id_afi');
    final respuesta2 = await http.get(url);
    if (mounted) {
      setState(() {
        lista = List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context, listen: false);
    // Precarga el GIF de carga al inicio del screen
    precacheImage(AssetImage('assets/balon-loading.gif'), context);

    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height *
              0.07, // Ajusta el alto del AppBar según el tamaño de la pantalla
          centerTitle: true,
          flexibleSpace: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.03), // Espacio para bajar la imagen
                Image.asset(
                  'assets/logoblanco.png',
                  // width: MediaQuery.of(context).size.width * 0.07,
                  height: MediaQuery.of(context).size.height * 0.04,
                )
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6EBC44),
                  Color(0xFF000000),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          actions: [
            Padding(padding: EdgeInsets.only(right: 10.0), child: MyAppBar()),
          ]),
      body: FutureBuilder(
        // Reducimos la duración del tiempo de carga a medio segundo
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, snapshot) {
          // Verifica si el Future ha completado
          if (snapshot.connectionState == ConnectionState.done) {
            // Muestra tu contenido después de la carga
            return SolicitudesFiltroScreen(listado: lista, id_afiliado: id_afi);
          } else {
            // Muestra un indicador de carga mientras se está cargando
            return Center(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.3, // Ancho del GIF
              height: MediaQuery.of(context).size.height * 0.3, // Alto del GIF
              child: Image.asset(
                "assets/balon-loading.gif",
                key: UniqueKey(),
                repeat: ImageRepeat.repeatX,
              ),
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acciones al presionar el botón flotante (agregar contrato)
          // Puedes abrir una pantalla de creación de contrato o realizar otras acciones
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => nuevaSolicitudScreen(
                  id_afiliado2: jugador['data']['id'],
                  nombre2: jugador['data']['nombre'],
                  ap2: jugador['data']['apellido_paterno'],
                  am2: jugador['data']['apellido_materno'],
                  nui2: jugador['data']['nui'])));
        },
        child: PulseIcon(
          icon: Icons.add,
          pulseColor: Color(0xff4FC028),
          innerSize: 30.0,
          pulseSize: 100.0,
          iconSize: 30,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        mini: false,
      ),
    );
  }
}
