import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/screens/screens.dart';

import '../services/services.dart';
import 'package:http/http.dart' as http;

class Solicitudes2Screen extends StatefulWidget {
  final dynamic value;
  const Solicitudes2Screen({Key? key, this.value}) : super(key: key);

  @override
  State<Solicitudes2Screen> createState() => _Solicitudes2ScreenState();
}

class _Solicitudes2ScreenState extends State<Solicitudes2Screen> {
  final String _urlBase = 'test-intranet.amfpro.mx';
  Map<String, dynamic> asesoria = {};
  Map<String, dynamic> controversia = {};
  Map<String, dynamic> audiencia = {};
  Map<String, dynamic> termino = {};
  Map<String, dynamic> pagos = {};
  Map<String, dynamic> documentacion = {};

  @override
  void initState() {
    super.initState();
    obtenerDatosDeAsesoriaAPI();
    obtenerDatosDeControversiaAPI();
    obtenerDatosDeDocumentacionAPI();
    obtenerDatosDeControversiaAudienciaAPI();
    obtenerDatosDeControversiaTerminoAPI();
    obtenerDatosDeControversiaPagosAPI();
  }

  void obtenerDatosDeAsesoriaAPI() async {
    String solicitud = widget.value['no_solicitud'];
    final url =
        Uri.http(_urlBase, '/api/lista_solicitudes/asesoria/$solicitud');
    final respuesta = await http.get(url);
    if (mounted) {
      setState(() {
        dynamic decodedResponse = json.decode(respuesta.body);

        if (decodedResponse is List && decodedResponse.isNotEmpty) {
          // Si la respuesta es una lista, toma el primer elemento
          asesoria = decodedResponse.first;
        } else {
          // Si la respuesta es un mapa, simplemente asígnalo
          asesoria = decodedResponse;
        }
      });
    }
  }

  void obtenerDatosDeControversiaAPI() async {
    String solicitud = widget.value['no_solicitud'];
    final url =
        Uri.http(_urlBase, '/api/lista_solicitudes/controversia/$solicitud');
    final respuesta = await http.get(url);
    if (mounted) {
      setState(() {
        dynamic decodedResponse = json.decode(respuesta.body);
        if (decodedResponse.isEmpty) {
        } else {
          if (decodedResponse is List) {
            // Si la respuesta es una lista, toma el primer elemento
            controversia = decodedResponse.first;
          } else {
            // Si la respuesta es un mapa, simplemente asígnalo
            controversia = decodedResponse;
          }
        }
      });
    }
  }

  void obtenerDatosDeDocumentacionAPI() async {
    String solicitud = widget.value['no_solicitud'];
    final url =
        Uri.http(_urlBase, '/api/lista_solicitudes/documentacion/$solicitud');
    final respuesta = await http.get(url);
    if (mounted) {
      setState(() {
        dynamic decodedResponse = json.decode(respuesta.body);
        if (decodedResponse.isEmpty) {
        } else {
          if (decodedResponse is List) {
            // Si la respuesta es una lista, toma el primer elemento
            documentacion = decodedResponse.first;
          } else {
            // Si la respuesta es un mapa, simplemente asígnalo
            documentacion = decodedResponse;
          }
        }
        print('Estos son los documentos: ${documentacion}');
      });
    }
  }

  void obtenerDatosDeControversiaAudienciaAPI() async {
    String solicitud = widget.value['no_solicitud'];
    final url =
        Uri.http(_urlBase, '/api/lista_solicitudes/audiencia/$solicitud');
    final respuesta = await http.get(url);
    if (mounted) {
      setState(() {
        dynamic decodedResponse = json.decode(respuesta.body);
        if (decodedResponse.isEmpty) {
        } else {
          if (decodedResponse is List) {
            // Si la respuesta es una lista, toma el primer elemento
            audiencia = decodedResponse.first;
          } else {
            // Si la respuesta es un mapa, simplemente asígnalo
            audiencia = decodedResponse;
          }
        }
        print(audiencia);
      });
    }
  }

  void obtenerDatosDeControversiaTerminoAPI() async {
    String solicitud = widget.value['no_solicitud'];
    final url = Uri.http(_urlBase, '/api/lista_solicitudes/termino/$solicitud');
    final respuesta = await http.get(url);
    if (mounted) {
      setState(() {
        dynamic decodedResponse = json.decode(respuesta.body);
        if (decodedResponse.isEmpty) {
        } else {
          if (decodedResponse is List) {
            // Si la respuesta es una lista, toma el primer elemento
            termino = decodedResponse.first;
          } else {
            // Si la respuesta es un mapa, simplemente asígnalo
            termino = decodedResponse;
          }
        }
        print('Estos son los terminos: ${termino}');
      });
    }
  }

