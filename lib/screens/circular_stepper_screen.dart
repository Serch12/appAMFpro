import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:splash_animated/utils/auth.dart';
import 'appbar_screen.dart';
// import 'package:icon_checkbox/icon_checkbox.dart';

class ImageCheckbox extends StatelessWidget {
  final String checkedImage;
  final String uncheckedImage;
  final bool value;
  final ValueChanged<bool> onChanged;

  ImageCheckbox({
    required this.checkedImage,
    required this.uncheckedImage,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            value ? checkedImage : uncheckedImage,
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
  }
}

class CircularStepperDemo extends StatefulWidget {
  @override
  State<CircularStepperDemo> createState() => _CircularStepperDemoState();
}

class _CircularStepperDemoState extends State<CircularStepperDemo> {
  DateTime _focusedDay = DateTime.now();
  bool uno = true;
  bool dos = false;
  bool tres = false;
  bool cuatro = false;
  bool cinco = false;
  bool seis = false;
  DateTime? _selectedDay;
  String selectedInjury = ''; // Store the selected injury
  bool mostrar = false;
  final formSolicitudLesion = GlobalKey<FormState>();
  int? id;
  late TextEditingController tipo_evento;
  late TextEditingController descripcion_lesion;
  late String? lesion;
  DateTime fecha_evento = DateTime.now();
  late String? username = "";
  dynamic jugador = [];
  late List<Map<String, dynamic>> lista = [];
  late List<Map<String, dynamic>> listaMesAnterior = [];
  int? id_afi;
  int? nui;
  late String _urlBase = 'test-intranet.amfpro.mx';

  Future<void> _nuevaSolicitudLesion() async {
    // Mostrar el indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el usuario pueda cerrar el diálogo
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Indicador de carga circular
        );
      },
    );
    // Simula una espera de 3 segundos para demostración
    await Future.delayed(Duration(seconds: 3));

    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/create-nuevo-seguimiento'); // Reemplaza con la URL de tu API de Laravel
    Map<String, dynamic> data = {
      "id_afiliado": id_afi,
      "fecha_evento": DateFormat('yyyy-MM-dd').format(fecha_evento),
      "tipo_evento": tipo_evento.text,
      // Campos datos deportivos
      "lesion": lesion,
      "descripcion_lesion": descripcion_lesion.text,
      "estatus": 0
    };

