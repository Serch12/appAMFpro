import 'dart:convert';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:http/http.dart' as http;

class SolicitudesFiltroScreen extends StatefulWidget {
  final List<Map<String, dynamic>> listado;
  final id_afiliado;
  const SolicitudesFiltroScreen(
      {super.key, required this.listado, required this.id_afiliado});

  @override
  State<SolicitudesFiltroScreen> createState() =>
      _SolicitudesFiltroScreenState();
}

class _SolicitudesFiltroScreenState extends State<SolicitudesFiltroScreen> {
  List<Map<String, dynamic>> listadofinal = [];
  int banderacheck = 0;
  bool positive = false;
  bool positive2 = false;
  bool positive3 = false;
  int estatussolicitud = 0;
  bool isLoading = false;
  final String _urlBase = 'test-intranet.amfpro.mx';

  void obtenerSolicitudesDeAPIEstatus(int estatusnuevo) async {
    isLoading = true;
    setState(() {});
    final url = Uri.http(_urlBase,
        '/api/lista_solicitudes_filtrado/${widget.id_afiliado}/${estatusnuevo}');
    final respuesta2 = await http.get(url);
    if (mounted) {
      setState(() {
        listadofinal =
            List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
      });
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, top: 30, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    color: Color(0xFF6EBC44),
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'MIS SOLICITUDES',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Flexible(
                    child: AnimatedToggleSwitch<bool>.dual(
                      current: positive,
                      first: false,
                      second: true,
                      spacing: MediaQuery.of(context).size.width *
                          0.14, // Espacio entre los elementos
                      style: ToggleStyle(
                        backgroundColor:
                            positive ? Color(0xff2E2A60) : Colors.white,
                        borderColor: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff2E2A60),
                            spreadRadius: MediaQuery.of(context).size.width *
                                0.001, // Radio de dispersión de la sombra
                            // blurRadius: MediaQuery.of(context).size.width *
                            //     0.01, // Radio de desenfoque de la sombra
                            offset: Offset(
                                0,
                                MediaQuery.of(context).size.width *
                                    0.01), // Desplazamiento de la sombra
                          ),
                        ],
                      ),
                      borderWidth: MediaQuery.of(context).size.width *
                          0.01, // Ancho del borde
                      height: MediaQuery.of(context).size.height *
                          0.035, // Altura del widget
                      indicatorSize: Size(27, 25),
                      onChanged: (b) {
                        setState(() {
                          positive = b;
                          positive2 = false;
                          positive3 = false;
                          positive == false
                              ? estatussolicitud = 3
                              : estatussolicitud = 0;
                          banderacheck = 1;
                          obtenerSolicitudesDeAPIEstatus(estatussolicitud);
                        });
                      },
                      styleBuilder: (b) => ToggleStyle(
                        indicatorColor: b ? Colors.white : Color(0xff2E2A60),
                      ),
                      iconBuilder: (value) => value
                          ? Image.asset(
                              'assets/F4.png',
                            )
                          : Image.asset(
                              'assets/F1.png',
                            ),
                      textBuilder: (value) => value
                          ? Center(
                              child: Text(
                                'En proceso',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.028, // Tamaño de fuente
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                'En proceso',
                                style: TextStyle(
                                  color: Color(0xff2E2A60),
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.028, // Tamaño de fuente
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: AnimatedToggleSwitch<bool>.dual(
                      current: positive2,
                      first: false,
                      second: true,
                      spacing: MediaQuery.of(context).size.width *
                          0.14, // Espacio entre los elementos
                      style: ToggleStyle(
                        backgroundColor: positive2 == true
                            ? Color(0xffFF0000)
                            : Colors.white,
                        borderColor: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffFF0000),
                            spreadRadius: MediaQuery.of(context).size.width *
                                0.001, // Radio de dispersión de la sombra
                            // blurRadius: MediaQuery.of(context).size.width *
                            //     0.01, // Radio de desenfoque de la sombra
                            offset: Offset(
                                0,
                                MediaQuery.of(context).size.width *
                                    0.01), // Desplazamiento de la sombra
                          ),
                        ],
                      ),
                      borderWidth: MediaQuery.of(context).size.width *
                          0.01, // Ancho del borde
                      height: MediaQuery.of(context).size.height *
                          0.035, // Altura del widget
                      indicatorSize: Size(27, 25),
                      onChanged: (b) {
                        setState(() {
                          positive2 = b;
                          positive = false;
                          positive3 = false;
                          positive2 == false
                              ? estatussolicitud = 3
                              : estatussolicitud = 2;
                          banderacheck = 1;
                          obtenerSolicitudesDeAPIEstatus(estatussolicitud);
                        });
                      },
                      styleBuilder: (b) => ToggleStyle(
                          indicatorColor: b ? Colors.white : Color(0xffFF0000)),
                      iconBuilder: (value) => value
                          ? Image.asset(
                              'assets/F5.png',
                            )
                          : Image.asset(
                              'assets/F2.png',
                            ),
                      textBuilder: (value) => value
                          ? Center(
                              child: Text(
                              'Controversia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.026, // Tamaño de fuente
                              ),
                            ))
                          : Center(
                              child: Text(
                              'Controversia',
                              style: TextStyle(
                                color: Color(0xffFF0000),
                                fontSize: MediaQuery.of(context).size.width *
                                    0.026, // Tamaño de fuente
                              ),
                            )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: AnimatedToggleSwitch<bool>.dual(
                      current: positive3,
                      first: false,
                      second: true,
                      spacing: MediaQuery.of(context).size.width *
                          0.14, // Espacio entre los elementos
                      style: ToggleStyle(
                        backgroundColor: positive3 == true
                            ? Color(0xff4FC028)
                            : Colors.white,
                        borderColor: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff4FC028),
                            spreadRadius: MediaQuery.of(context).size.width *
                                0.001, // Radio de dispersión de la sombra
                            // blurRadius: MediaQuery.of(context).size.width *
                            //     0.01, // Radio de desenfoque de la sombra
                            offset: Offset(
                                0,
                                MediaQuery.of(context).size.width *
                                    0.01), // Desplazamiento de la sombra
                          ),
                        ],
                      ),
                      borderWidth: MediaQuery.of(context).size.width *
                          0.01, // Ancho del borde
                      height: MediaQuery.of(context).size.height *
                          0.035, // Altura del widget
                      indicatorSize: Size(27, 25),
                      onChanged: (b) {
                        setState(() {
                          positive3 = b;
                          positive2 = false;
                          positive = false;

                          positive3 == false
                              ? estatussolicitud = 3
                              : estatussolicitud = 1;
                          banderacheck = 1;
                          obtenerSolicitudesDeAPIEstatus(estatussolicitud);
                        });
                      },
                      styleBuilder: (b) => ToggleStyle(
                          indicatorColor: b ? Colors.white : Color(0xff4FC028)),
                      iconBuilder: (value) => value
                          ? Image.asset(
                              'assets/F6.png',
                            )
                          : Image.asset(
                              'assets/F3.png',
                            ),
                      textBuilder: (value) => value
                          ? Center(
                              child: Text(
                              'Concluido',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.03, // Tamaño de fuente
                              ),
                            ))
                          : Center(
                              child: Text(
                              'Concluido',
                              style: TextStyle(
                                color: Color(0xff4FC028),
                                fontSize: MediaQuery.of(context).size.width *
                                    0.03, // Tamaño de fuente
                              ),
                            )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        if (isLoading)
          Container(
            // color: Colors.black.withOpacity(0.5),
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (!isLoading && widget.listado.isEmpty)
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6, // Ancho del GIF
              child: Image.asset(
                "assets/sininfo.gif",
                key: UniqueKey(),
                repeat: ImageRepeat.noRepeat,
              ),
            ),
          ),
        if (!isLoading && widget.listado.isNotEmpty)
          Container(
            child: TablaListado(
              listado2: widget.listado,
              listadofiltrado: listadofinal,
              bandera: banderacheck,
            ),
          ),
      ],
    );
  }
}