  void obtenerDatosDeControversiaPagosAPI() async {
    String solicitud = widget.value['no_solicitud'];
    final url = Uri.http(_urlBase, '/api/lista_solicitudes/pagos/$solicitud');
    final respuesta = await http.get(url);
    if (mounted) {
      setState(() {
        dynamic decodedResponse = json.decode(respuesta.body);
        if (decodedResponse.isEmpty) {
        } else {
          if (decodedResponse is List) {
            // Si la respuesta es una lista, toma el primer elemento
            pagos = decodedResponse.first;
          } else {
            // Si la respuesta es un mapa, simplemente asígnalo
            pagos = decodedResponse;
          }
        }
        print('Estos son los pagos: ${pagos}');
      });
    }
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
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.55,
                          padding: EdgeInsets.all(15),
                          color: Color(0xFF211A46),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.value['nombre'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto'),
                                  textAlign: TextAlign.left),
                              const SizedBox(height: 20),
                              TablaSolicitudInicio(datos: widget.value),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: (screenHeight - appBarHeight) / 1.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: DefaultTabController(
                            length: 2, // Número de pestañas
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(text: 'Asesoria'),
                                    Tab(text: 'Controversía'),
                                  ],
                                  labelColor:
                                      Colors.black, // Color de etiqueta activa
                                  unselectedLabelColor: const Color(
                                      0xFF848587), // Color de etiqueta inactiva
                                  indicatorColor: const Color(
                                      0xFF211A46), // Cambia a tu color de
                                  labelStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      // Contenido de la Pestaña 1
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    // Estilo base
                                                    color: Colors
                                                        .black, // Puedes cambiar el color según tus necesidades
                                                    fontSize:
                                                        16.0, // Puedes ajustar el tamaño de fuente según tus necesidades
                                                    fontFamily: 'Roboto'),
                                                children: [
                                                  TextSpan(
                                                    text: 'Asesoria: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: asesoria['folio_ase'],
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            CardAsesoria(
                                                datos_asesoria: asesoria),
                                          ],
                                        ),
                                      ),

                                      // Contenido de la Pestaña 2

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            controversia.isEmpty
                                                ? Center(
                                                    child: Image.asset(
                                                    'assets/app.png',
                                                    width: 230,
                                                    height: 230,
                                                  ))
                                                : RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          // Estilo base
                                                          color: Colors
                                                              .black, // Puedes cambiar el color según tus necesidades
                                                          fontSize:
                                                              16.0, // Puedes ajustar el tamaño de fuente según tus necesidades
                                                          fontFamily: 'Roboto'),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'No. Expediente: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: controversia[
                                                              'expediente'],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            const SizedBox(height: 20),
                                            controversia.isEmpty
                                                ? Text(
                                                    '') // Provide a default value or expression
                                                : CardControversiaTabla(
                                                    controversia: controversia),
                                            const SizedBox(height: 10),
                                            controversia.isEmpty
                                                ? Text('')
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Flexible(
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          AudienciaScreen(
                                                                              audiencia: audiencia)),
                                                                );
                                                              },
                                                              child: Text(
                                                                'Audiencia',
                                                                style: TextStyle(
                                                                    fontSize: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        0.025,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Color(
                                                                    0XFF6EBC44),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 16),
                                                          Flexible(
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          TerminosScreen(
                                                                              termino: termino)),
                                                                );
                                                              },
                                                              child: Text(
                                                                'Términos',
                                                                style: TextStyle(
                                                                    fontSize: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        0.025,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Color(
                                                                    0XFF6EBC44),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 16),
                                                          Flexible(
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          PagosScreen(
                                                                              pagos: pagos)),
                                                                );
                                                              },
                                                              child: Text(
                                                                'Pagos',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                ),
                                                              ),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Color(
                                                                    0XFF6EBC44),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            32),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                        )
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
      ),
    );
  }
}

class CardControversiaTabla extends StatefulWidget {
  final Map<String, dynamic> controversia;
  const CardControversiaTabla({super.key, required this.controversia});

  @override
  State<CardControversiaTabla> createState() => _CardControversiaTablaState();
}

