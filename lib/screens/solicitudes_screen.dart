import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:splash_animated/screens/appbar_screen.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/utils/auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  String controller6 = "assets/Solicitudes-icono-tipo.gif";

  String controller7 = "assets/Contratos-icono-tipo.gif";
  GlobalKey cardA = GlobalKey();
  int? id_afi;
  String? nombre;
  String? apellidoPaterno;
  String? apellidoMaterno;
  int? nui;
  String? username;
  int? no_tipo_sol;
  final String _urlBase = 'test-intranet.amfpro.mx';
  dynamic jugador = [];
  List<Map<String, dynamic>> lista = [];

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
              return Container(
                  padding: EdgeInsets.all(1),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ListaSolicitudesScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6EBC44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // Ajusta el radio según tus necesidades
                                ),
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width *
                                      0.30, // Ajusta el ancho del botón según el ancho de la pantalla
                                  MediaQuery.of(context).size.height *
                                      0.04, // Ajusta el alto del botón según el ancho de la pantalla
                                ),
                              ),
                              icon: Icon(
                                Icons.description_outlined,
                                color: Colors.white,
                              ), // Icono que se mostrará dentro del botón
                              label: Text(
                                'Mis solicitudes',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: ExpansionTile(
                          key: cardA,
                          title: Text(
                            'SERVICIOS',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Asesoría jurídica permanente',
                            style:
                                TextStyle(fontFamily: 'Roboto', fontSize: 10.5),
                          ),
                          leading: Image.asset(
                            'assets/juridico1.png',
                          ),
                          initiallyExpanded: true,
                          children: [
                            Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            Align(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 0)));
                                        },
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFECECEE),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'SOLICITUD DE COPIA DE CONVENIO DE TERMINACIÓN ANTICIPADA DE CONTRATO REGISTRADO EN LA FMF',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 1)));
                                        },
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFF6FEF2),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'PARA SOLICITUD DE REVISIÓN DE CONTRATO REGISTRADO EN LA FMF',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     Navigator.of(context).push(MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             nuevaSolicitudScreen(
                                      //                 id_afiliado2:
                                      //                     jugador['data']['id'],
                                      //                 nombre2: jugador['data']
                                      //                     ['nombre'],
                                      //                 ap2: jugador['data']
                                      //                     ['apellido_paterno'],
                                      //                 am2: jugador['data']
                                      //                     ['apellido_materno'],
                                      //                 nui2: jugador['data']
                                      //                     ['nui'],
                                      //                 no_tipo_sol: 2)));
                                      //   },
                                      //   borderRadius: BorderRadius.circular(
                                      //       10.0), // Para que la animación respete el borde redondeado
                                      //   child: Container(
                                      //     padding: EdgeInsets.all(10),
                                      //     decoration: BoxDecoration(
                                      //       color: Color(0XFFECECEE),
                                      //       borderRadius:
                                      //           BorderRadius.circular(10.0),
                                      //     ),
                                      //     margin: EdgeInsets.only(bottom: 5),
                                      //     child: Column(
                                      //       children: [
                                      //         Text(
                                      //           'SOLICITUD DE REVISIÓN DE VIGENCIA DE CONTRATO REGISTRADO EN LA FMF',
                                      //           style: TextStyle(fontSize: 10),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     Navigator.of(context).push(MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             nuevaSolicitudScreen(
                                      //                 id_afiliado2:
                                      //                     jugador['data']['id'],
                                      //                 nombre2: jugador['data']
                                      //                     ['nombre'],
                                      //                 ap2: jugador['data']
                                      //                     ['apellido_paterno'],
                                      //                 am2: jugador['data']
                                      //                     ['apellido_materno'],
                                      //                 nui2: jugador['data']
                                      //                     ['nui'],
                                      //                 no_tipo_sol: 3)));
                                      //   },
                                      //   borderRadius: BorderRadius.circular(
                                      //       10.0), // Para que la animación respete el borde redondeado
                                      //   child: Container(
                                      //     padding: EdgeInsets.all(10),
                                      //     decoration: BoxDecoration(
                                      //       color: Color(0XFFF6FEF2),
                                      //       borderRadius:
                                      //           BorderRadius.circular(10.0),
                                      //     ),
                                      //     margin: EdgeInsets.only(bottom: 5),
                                      //     child: Column(
                                      //       children: [
                                      //         Text(
                                      //           'SOLICITUD DE CONSULTA DE MINUTOS DE JUEGO COMO FUTBOLISTA PROFESIONAL',
                                      //           style: TextStyle(fontSize: 10),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 4)));
                                        },
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFECECEE),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'SOLICITUD DE ASESORÍA PARA FIRMA DE CONVENIO DE TERMINACIÓN ANTICIPADA DE CONTRATO',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 5)));
                                        },
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFF6FEF2),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'SOLICITUD DE ASESORÍA PARA CONOCER LOS DERECHOS Y OBLIGACIONES QUE TIENES COMO FUTBOLISTA PROFESIONAL',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 6)));
                                        },
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFECECEE),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'SOLICITUD DE ASESORÍA SOBRE LOS DERECHOS POR EMBARAZO Y MATERNIDAD (LIGA MX FEMENIL)',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 7)));
                                        },

                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFF6FEF2),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'SOLICITUD DE ELABORACIÓN DE FINIQUITO',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 8)));
                                        },
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFECECEE),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'SOLICITUD DE COPIA DE CONTRATO',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 9)));
                                        },
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFF6FEF2),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'SOLICITUD ESTATUS COMO FUTBOLISTA PROFESIONAL',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  nuevaSolicitudScreen(
                                                      id_afiliado2:
                                                          jugador['data']['id'],
                                                      nombre2: jugador['data']
                                                          ['nombre'],
                                                      ap2: jugador['data']
                                                          ['apellido_paterno'],
                                                      am2: jugador['data']
                                                          ['apellido_materno'],
                                                      nui2: jugador['data']
                                                          ['nui'],
                                                      no_tipo_sol: 10)));
                                        },
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Para que la animación respete el borde redondeado
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFECECEE),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                'SOLICITUD DE HISTORIAL DEPORTIVO',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ));
            } else {
              // Muestra un indicador de carga mientras se está cargando
              return Center(
                  child: Container(
                width: MediaQuery.of(context).size.width * 0.3, // Ancho del GIF
                height:
                    MediaQuery.of(context).size.height * 0.3, // Alto del GIF
                child: Image.asset(
                  "assets/balon-loading.gif",
                  key: UniqueKey(),
                  repeat: ImageRepeat.repeatX,
                ),
              ));
            }
          },
        ));
  }
}
