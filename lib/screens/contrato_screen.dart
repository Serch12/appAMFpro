import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:splash_animated/screens/screens.dart';
import '../services/services.dart';
import 'package:intl/intl.dart';

class ContratoScreen extends StatefulWidget {
  const ContratoScreen({super.key});

  @override
  State<ContratoScreen> createState() => _ContratoScreenState();
}

class _ContratoScreenState extends State<ContratoScreen> {
  DateTime _fechainicio = DateTime.now();
  DateTime _fechafinal = DateTime.now();
  String _division = 'SELECCIONAR';
  String? _path;
  String? _imagen64;
  List<String> _equipos = [];
  String _equipo = '';
  final _divisionController = TextEditingController();
  final _clubController = TextEditingController();
  String? _errorMessage3;
  String? _errorMessage4;
  final String _urlBase = 'test-intranet.amfpro.mx';
  dynamic jugador = [];
  int? id_afi;
  String? username;

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
    });
    print(id_afi);
  }

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
          fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.bold),
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

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 5,
          offset: Offset(0, 6),
        ),
      ],
    );
  }

  Future<void> _guardarContrato() async {
    try {
      final url = Uri.parse(
          'https://test-intranet.amfpro.mx/api/alta-contrato'); // Reemplaza con la URL de tu API de Laravel

      // Realiza la solicitud HTTP al servidor Laravel
      final response = await http.post(url,
          body: jsonEncode({
            'id_afiliado': id_afi,
            'fecha_inicio': DateFormat('yyyy-MM-dd').format(_fechainicio),
            'fecha_vencimiento': DateFormat('yyyy-MM-dd').format(_fechafinal),
            'division': _division,
            'club': _equipo,
            'imagen64': _imagen64!,
          }),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Charset': 'utf-8'
          });

      var contenido = json.decode(response.body);
      print(contenido);
      // // Maneja la respuesta del servidor
      // if (response.statusCode == 200) {
      //   // El contrato se guardó correctamente
      //   print('Contrato guardado correctamente');
      // } else {
      //   // Ocurrió un error al guardar el contrato
      //   print('Error al guardar el contrato');
      // }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.check_circle,
                    color: Color(0xFF1AD598)), // Icono a la izquierda del texto
                SizedBox(width: 10.0), // Espacio entre el icono y el texto
                Flexible(
                  child: Text(
                    'Contrato agregado correctamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap: false, // Permite que el texto se desborde
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
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.cancel,
                    color: Colors.red), // Icono a la izquierda del texto
                SizedBox(width: 10.0), // Espacio entre el icono y el texto
                Flexible(
                  child: Text(
                    'Error al agregar contrato',
                    style: TextStyle(color: Color.fromRGBO(254, 0, 0, 1)),
                    overflow: TextOverflow.visible,
                    softWrap: false, // Permite que el texto se desborde
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
      print('Error en la solicitud HTTP: $error');
    }
    // Después de mostrar el diálogo, esperar un breve momento (puedes ajustar el tiempo según tus necesidades)
    await Future.delayed(Duration(seconds: 5));

    // Cerrar el diálogo
    Navigator.of(context).pop();

    // Volver a cargar el Screen actual
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ListaContratosScreen(),
      ),
    );
  }

  Future<List<String>> _fetchEquiposPorDivision(String division) async {
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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contrato',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.white, height: 6),
            ),
          ],
        ),
        backgroundColor: Color(0XFF6EBC44),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                // Acción al presionar el IconButton
              },
              icon: Image.asset('assets/logoblanco.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                color: Color(0XFF6EBC44),
                child: Center(),
              ),
            ),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.all(20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          // elevation: 7.0,
                          color: Colors.transparent,
                          // shadowColor: Color.fromARGB(255, 193, 192, 192)
                          //     .withOpacity(0.5),
                          child: GestureDetector(
                            onTap: () async {
                              final seleccion = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (seleccion != null) {
                                setState(() {
                                  _fechainicio = seleccion;
                                  // _calcularEdad();
                                });
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha De Inicio*',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  // Alto deseado
                                  width: MediaQuery.of(context).size.width *
                                      0.9, // El 80% del ancho de la pantalla
                                  height: MediaQuery.of(context).size.height *
                                      0.05, // El 5% de la altura de la pantalla
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(
                                          0XFF4CC2C9), // Cambia el color del borde aquí
                                      width:
                                          1.0, // Ajusta el ancho del borde según sea necesario
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),

                                  // margin: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(_fechainicio),
                                        style: TextStyle(
                                            fontFamily: 'Roboto', fontSize: 14),
                                      ),
                                      Icon(Icons.calendar_month,
                                          color: Color(0xff3C3C3B), size: 20.0)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          // elevation: 7.0,
                          color: Colors.transparent,
                          // shadowColor: Color.fromARGB(255, 193, 192, 192)
                          //     .withOpacity(0.5),
                          child: GestureDetector(
                            onTap: () async {
                              final seleccion = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (seleccion != null) {
                                setState(() {
                                  _fechafinal = seleccion;
                                  // _calcularEdad();
                                });
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha De Vencimiento*',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.9, // El 80% del ancho de la pantalla
                                  height: MediaQuery.of(context).size.height *
                                      0.05, // El 5% de la altura de la pantalla
                                  // Alto deseado
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0XFF4CC2C9),
                                      width: 1.0,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(_fechafinal),
                                        style: TextStyle(
                                            fontFamily: 'Roboto', fontSize: 14),
                                      ),
                                      Icon(Icons.calendar_month,
                                          color: Color(0xff3C3C3B), size: 20.0)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'División*',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Material(
                              // elevation: 7.0,
                              color: Colors.transparent,
                              // shadowColor: Color.fromARGB(255, 193, 192, 192)
                              //     .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                              child: DropdownButtonFormField<String>(
                                value: _division,
                                decoration: InputDecoration(
                                  errorText: _errorMessage3,
                                  labelStyle: TextStyle(
                                      fontFamily: 'Roboto', fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0XFF4CC2C9)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0XFF4CC2C9)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0XFF4CC2C9)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 12.0),
                                ),
                                items: [
                                  'SELECCIONAR',
                                  'Liga MX',
                                  'Sub 20',
                                  'Sub 18',
                                  'Sub 17',
                                  'Sub 16',
                                  'Sub 15',
                                  'Sub 14',
                                  'Sub 13',
                                  'Liga MX Femenil',
                                  'Liga Expansión MX',
                                  'Liga Premier',
                                  'Liga TDP',
                                  'Otro'
                                ]
                                    .map((String value) =>
                                        DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14)),
                                        ))
                                    .toList(),
                                onChanged: (value) async {
                                  print(value);
                                  if (value == 'Sub 20' ||
                                      value == 'Sub 18' ||
                                      value == 'Sub 17' ||
                                      value == 'Sub 16' ||
                                      value == 'Sub 15' ||
                                      value == 'Sub 14' ||
                                      value == 'Sub 13' ||
                                      value == 'Liga MX Femenil') {
                                    value = 'Liga MX';
                                  }
                                  setState(() {
                                    _division = value!;
                                    _equipo = '';
                                    _equipos = [];
                                    _errorMessage3 =
                                        (_division == 'SELECCIONAR')
                                            ? 'Selecciona una división'
                                            : null;
                                  });
                                  _equipos =
                                      await _fetchEquiposPorDivision(value!);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Club*',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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
                                value: _equipo.isNotEmpty
                                    ? _equipo
                                    : (_equipos.isNotEmpty
                                        ? _equipos[0]
                                        : null),
                                decoration: InputDecoration(
                                  // labelText: 'EQUIPO*',
                                  errorText: _errorMessage4,
                                  labelStyle: TextStyle(
                                      fontFamily: 'Roboto', fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0XFF4CC2C9)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0XFF4CC2C9)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0XFF4CC2C9)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 12.0),
                                ),
                                items: _equipos
                                    .map((String value) =>
                                        DropdownMenuItem<String>(
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
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            (_path == null)
                ? Container()
                : Image.file(
                    File(_path!),
                    width: 200,
                    height: 200,
                  ),
            Text(
              'Carga tu imagen',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF6EBC44), // Color de fondo verde
                      shape: BoxShape
                          .rectangle, // Forma del contenedor como un círculo
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: IconButton(
                    onPressed: () async {
                      try {
                        final ImagePicker picker = ImagePicker();
                        final XFile? _archivo = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (_archivo != null) {
                          setState(() {
                            _path = _archivo.path;
                          });

                          // encoding 64
                          List<int> bytes =
                              await File(_path!).readAsBytesSync();
                          _imagen64 = base64.encode(bytes);
                        }
                      } catch (e) {
                        print('Error al cargar imagen desde la galerìa: $e');
                      }
                    },
                    icon: Image.asset(
                      'assets/gallery.png', // Ruta de tu imagen
                    ), // Icono que deseas mostrar
                    iconSize: 50, // Tamaño del icono
                    splashRadius: 20, // Radio del efecto splash
                    tooltip:
                        'Cargar imagen desde galería', // Texto que aparece al mantener presionado
                  ),
                ),
                SizedBox(width: 50), // Espacio entre los contenedores
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFCFC8C8), // Color de fondo verde
                      shape: BoxShape
                          .rectangle, // Forma del contenedor como un círculo
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: IconButton(
                    onPressed: () async {
                      try {
                        final ImagePicker picker = ImagePicker();
                        final XFile? _archivo =
                            await picker.pickImage(source: ImageSource.camera);
                        if (_archivo != null) {
                          setState(() {
                            _path = _archivo.path;
                          });

                          // encoding 64
                          List<int> bytes =
                              await File(_path!).readAsBytesSync();
                          _imagen64 = base64.encode(bytes);
                        }
                      } catch (e) {
                        print(
                            'Error al seleccionar la imagen desde la cámara: $e');
                      }
                    },
                    icon: Image.asset(
                      'assets/camara.png', // Ruta de tu imagen
                    ), // Icono que deseas mostrar
                    iconSize: 50, // Tamaño del icono
                    splashRadius: 20, // Radio del efecto splash
                    tooltip:
                        'Cargar imagen desde cámara', // Texto que aparece al mantener presionado
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.black,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.09,
                    vertical: MediaQuery.of(context).size.height * 0.018,
                  ),
                  child: Text(
                    'Guardar Contrato',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                //si loginform no ejecuta arroha null de lo contrario entra a la ejecucion
                onPressed: () async {
                  // Carga la imagen y luego guarda el contrato
                  await _guardarContrato();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
