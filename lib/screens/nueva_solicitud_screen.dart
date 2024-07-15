import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:splash_animated/screens/appbar_screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class nuevaSolicitudScreen extends StatefulWidget {
  final int id_afiliado2;
  final String nombre2;
  final String ap2;
  final String am2;
  final int nui2;
  const nuevaSolicitudScreen(
      {super.key,
      required this.id_afiliado2,
      required this.nombre2,
      required this.ap2,
      required this.am2,
      required this.nui2});

  @override
  State<nuevaSolicitudScreen> createState() => _nuevaSolicitudScreenState();
}

class _nuevaSolicitudScreenState extends State<nuevaSolicitudScreen> {
  final formSolicitud = GlobalKey<FormState>();
  late int? id;
  late TextEditingController observaciones;
  late TextEditingController nombre;
  late TextEditingController nui;
  int _remainingCharacters = 150;
  String _division = 'SELECCIONAR';
  List<String> _equipos = [];
  String _equipo = '';
  String _categoria = 'SELECCIONAR';
  String? _errorMessage10;
  String? _errorMessage4;
  String? _token = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
          fontFamily: 'Roboto', fontSize: 14, color: Color(0xFF060606)),
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
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
    );
  }

  @override
  void initState() {
    super.initState();
    id = widget.id_afiliado2;
    nombre = TextEditingController(
        text:
            '${widget.nombre2.toString()} ${widget.ap2.toString()} ${widget.am2.toString()}');
    nui = TextEditingController(text: '${widget.nui2}');
    observaciones = TextEditingController();
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((value) {
      _token = value;
    });
  }

  Future<List<String>> _fetchEquiposPorDivision(String division) async {
    if (division == 'Liga MX' ||
        division == 'Sub 23' ||
        division == 'Sub 20' ||
        division == 'Sub 18' ||
        division == 'Sub 17' ||
        division == 'Sub 16' ||
        division == 'Sub 15' ||
        division == 'Sub 14' ||
        division == 'Sub 13') {
      division = 'Liga MX';
    }
    String apiUrl = 'https://test-intranet.amfpro.mx/api/clubes/$division';
    final response =
        await http.get(Uri.parse(apiUrl)).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> equipos = [];
      data.forEach((equipo) {
        equipos.add(equipo['nombre']);
      });
      setState(() {
        _equipos = equipos;
      });
      return equipos;
    } else {
      throw Exception('Error al cargar los equipos');
    }
  }

  Future<void> _nuevaSolicitud() async {
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
        'https://test-intranet.amfpro.mx/api/nueva-solicitud-api'); // Reemplaza con la URL de tu API de Laravel
    Map<String, dynamic> data = {
      "nombre": nombre.text,
      "id_afiliado": id,
      // Campos datos deportivos
      "division": _division,
      "club": _equipo,
      "nui": nui.text,
      "observaciones": observaciones.text,
      "token": _token
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
                    'Solicitud creada y enviada correctamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap:
                        true, // Permite que el texto se ajuste al ancho disponible
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, 'homeroutetres');
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
                    'Error al registrar el usuario',
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
          child: Center(
              child: Container(
            padding: EdgeInsets.only(left: 15, top: 50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icono-nueva-solicitud.png',
                      width: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'GENERAR NUEVA SOLICITUD',
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formSolicitud,
                    child: Column(
                      children: [
                        Material(
                          elevation: 7.0,
                          color: Colors.transparent,
                          shadowColor: Color.fromARGB(255, 193, 192, 192)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          child: TextFormField(
                            enabled: false,
                            controller: nombre,
                            keyboardType: TextInputType.text,
                            decoration: buildInputDecoration('NOMBRE COMPLETO'),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Material(
                          elevation: 7.0,
                          color: Colors.transparent,
                          shadowColor: Color.fromARGB(255, 193, 192, 192)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          child: TextFormField(
                            enabled: false,
                            controller: nui,
                            keyboardType: TextInputType.text,
                            decoration: buildInputDecoration('NUI'),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Material(
                          elevation: 7.0,
                          color: Colors.transparent,
                          shadowColor: Color.fromARGB(255, 193, 192, 192)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          child: DropdownButtonFormField<String>(
                            value: _division,
                            decoration: InputDecoration(
                              labelText: 'DIVISIÓN*',
                              errorText: _errorMessage10,
                              labelStyle:
                                  TextStyle(fontFamily: 'Roboto', fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 12.0),
                            ),
                            items: [
                              'SELECCIONAR',
                              'Liga MX Femenil',
                              'Liga MX',
                              'Sub 23',
                              'Sub 20',
                              'Sub 18',
                              'Sub 17',
                              'Sub 16',
                              'Sub 15',
                              'Sub 14',
                              'Sub 13',
                              'Liga Expansión MX',
                              'Liga Premier',
                              'Liga TDP',
                              'Otro'
                            ]
                                .map((String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 14)),
                                    ))
                                .toList(),
                            onChanged: (value) async {
                              print(value);
                              // if (value == 'Liga MX Femenil') {
                              //   value = 'Liga MX';
                              // }
                              setState(() {
                                _division = value!;
                                _equipo = '';
                                _equipos = [];
                                _categoria = 'SELECCIONAR';
                                _errorMessage10 = (_division == 'SELECCIONAR')
                                    ? 'Selecciona una división'
                                    : null;
                              });
                              _equipos = await _fetchEquiposPorDivision(value!);
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Material(
                          elevation: 7.0,
                          color: Colors.transparent,
                          shadowColor: Color.fromARGB(255, 193, 192, 192)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          child: DropdownButtonFormField<String>(
                            value: _equipo.isNotEmpty
                                ? _equipo
                                : (_equipos.isNotEmpty ? _equipos[0] : null),
                            decoration: InputDecoration(
                              labelText: 'VS CLUB*',
                              errorText: _errorMessage4,
                              labelStyle:
                                  TextStyle(fontFamily: 'Roboto', fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 12.0),
                            ),
                            items: _equipos
                                .map((String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 14)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _equipo = value!;
                                _errorMessage4 = (_equipo == 'SELECCIONAR')
                                    ? 'Selecciona un equipo'
                                    : null;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Material(
                          elevation: 7.0,
                          color: Colors.transparent,
                          shadowColor: Color.fromARGB(255, 193, 192, 192)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          child: TextFormField(
                            controller: observaciones,
                            maxLines: null, // Permite múltiples líneas
                            maxLength: 150,
                            keyboardType: TextInputType
                                .multiline, // Tipo de teclado para entrada de múltiples líneas
                            decoration: InputDecoration(
                              labelText: 'DESCRIPCIÓN',
                              counterText:
                                  '$_remainingCharacters caracteres restantes',
                              labelStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  color: Color(0xFF060606)),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 12.0),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _remainingCharacters = 150 - value.length;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, escribe algo'; // Mensaje de error si el campo está vacío
                              }
                              return null; // La entrada es válida
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final form = formSolicitud.currentState;
                            if (_division == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage10 = 'Selecciona una división';
                              });
                            }
                            if (form != null && form.validate()) {
                              // Si el formulario es válido, avanzar al siguiente paso
                              setState(() {});
                              _nuevaSolicitud();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4FC028),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25.0), // Ajusta el radio según tus necesidades
                            ),
                            minimumSize: const Size(
                                150, 50), // Ajusta el tamaño mínimo del botón
                          ),
                          child: Text(
                            'Guardar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