// String jsonData = jsonEncode(data);

    final response = await http.post(url, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    });

    if (response.statusCode == 200) {
      // El usuario se registró exitosamente
      // ocultar el teclado
      FocusScope.of(context).unfocus();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.check_circle,
                    color: Color(0xFF1AD598)), // Icono a la izquierda del texto
                SizedBox(width: 10.0), // Espacio entre el icono y el texto
                Expanded(
                  child: Text(
                    'Se creo seguimiento de lesión exitosamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap:
                        true, // Permite que el texto se ajuste al ancho disponible
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                          context, 'homeroutecuatro');
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.black,
                    )),
              ],
            ),

            contentPadding: EdgeInsets.fromLTRB(
                15.0, 10.0, 0.0, 0.0), // Ajustar el padding del contenido
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Ajustar el radio del borde
            ),
            actions: [],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.cancel,
                    color: Colors.red), // Icono a la izquierda del texto
                SizedBox(width: 10.0), // Espacio entre el icono y el texto

                Expanded(
                  child: Text(
                    'Error al registrar seguimiento de lesión.',
                    style: TextStyle(color: Colors.red),
                    overflow: TextOverflow.visible,
                    softWrap: true, // Permite que el texto se desborde
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Cerrar la alerta al presionar el botón
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.black,
                    )),
              ],
            ),

            contentPadding: EdgeInsets.fromLTRB(
                15.0, 10.0, 0.0, 0.0), // Ajustar el padding del contenido
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Ajustar el radio del borde
            ),
            actions: [],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    cargarUsername();
    tipo_evento = TextEditingController(text: "Jugador");
    descripcion_lesion = TextEditingController(text: "");
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
        nui = jugador['data']['nui'];
        obtenerLesionesDeAPI(jugador['data']['id']);
        obtenerLesionesDeAPIMesAnterior(jugador['data']['id']);
      });
    }
  }

  void obtenerLesionesDeAPI(int id) async {
    id_afi = id;
    final url = Uri.http(_urlBase, '/api/lista_lesiones/$id_afi');
    final respuesta2 = await http.get(url);
    if (mounted) {
      setState(() {
        lista = List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
      });
    }
  }

  void obtenerLesionesDeAPIMesAnterior(int id) async {
    id_afi = id;
    final url = Uri.http(_urlBase, '/api/lista_lesiones_mes_anterior/$id_afi');
    final respuesta3 = await http.get(url);
    if (mounted) {
      setState(() {
        listaMesAnterior =
            List<Map<String, dynamic>>.from(json.decode(respuesta3.body));
      });
    }
  }

  @override
  void dispose() {
    tipo_evento.dispose();
    descripcion_lesion.dispose();
    super.dispose();
  }

  void _onCheckboxChanged(String value) {
    setState(() {
      if (selectedInjury == value) {
        selectedInjury = '';
        mostrar = false;
      } else {
        selectedInjury = value;
        lesion = selectedInjury;
        mostrar = (value == 'Otro' || value == 'Lesion grave');
      }
    });
  }

  final kToday = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final kFirstDay = DateTime(kToday.year, kToday.month - 1, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 1, kToday.day);

    int year = DateTime.now().year;

    int month = DateTime.now().month;
    DateTime thisMonth = DateTime(year, month, 0);
    DateTime nextMonth = DateTime(year, month + 1, 0);
    int totalDiasMesActual = nextMonth.difference(thisMonth).inDays;

    int monthPrevious = DateTime.now().month - 1;
    // Ajusta el año si es necesario (es decir, si estamos en enero)
    if (monthPrevious == 0) {
      monthPrevious = 12;
      year = DateTime.now().year - 1;
    }
    DateTime thisMonthPrevious = DateTime(year, monthPrevious, 1);
    DateTime nextMonthPrevious = DateTime(year, DateTime.now().month, 1);
    int totalDiasMesAnterior =
        nextMonthPrevious.difference(thisMonthPrevious).inDays;
    // Convertir lista a Set para una búsqueda rápida
    Set<dynamic?> diasEnLista = lista.map((item) => item['dia']).toSet();
    Set<dynamic?> lesionesEnLista = lista.map((item) => item['lesion']).toSet();
    Set<dynamic?> diasEnListaMesAnterior =
        listaMesAnterior.map((item) => item['dia']).toSet();
    Set<dynamic?> lesionesEnListaMesAnterior =
        listaMesAnterior.map((item) => item['lesion']).toSet();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                locale: 'es_ES',
                firstDay: kFirstDay,
                lastDay: kLastDay,
                headerStyle: const HeaderStyle(
                    titleCentered: true, formatButtonVisible: false),
                calendarStyle: CalendarStyle(
                    todayTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF6EBC44),
                    )),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      fecha_evento = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    print(fecha_evento);
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),
              SizedBox(height: 100),
              Container(
                  width: screenWidth * 0.45,
                  child: CircularDosStepper(onStepChanged: (stepText) async {
                    print(tipo_evento.text);
                    setState(() {
                      tipo_evento.text = stepText;
                    });
                  })),
              SizedBox(height: 15),
              tipo_evento.text != 'Jugador'
                  ? Container(
                      width: screenWidth * 1,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('¡Hola!',
                              style: TextStyle(
                                  color: Color(0xFF979797),
                                  fontFamily: 'Roboto',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  fontWeight: FontWeight.bold)),
                          Text('¿Tuviste una lesión en el partido de hoy?',
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontFamily: 'Roboto',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                              )),
                        ],
                      ),
                    )
                  : Container(
                      width: screenWidth,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Seguimiento de lesiones',
                                  style: TextStyle(
                                      color: Color(0xFF979797),
                                      fontFamily: 'Roboto',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  'Insidentes registrados durante los partidos.',
                                  style: TextStyle(
                                    color: Color(0xFF979797),
                                    fontFamily: 'Roboto',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.025,
                                  )),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetalleLesionesScreen(
                                      id_afiliado: id_afi!)));
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 12,
                              backgroundColor: Color(0xFF4FC028),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25.0), // Ajusta el radio según tus necesidades
                              ),
                              minimumSize: Size(
                                  80, 30), // Ajusta el tamaño mínimo del botón
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Ver todos',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.025),
                                ),
                                Icon(Icons.arrow_right)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 10),
              tipo_evento.text != 'Jugador'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            ImageCheckbox(
                              checkedImage: 'assets/codon.png',
                              uncheckedImage: 'assets/codo.png',
                              value: selectedInjury == 'Esguince de tobillo',
                              onChanged: (value) {
                                _onCheckboxChanged('Esguince de tobillo');
                              },
                            ),
                            Text(
                              'Esguince de',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.02,
                                  color: Color(0xFF979797)),
                            ),
                            Text('tobillo',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797)))
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            ImageCheckbox(
                              checkedImage: 'assets/nuevalesionrodilla.png',
                              uncheckedImage:
                                  'assets/nuevalesionrodillaverde.png',
                              value: selectedInjury == 'Lesiones de rodilla',
                              onChanged: (value) {
                                _onCheckboxChanged('Lesiones de rodilla');
                              },
                            ),
                            Text('Lesiones de',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797))),
                            Text('rodilla',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797)))
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            ImageCheckbox(
                              checkedImage: 'assets/esgincen.png',
                              uncheckedImage: 'assets/esgince.png',
                              value: selectedInjury == 'Lesiones de hombro',
                              onChanged: (value) {
                                _onCheckboxChanged('Lesiones de hombro');
                              },
                            ),
                            Text('Lesiones de',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797))),
                            Text('hombro',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797)))
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            ImageCheckbox(
                              checkedImage: 'assets/espaldan.png',
                              uncheckedImage: 'assets/espalda.png',
                              value: selectedInjury == 'Desgarres musculares',
                              onChanged: (value) {
                                _onCheckboxChanged('Desgarres musculares');
                              },
                            ),
                            Text('Desgarres',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797))),
                            Text('musculares',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797)))
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            ImageCheckbox(
                              checkedImage: 'assets/rodillafacturan2.png',
                              uncheckedImage: 'assets/rodillafactura2.png',
                              value: selectedInjury == 'Lesion grave',
                              onChanged: (value) {
                                _onCheckboxChanged('Lesion grave');
                              },
                            ),
                            Text('Lesión grave',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797))),
                            Text('',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02))
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            ImageCheckbox(
                              checkedImage: 'assets/otron.png',
                              uncheckedImage: 'assets/otro.png',
                              value: selectedInjury == 'Otro',
                              onChanged: (value) {
                                _onCheckboxChanged('Otro');
                              },
                            ),
                            Text('Otro',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    color: Color(0xFF979797))),
                            Text('',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02))
                          ],
                        ),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Card(
                        // color: Color(0xFFE8FFDC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: _buildOriginalContent(
                                  diasEnLista,
                                  diasEnListaMesAnterior,
                                  lesionesEnLista,
                                  lesionesEnListaMesAnterior,
                                  totalDiasMesActual,
                                  totalDiasMesAnterior)),
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              mostrar == true
                  ? Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TextFormField(
                        controller: descripcion_lesion,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Color(0xFF060606)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          filled: true,
                          fillColor: Color(0xFFD1FFB9),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                          labelText: 'Ingresa la descripción de la lesión',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la descripción de la lesión';
                          }
                          return null;
                        },
                      ))
                  : Text(''),
              SizedBox(height: 15),
              tipo_evento.text != 'Jugador'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            _nuevaSolicitudLesion();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4FC028),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25.0), // Ajusta el radio según tus necesidades
                            ),
                            minimumSize: const Size(
                                150, 30), // Ajusta el tamaño mínimo del botón
                          ),
                          child: Text(
                            'Guardar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : Padding(padding: EdgeInsets.all(0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOriginalContent(
      Set<dynamic> diasEnLista,
      Set<dynamic> diasEnListaMesAnterior,
      Set<dynamic> lesionesEnLista,
      Set<dynamic> lesionesEnListaMesAnterior,
      int totalDiasMesActual,
      int totalDiasMesAnterior) {
    print(lesionesEnLista);
    final Map<dynamic, dynamic> diaALesion =
        Map.fromIterables(diasEnLista, lesionesEnLista);
    final Map<dynamic, dynamic> diaALesionAnterior =
        Map.fromIterables(diasEnListaMesAnterior, lesionesEnListaMesAnterior);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Color(0xff3C3C3B),
                  fontSize: 14.0,
                  fontFamily: 'Roboto',
                ),
                children: [
                  TextSpan(
                    text: 'Historial',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Divider(
            color: Color(0xFFC0BBBB),
            height: 20,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Mes actual:',
                  style: TextStyle(
                      color: Color(0xff979797),
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.025),
                ),
                SizedBox(width: 5.0),
                Text(
                  "${lista.length}",
                  style: TextStyle(
                      color: Color(0xff979797),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.025),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: List.generate(totalDiasMesActual, (i) {
                int dia = i + 1;
                bool isInList = diaALesion.containsKey(dia);
                Color iconColor = Color(0xffD9D9D9); // Default color

                if (isInList) {
                  // Check specific conditions
                  if (diaALesion[dia] == 'Lesion grave') {
                    iconColor = Color(0xffFF0000); // Red for "Lesión grave"
                  } else {
                    iconColor = Color(0xff6EBC44); // Green for other injuries
                  }
                }
                return Icon(
                  Icons.brightness_1,
                  color: iconColor,
                  size: MediaQuery.of(context).size.width * 0.022,
                );
              }),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Divider(
            color: Color(0xFFC0BBBB),
            height: 20,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Mes anterior:',
                  style: TextStyle(
                      color: Color(0xff979797),
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.025),
                ),
                SizedBox(width: 5.0),
                Text(
                  "${listaMesAnterior.length}",
                  style: TextStyle(
                      color: Color(0xff979797),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.025),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: List.generate(totalDiasMesAnterior, (e) {
                int dia = e + 1;
                bool isInListAnterior = diaALesionAnterior.containsKey(dia);
                Color iconColorAnterior = Color(0xffD9D9D9); // Default color

                if (isInListAnterior) {
                  // Check specific conditions
                  if (diaALesionAnterior[dia] == 'Lesion grave') {
                    iconColorAnterior =
                        Color(0xffFF0000); // Red for "Lesión grave"
                  } else {
                    iconColorAnterior =
                        Color(0xff6EBC44); // Green for other injuries
                  }
                }
                return Icon(
                  Icons.brightness_1,
                  color: iconColorAnterior,
                  size: MediaQuery.of(context).size.width * 0.022,
                );
              }),
            )
          ],
        ),
      ],
    );
  }
}