class _CardControversiaTablaState extends State<CardControversiaTabla> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              20.0), // Ajusta el radio según tus preferencias
        ),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Alinea los elementos a los extremos
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month,
                          color: Colors.black, size: 30.0),
                      SizedBox(width: 8.0), // Espacio entre el ícono y el texto
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(
                              text: 'Fecha de alta: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.controversia['fecha'],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Lógica cuando se presiona el botón
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       primary: Color(0xFFECEAF2), // Fondo gris del botón
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(
                  //             10.0), // Ajusta el radio según tus preferencias
                  //       )),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(
                  //         Icons.edit_outlined,
                  //         color: Colors.black,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.0),
                      1: FlexColumnWidth(1.0),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('División',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.controversia['division'],
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(33, 26, 70, 0.04),
                            borderRadius:
                                BorderRadius.circular(20.0)), // Fila blanca
                        children: [
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('VS Club:',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.controversia['vsclub'],
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Reclamo:',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(33, 26, 70, 0.04),
                            borderRadius:
                                BorderRadius.circular(20.0)), // Fila blanca
                        children: [
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Resuelto:',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.controversia['resuelto'],
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Observaciones:',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.0),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(33, 26, 70, 0.04),
                            borderRadius:
                                BorderRadius.circular(20.0)), // Fila blanca
                        children: [
                          TableCell(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    widget.controversia['observaciones'],
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Roboto')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }
}

class TablaSolicitudInicio extends StatefulWidget {
  final Map<String, dynamic> datos;
  const TablaSolicitudInicio({Key? key, required this.datos}) : super(key: key);
  @override
  State<TablaSolicitudInicio> createState() => _TablaSolicitudInicioState();
}

class _TablaSolicitudInicioState extends State<TablaSolicitudInicio> {
  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1.0),
        1: FlexColumnWidth(1.0),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.15),
              borderRadius: BorderRadius.circular(20.0)), // Fila blanca
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No.Solicitud:',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.datos['no_solicitud'].toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Nombre:',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.datos['nombre'].toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
        TableRow(
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.15),
              borderRadius: BorderRadius.circular(20.0)), // Fila blanca
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('División:',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.datos['division'].toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Club:',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.datos['club'].toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
        TableRow(
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.15),
              borderRadius: BorderRadius.circular(20.0)), // Fila blanca
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('NUI:',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.datos['nui'].toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Trámite:',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.datos['tramite'].toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
        TableRow(
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.15),
              borderRadius: BorderRadius.circular(20.0)), // Fila blanca
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Observaciones:',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.datos['observaciones'].toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Fecha inicial:',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.datos['fecha'].toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            )
          ],
        ),
        TableRow(
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.15),
              borderRadius: BorderRadius.circular(20.0)), // Fila blanca
          children: [
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Estatus:',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.white)),
                ),
              ),
            ),
            TableCell(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: widget.datos['estatus'] == 0
                        ? Color(0x80ff6d00)
                        : Color(0x806EBC44),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    widget.datos['estatus'] == 0 ? 'En proceso' : 'Concluido',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.025,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class CardAsesoria extends StatefulWidget {
  final Map<String, dynamic> datos_asesoria;
  const CardAsesoria({super.key, required this.datos_asesoria});

  @override
  State<CardAsesoria> createState() => _CardAsesoriaState();
}

class _CardAsesoriaState extends State<CardAsesoria> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              20.0), // Ajusta el radio según tus preferencias
        ),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Alinea los elementos a los extremos
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month,
                          color: Colors.black, size: 30.0),
                      SizedBox(width: 8.0), // Espacio entre el ícono y el texto
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(
                              text: 'Fecha de alta: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.datos_asesoria['fec_ase'],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Lógica cuando se presiona el botón
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       primary: Color(0xFFECEAF2), // Fondo gris del botón
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(
                  //             10.0), // Ajusta el radio según tus preferencias
                  //       )),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Icon(
                  //         Icons.edit_outlined,
                  //         color: Colors.black,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Hechos Manifestados:',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.datos_asesoria['hechos'] ?? '',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                color: Colors.black,
                height: 10,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Estatus actual:',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.datos_asesoria['pruebas'] ?? '',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                color: Colors.black,
                height: 10,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Asesoría:',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.datos_asesoria['asesoria'] ?? '',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 30.0),
                  SizedBox(width: 8.0), // Espacio entre el ícono y el texto
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontFamily: 'Roboto',
                      ),
                      children: [
                        TextSpan(
                          text: 'Atendió: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.datos_asesoria['atendio'] ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
