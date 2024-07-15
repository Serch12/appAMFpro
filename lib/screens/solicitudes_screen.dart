import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:splash_animated/screens/appbar_screen.dart';
import 'package:splash_animated/screens/screens.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  String controller6 = "assets/Solicitudes-icono-tipo.gif";

  String controller7 = "assets/Contratos-icono-tipo.gif";
  GlobalKey cardA = GlobalKey();
  GlobalKey cardB = GlobalKey();
  List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<bool> activo = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
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
        body: Container(
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
                                0.05, // Ajusta el alto del botón según el ancho de la pantalla
                          ),
                        ),
                        icon: Icon(Icons
                            .description_outlined), // Icono que se mostrará dentro del botón
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
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),
                    leading: Image.asset(
                      'assets/juridico1.png',
                    ),
                    children: [
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    FilterChip(
                                      selected: isSelected[0],
                                      selectedColor: Colors.green,
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('S'),
                                      // ),
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[0] = value;
                                        });
                                      },
                                      label: Container(
                                        padding: EdgeInsets.only(top: 6),
                                        height: 30,
                                        width: double.infinity,
                                        child: Wrap(
                                          children: [
                                            Text(
                                              'Obtención de Finiquito',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: isSelected[0]
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('S'),
                                      // ),
                                      selected: isSelected[1],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[1] = value;
                                        });
                                      },
                                      label: Container(
                                        padding: EdgeInsets.only(top: 6),
                                        height: 30,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Solicitud Copia de',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'Contrato',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('S'),
                                      // ),
                                      selected: isSelected[2],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[2] = value;
                                        });
                                      },
                                      label: Container(
                                        height: 30,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Solicitud de Copia de',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'Terminación Anticipada',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('S'),
                                      // ),
                                      selected: isSelected[3],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[3] = value;
                                        });
                                      },
                                      label: Container(
                                        height: 30,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Solicitud de Estatus',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'Deportivo',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('S'),
                                      // ),
                                      selected: isSelected[4],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[4] = value;
                                        });
                                      },
                                      label: Container(
                                        height: 30,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Solicitud de Historial',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'Deportivo',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('R'),
                                      // ),
                                      selected: isSelected[5],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[5] = value;
                                        });
                                      },
                                      label: Container(
                                        padding: EdgeInsets.only(top: 6),
                                        height: 30,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Revisión de Contrato',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('C'),
                                      // ),
                                      selected: isSelected[6],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[6] = value;
                                        });
                                      },
                                      label: Container(
                                        height: 30,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Consulta de vigencia de',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'contrato',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('C'),
                                      // ),
                                      selected: isSelected[7],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[7] = value;
                                        });
                                      },
                                      label: Container(
                                        height: 30,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Consulta de minutos de',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'juego',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('F'),
                                      // ),
                                      selected: isSelected[8],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[8] = value;
                                        });
                                      },
                                      label: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.032,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Firma de Convenio de',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'Terminación Anticipada',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('D'),
                                      // ),
                                      selected: isSelected[9],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[9] = value;
                                        });
                                      },
                                      label: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.032,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Derechos y Obligaciones',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'como Futbolista Profesional',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          )
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('D'),
                                      // ),
                                      selected: isSelected[10],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[10] = value;
                                        });
                                      },
                                      label: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.032,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Derechos por embarazo y',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'maternidad (Liga MX Femenil)',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          )
                                        ]),
                                      ),
                                    ),
                                    FilterChip(
                                      // avatar: CircleAvatar(
                                      //   backgroundColor: Colors.grey.shade800,
                                      //   child: const Text('O'),
                                      // ),
                                      selected: isSelected[11],
                                      onSelected: (value) {
                                        print(value);
                                        setState(() {
                                          isSelected[11] = value;
                                        });
                                      },
                                      label: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.032,
                                        width: double
                                            .infinity, // Ocupa todo el ancho disponible

                                        child: Wrap(children: [
                                          Text(
                                            'Otros (especificar que',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'requiere cada jugador)',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ExpansionTile(
                    key: cardB,
                    title: Text(
                      'PROCESOS',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Representación e controversias presentadas ante la Comisión de Controversias CCRC',
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),
                    leading: Image.asset(
                      'assets/juridico2.png',
                    ),
                    children: [
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[0] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Adeudo de Salarios'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[0],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[0] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[1] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Rescisión de Contrato + Indemnización'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[1],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[1] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[2] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Despido Injustificado + Indemnización'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[2],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[2] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[3] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Pago de Porcentaje por Transferencia'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[3],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[3] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[4] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Incumplimiento de Convenio'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[4],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[4] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[5] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Lesión'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[5],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[5] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[6] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Rembolso de Gastos Médicos'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[6],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[6] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[7] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Adeudo de Premios en el Contrato'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[7],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[7] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[8] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Adeudo de Bonos en el Contrato'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[8],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[8] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  color: activo[9] == false
                                      ? Color(0XFFECECEE)
                                      : Color(0XFFF6FEF2),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Reinstalación por Despido Injustificado'),
                                      Switch(
                                        // This bool value toggles the switch.
                                        value: activo[10],
                                        activeColor: Color(0XFF6EBC44),
                                        onChanged: (bool value) {
                                          // This is called when the user toggles the switch.
                                          setState(() {
                                            activo[10] = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
