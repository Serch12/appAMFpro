import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:line_icons/line_icons.dart';
import 'package:splash_animated/screens/appbar_screen.dart';

class PagosScreen extends StatelessWidget {
  final Map<String, dynamic> pagos;
  const PagosScreen({super.key, required this.pagos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80.0,
          centerTitle: true,
          flexibleSpace: Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pagos',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 16.0, color: Colors.white, height: 6),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0XFF6EBC44),
          actions: [
            Padding(padding: EdgeInsets.only(right: 10.0), child: MyAppBar()),
          ]),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6EBC44), Colors.black],
                  stops: [
                    0.0,
                    0.01
                  ], // Ajusta las paradas de color según lo necesites
                ),
              ),
              child: Center(),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.check_circle_rounded,
                              color: Colors.green, size: 30.0),
                        ),
                        Text(
                          'Pagado',
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .end, // Alinea los elementos a los extremos
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.numbers,
                                        color: Color(0xff3C3C3B), size: 15.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Color(0xff3C3C3B),
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '1',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: Divider(
                                color: Color(0xFFC0BBBB),
                                height: 20,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Alinea los elementos a los extremos
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Color(0xff3C3C3B), size: 20.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    Text(
                                      'Cantidad acordada:',
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 11),
                                    ),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    Text(
                                      '50,000.00 - MXN',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Color(0xff3C3C3B), size: 20.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    Text(
                                      'Pena convencional:',
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 11),
                                    ),
                                    SizedBox(
                                        width:
                                            8.0), // Espacio entre el ícono y el texto
                                    Text(
                                      '0.00',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: Divider(
                                color: Color(0xFFC0BBBB),
                                height: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Alinea los elementos a los extremos
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month,
                                        color: Color(0xff3C3C3B), size: 20.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Color(0xff3C3C3B),
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                'Martes 26 de Septiembre de 2023',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 11),
                                    ),
                                    SizedBox(
                                        width:
                                            8.0), // Espacio entre el ícono y el texto
                                    Text(
                                      '0.00',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.access_time_filled,
                              color: Colors.orange, size: 30.0),
                        ),
                        Text(
                          'Pendiente',
                          style: TextStyle(color: Colors.orange),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .end, // Alinea los elementos a los extremos
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.numbers,
                                        color: Color(0xff3C3C3B), size: 15.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Color(0xff3C3C3B),
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '2',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: Divider(
                                color: Color(0xFFC0BBBB),
                                height: 20,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Alinea los elementos a los extremos
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Color(0xff3C3C3B), size: 20.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    Text(
                                      'Cantidad acordada:',
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 11),
                                    ),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    Text(
                                      '50,000.00 - MXN',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Color(0xff3C3C3B), size: 20.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    Text(
                                      'Pena convencional:',
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 11),
                                    ),
                                    SizedBox(
                                        width:
                                            8.0), // Espacio entre el ícono y el texto
                                    Text(
                                      '0.00',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: Divider(
                                color: Color(0xFFC0BBBB),
                                height: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Alinea los elementos a los extremos
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month,
                                        color: Color(0xff3C3C3B), size: 20.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Color(0xff3C3C3B),
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                'Martes 26 de Septiembre de 2023',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 11),
                                    ),
                                    SizedBox(
                                        width:
                                            8.0), // Espacio entre el ícono y el texto
                                    Text(
                                      '0.00',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
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
        ],
      )),
    );
  }
}
