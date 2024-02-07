import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:accordion/accordion.dart';
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
  static const headerStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto');
  static const contentStyle = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  static const loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

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

  void _mostrarModal(BuildContext context, String imagen) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Color(0xFFD9D9D9)
              .withOpacity(0.47), // Define el color de fondo con transparencia
          content: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Utiliza el 80% del ancho del dispositivo
            height: MediaQuery.of(context).size.height *
                0.6, // Utiliza el 80% del ancho del dispositivo
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(
                  'https://test-intranet.amfpro.mx/ArchivosSistema/ContratosJugadores/$imagen',
                  fit: BoxFit.contain, // Ajusta la imagen dentro del contenedor
                  width: MediaQuery.of(context).size.width *
                      0.8, // Tamaño máximo de la imagen
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
                // SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop(); // Cerrar el diálogo
                //   },
                //   child: Text('Cerrar'),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.white,
                //     onPrimary: Colors.green,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
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
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'Listado de contratos',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Accordion(
                        children: [
                          for (final item in lista)
                            AccordionSection(
                              // isOpen: true,
                              contentVerticalPadding: 10,
                              headerPadding: EdgeInsets.all(22),
                              headerBackgroundColor: Color(0xFF6EBC44),
                              header: Text(item['club'], style: headerStyle),
                              headerBorderRadius: 20,
                              // contentBackgroundColor: Colors.lightBlue,
                              contentBorderColor: Colors.transparent,
                              // contentBorderWidth: 10,
                              contentBackgroundColor: Colors.transparent,
                              content: Card(
                                elevation: 3.0,
                                // margin: EdgeInsets.symmetric(
                                //     horizontal: 16.0, vertical: 8.0),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start, // Alinea los elementos a los extremos
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/image9.png',
                                              width: 22, height: 22),
                                          SizedBox(
                                              width:
                                                  30.0), // Espacio entre el ícono y el texto
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Fecha de Inicio:',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff020202),
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                item['fecha_inicio'],
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Color(0xff384455),
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset('assets/image6.png',
                                              width: 22, height: 22),
                                          SizedBox(
                                              width:
                                                  30.0), // Espacio entre el ícono y el texto
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Fecha de Vencimiento:',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff020202),
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                item['fecha_vencimiento'],
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Color(0xff384455),
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset('assets/image7.png',
                                              width: 22, height: 22),
                                          SizedBox(
                                              width:
                                                  30.0), // Espacio entre el ícono y el texto
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'División:',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff020202),
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                item['division'],
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Color(0xff384455),
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset('assets/image8.png',
                                              width: 22, height: 22),
                                          SizedBox(
                                              width:
                                                  30.0), // Espacio entre el ícono y el texto
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Club:',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff020202),
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                item['club'],
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Color(0xff384455),
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          disabledColor: Colors.grey,
                                          elevation: 0,
                                          color: Colors.black,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.018,
                                            ),
                                            child: Text(
                                              'Ver contrato',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          //si loginform no ejecuta arroha null de lo contrario entra a la ejecucion
                                          onPressed: () async {
                                            _mostrarModal(context,
                                                item['archivo_contrato']);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              rightIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),

                          // Agrega más elementos según sea necesario
                        ],
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
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF211A46),
      ),
    );
  }
}