class TablaListado extends StatefulWidget {
  final List<Map<String, dynamic>> listado2;
  final List<Map<String, dynamic>> listadofiltrado;
  final int bandera;

  const TablaListado(
      {Key? key,
      required this.listado2,
      required this.bandera,
      required this.listadofiltrado})
      : super(key: key);

  @override
  State<TablaListado> createState() => _TablaListadoState();
}

class _TablaListadoState extends State<TablaListado> {
  Future<void> _eliminaSolicitud(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar la solicitud?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo actual
                _siAceptaEliminar(id);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _siAceptaEliminar(id) async {
    showDialog(
      context: context, // Usa el contexto del Builder
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    await Future.delayed(Duration(seconds: 3));
    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/eliminar-solicitud-api/${id}');
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode == 404 || response.statusCode == 200) {
      showDialog(
        context: context, // Usa el contexto del Builder
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF1AD598)),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Solicitud eliminada correctamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo de éxito
                    Navigator.pushReplacementNamed(context, 'homeroutetres');
                  },
                  child: Icon(Icons.clear, color: Colors.black),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: [],
          );
        },
      );
    } else {
      showDialog(
        context: context, // Usa el contexto del Builder
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Error al eliminar la solicitud',
                    style: TextStyle(color: Colors.red),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo de error
                  },
                  child: Icon(Icons.clear, color: Colors.black),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: [],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          for (final item
              in widget.bandera == 0 ? widget.listado2 : widget.listadofiltrado)
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20), // Radio de borde del card
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: item['estatus'] == 0 || item['estatus'] == 3
                  //         ? Color(0xff2E2A60)
                  //         : item['estatus'] == 1
                  //             ? Color(0xff4FC028)
                  //             : Color(0xffFF0000),
                  //     spreadRadius: 0, // Radio de dispersión
                  //     // blurRadius: 5, // Radio de desenfoque
                  //     offset: Offset(0, 1), // Desplazamiento en eje Y
                  //   ),
                  // ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 10,
                  shadowColor: item['estatus'] == 0 || item['estatus'] == 3
                      ? Color(0xff2E2A60)
                      : item['estatus'] == 1
                          ? Color(0xff4FC028)
                          : Color(0xffFF0000),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // Alinea los elementos a los extremos
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month,
                                            color: Color(0xff6D6F70),
                                            size: 20.0),
                                        SizedBox(
                                            width:
                                                5.0), // Espacio entre el ícono y el texto
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Color(0xff6D6F70),
                                              fontSize: 14.0,
                                              fontFamily: 'Roboto',
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "Fecha de Alta:",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              TextSpan(
                                                text: item['fecha'].toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Navegar a otro screen aquí
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Solicitudes2Screen(
                                                        value: item),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/eye-plus.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                          ),
                                        ),
                                        item['estatus'] == 3
                                            ? GestureDetector(
                                                onTap: () {
                                                  _eliminaSolicitud(
                                                      item['id_sol']);
                                                },
                                                child: Image.asset(
                                                  'assets/delete-solicitud.png',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06,
                                                ),
                                              )
                                            : Text(''),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  child: Divider(
                                    color: item['estatus'] == 0 ||
                                            item['estatus'] == 3
                                        ? Color(0xff2E2A60)
                                        : item['estatus'] == 1
                                            ? Color(0xff4FC028)
                                            : Color(0xffFF0000),
                                    height: 40,
                                  ),
                                ),
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1.0),
                                    1: FlexColumnWidth(1.0),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment
                                                  .middle, // Alinea verticalmente el contenido
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('No.Solicitud:',
                                                  style: TextStyle(
                                                    fontSize:
                                                        12, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto',
                                                    color: Color(0xFF6D6F70),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment
                                                  .middle, // Alinea verticalmente el contenido
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.025,
                                                  child: Text(
                                                    item['no_solicitud']
                                                        .toString(), // Ajusta el nombre de la clave según tus datos reales,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF6D6F70),
                                                        fontSize: 12),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: item['estatus'] == 0 ||
                                                item['estatus'] == 3
                                            ? Color(0xff2E2A60)
                                            : item['estatus'] == 1
                                                ? Color(0xff4FC028)
                                                : Color(0xffFF0000),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment
                                                  .middle, // Alinea verticalmente el contenido
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Estatus:',
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize:
                                                          12, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment
                                                  .middle, // Alinea verticalmente el contenido
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    item['estatus'] == 0 ||
                                                            item['estatus'] == 3
                                                        ? 'En proceso'
                                                        : item['estatus'] == 1
                                                            ? 'Concluido'
                                                            : 'Controversia',
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      color: Color(0xFF6D6F70),
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
