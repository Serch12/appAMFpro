import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/screens/solicitudes_2_screen.dart';

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
    final url = Uri.http(_urlBase, '/api/lista_solicitudes/$id_afi');
    final respuesta2 = await http.get(url);
    setState(() {
      lista = List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;

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
            leading: IconButton(
              onPressed: () {
                // Acción al presionar el botón de retroceso
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white, // Color blanco para el icono
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
              // Muestra tu contenido después de la carga
              return ListView(
                children: [
                  Container(
                    height: screenHeight -
                        appBarHeight, // Ajustar al tamaño de la pantalla después del AppBar
                    color: Color(0xFF211A46),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // padding: EdgeInsets.all(15),
                            height: (screenHeight - appBarHeight) /
                                9, // La mitad de la altura de la pantalla para el contenedor azul
                            color: Color(0xFF211A46),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('$nombre',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 23.0),
                                  child: Text(
                                      '$apellidoPaterno $apellidoMaterno',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Roboto')),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double
                                .infinity, // Ancho igual al ancho total de la pantalla
                            height: (screenHeight - appBarHeight) /
                                1.2, // La mitad de la altura de la pantalla para el contenedor blanco
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Center(
                                          child: Text(
                                            'Listado de solicitudes',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20.0), // Ajusta el radio según tus preferencias
                                            ),
                                            elevation: 10,
                                            child: Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TablaListado(
                                                        listado: lista)),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
          },
        ));
  }
}

class TablaListado extends StatefulWidget {
  final List<Map<String, dynamic>> listado;

  const TablaListado({Key? key, required this.listado}) : super(key: key);

  @override
  State<TablaListado> createState() => _TablaListadoState();
}

class _TablaListadoState extends State<TablaListado> {
  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.0),
        1: FlexColumnWidth(1.0),
        2: FlexColumnWidth(1.0),
      },
      children: [
        TableRow(
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Solicitud',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Estatus',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Acción',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        for (final item in widget.listado)
          TableRow(
            children: [
              TableCell(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['no_solicitud']
                          .toString(), // Ajusta el nombre de la clave según tus datos reales
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width *
                          0.03, // 5% del ancho de la pantalla
                      vertical: MediaQuery.of(context).size.height *
                          0.01, // 1% del alto de la pantalla
                    ),
                    decoration: BoxDecoration(
                      color: item['estatus'] == 0
                          ? Color(0x80ff6d00)
                          : Color(0x806EBC44),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      item['estatus'] == 0 ? 'En proceso' : 'Concluido',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navegar a otro screen aquí
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Solicitudes2Screen(value: item),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.visibility_outlined,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
