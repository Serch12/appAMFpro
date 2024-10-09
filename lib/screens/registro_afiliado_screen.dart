import 'dart:typed_data';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:splash_animated/services/notification_service.dart';
//import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/utils/auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'dart:io';

class RegistroAfiliadoScreen extends StatefulWidget {
  @override
  _RegistroAfiliadoScreenState createState() => _RegistroAfiliadoScreenState();
}

class _RegistroAfiliadoScreenState extends State<RegistroAfiliadoScreen> {
  ScrollController _scrollController = ScrollController();
  final String _urlBase = 'test-intranet.amfpro.mx';
  bool existe_nui = false;
  int _currentStep = 0;
  int ver_seccion = 0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _a_patController = TextEditingController();
  final _a_matController = TextEditingController();
  final _nombre_tutorController = TextEditingController();
  final _apodoController = TextEditingController();
  DateTime _fechaNacimiento = DateTime.now();
  String _edad = '0';
  String _sexo = 'SELECCIONAR';
  // bool _esMexicano = false;
  bool _terminos = false;
  bool _avisoPrivacidad = false;
  bool _tratamiento_datos_menores = false;
  bool _uso_imagenes_menores = false;
  final _curpController = TextEditingController();
  String _gradoEstudiosController = 'SELECCIONAR';
  String _paisController = 'SELECCIONAR';
  final _estadoOrigenController = TextEditingController();
  final _estadoController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _coloniaController = TextEditingController();
  final _calleController = TextEditingController();
  final _cpController = TextEditingController();
  final _telCasaController = TextEditingController();
  final _celularController = TextEditingController();
  final _nuiController = TextEditingController();
  String _division = 'SELECCIONAR';
  List<String> _equipos = [];
  String _equipo = '';
  String _categoria = 'SELECCIONAR';
  String _posicion = 'SELECCIONAR';
  String _seleccion = 'SELECCIONAR';
  String _estatusDeportivo = 'SELECCIONAR';
  String _exFutbolista = 'SELECCIONAR';
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  String? _errorMessage;
  String? _errorMessage2;
  String? _errorMessage3;
  String? _errorMessage4;
  String? _errorMessage5;
  String? _errorMessage6;
  String? _errorMessage7;
  String? _errorMessage8;
  String? _errorMessage9;
  String? _errorMessage10;
  bool _errorperfil = false;
  bool _erroranverso = false;
  bool _errorreverso = false;
  bool _erroranversotutor = false;
  bool _errorreversotutor = false;
  bool _errortermino = false;
  bool _erroraviso = false;
  bool _errortratamiento = false;
  bool _errorusoimagenes = false;

  String? _fotoperfil;
  String? _path;
  String? _frontImage;
  String? _path2;
  String? _backImage;
  String? _path3;

  String? _front_tutor_image;
  String? _path4;
  String? _back_tutor_image;
  String? _path5;

  String? _fotofirma;
  // String? _path6;

  String? _fotofirma2;
  // String? _path7;
  bool _muestrapadretutor = false;

  SignatureController? controller;
  SignatureController? controller2;

  @override
  void initState() {
    super.initState();
    controller = SignatureController(penStrokeWidth: 5, penColor: Colors.black);
    controller2 =
        SignatureController(penStrokeWidth: 5, penColor: Colors.black);
  }

  @override
  void dispose() {
    controller!.dispose();
    controller2!.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
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
    final AuthService _auth = AuthService();
    //validar si el login es correcto
    final String? mensajeError = await _auth.createAcount(
        _emailController.text, _passwordController.text);
    print("Este es el mensaje al entrar del login: ${mensajeError}");
    if (mensajeError != null) {
      // Simula una espera de 3 segundos para demostración
      await Future.delayed(Duration(seconds: 3));
      // Ocultar el indicador de carga
    } else {
      if (mensajeError == 2) {
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
                      '¡Correo electrónico previamente registrado!',
                      style: TextStyle(color: Colors.red),
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
      }
    }
    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/registro-afiliados-api'); // Reemplaza con la URL de tu API de Laravel
    Map<String, dynamic> data = {
      "name": _nameController.text,
      "a_pat": _a_patController.text,
      "a_mat": _a_matController.text,
      "apodo": _apodoController.text,
      "sexo": _sexo,
      "email": _emailController.text,
      "nacionalidad": _paisController, // Obtener el texto del controlador
      "origen":
          _estadoOrigenController.text, // Obtener el texto del controlador
      "escolaridad":
          _gradoEstudiosController, // Obtener el texto del controlador
      "edad": _edad,
      "curp": _curpController.text,
      "nacimiento": DateFormat('yyyy-MM-dd').format(_fechaNacimiento),
      // Campos domicilio
      "calle": _calleController.text, // Obtener el texto del controlador
      'colonia': _coloniaController.text, // Obtener el texto del controlador
      "estado": _estadoController.text, // Obtener el texto del controlador
      "ciudad": _ciudadController.text, // Obtener el texto del controlador
      "cp": _cpController.text, // Obtener el texto del controlador
      "celular": _celularController.text,
      "telCasa": _telCasaController.text,
      // Campos datos deportivos
      "division": _division,
      "club": _equipo,
      "categoria": _categoria,
      "nui": _nuiController.text,
      "posicion": _posicion,
      "seleccion": _seleccion,
      "estatus": _estatusDeportivo,
      "exfut": _exFutbolista,
      'pdf': _frontImage,
      "pdf2": _backImage,
      "foto": _fotoperfil,
      "fronttutor": _front_tutor_image,
      "backtutor": _back_tutor_image,
      "nombre_tutor": _nombre_tutorController.text,
      "firmatutor": _fotofirma,
      "firmatutor2": _fotofirma2
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
      final AuthService _auth = AuthService();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.check_circle,
                    color: Color(0xFF1AD598)), // Icono a la izquierda del texto
                SizedBox(width: 10.0), // Espacio entre el icono y el texto
                Expanded(
                  child: Text(
                    'Usuario registrado exitosamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap:
                        true, // Permite que el texto se ajuste al ancho disponible
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, 'homeroute');
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

  // Future getImage(ImageSource source, int isFront) async {
  //   final XFile? pickedFile = await picker.pickImage(source: source);

  //     if (pickedFile != null) {
  //       setState(() async {
  //       if (isFront == 0) {
  //         _fotoperfil = pickedFile.path;
  //          // encoding 64
  //                         List<int> bytes =
  //                             await File(_fotoperfil.path!).readAsBytesSync();
  //                         _imagen64 = base64.encode(bytes);
  //       }
  //       if (isFront == 1) {
  //         _frontImage = File(pickedFile.path);
  //       }
  //       if (isFront == 2) {
  //         _backImage = File(pickedFile.path);
  //       }
  //       });
  //     }

  // }

  Future<void> _divisionPorSexo(String se) async {
    if (se == 'Femenino') {
      setState(() {
        _sexo = se;
        _division = 'Liga MX Femenil';
        _fetchEquiposPorDivision(_division);
      });
    } else {
      _division = 'SELECCIONAR';
      _equipo = '';
    }
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

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    if (_division == 'Liga MX Femenil') {
      return [
        'SELECCIONAR',
        'Liga MX Femenil',
        'Sub 19',
        'Sub 18',
        'Sub 17',
      ]
          .map((value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
              ))
          .toList();
    } else if (_division == 'Liga MX') {
      return [
        'SELECCIONAR',
        'Liga MX',
        'Sub 23',
        'Sub 20',
        'Sub 18',
        'Sub 17',
        'Sub 16',
        'Sub 15',
        'Sub 14',
        'Sub 13',
      ]
          .map((value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
              ))
          .toList();
    } else {
      return []; // Manejar otros casos o proporcionar una lista vacía
    }
  }

  List<String> countries = [
    'SELECCIONAR',
    'México',
    'Afganistán',
    'Albania',
    'Alemania',
    'Andorra',
    'Angola',
    'Antigua y Barbuda',
    'Arabia Saudita',
    'Argelia',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaiyán',
    'Bahamas',
    'Bangladés',
    'Barbados',
    'Baréin',
    'Bélgica',
    'Belice',
    'Benín',
    'Bielorrusia',
    'Birmania',
    'Bolivia',
    'Bosnia y Herzegovina',
    'Botsuana',
    'Brasil',
    'Brunéi',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Bután',
    'Cabo Verde',
    'Camboya',
    'Camerún',
    'Canadá',
    'Catar',
    'Chad',
    'Chile',
    'China',
    'Chipre',
    'Ciudad del Vaticano',
    'Colombia',
    'Comoras',
    'Corea del Norte',
    'Corea del Sur',
    'Costa de Marfil',
    'Costa Rica',
    'Croacia',
    'Cuba',
    'Dinamarca',
    'Dominica',
    'Ecuador',
    'Egipto',
    'El Salvador',
    'Emiratos Árabes Unidos',
    'Eritrea',
    'Eslovaquia',
    'Eslovenia',
    'España',
    'Estados Unidos',
    'Estonia',
    'Etiopía',
    'Filipinas',
    'Finlandia',
    'Fiyi',
    'Francia',
    'Gabón',
    'Gambia',
    'Georgia',
    'Ghana',
    'Granada',
    'Grecia',
    'Guatemala',
    'Guyana',
    'Guinea',
    'Guinea ecuatorial',
    'Guinea-Bisáu',
    'Haití',
    'Honduras',
    'Hungría',
    'India',
    'Indonesia',
    'Irak',
    'Irán',
    'Irlanda',
    'Islandia',
    'Islas Marshall',
    'Islas Salomón',
    'Israel',
    'Italia',
    'Jamaica',
    'Japón',
    'Jordania',
    'Kazajistán',
    'Kenia',
    'Kirguistán',
    'Kiribati',
    'Kuwait',
    'Laos',
    'Lesoto',
    'Letonia',
    'Líbano',
    'Liberia',
    'Libia',
    'Liechtenstein',
    'Lituania',
    'Luxemburgo',
    'Macedonia del Norte',
    'Madagascar',
    'Malasia',
    'Malaui',
    'Maldivas',
    'Malí',
    'Malta',
    'Marruecos',
    'Mauricio',
    'Mauritania',
    'Micronesia',
    'Moldavia',
    'Mónaco',
    'Mongolia',
    'Montenegro',
    'Mozambique',
    'Namibia',
    'Nauru',
    'Nepal',
    'Nicaragua',
    'Níger',
    'Nigeria',
    'Noruega',
    'Nueva Zelanda',
    'Omán',
    'Países Bajos',
    'Pakistán',
    'Palaos',
    'Panamá',
    'Papúa Nueva Guinea',
    'Paraguay',
    'Perú',
    'Polonia',
    'Portugal',
    'Reino Unido',
    'República Centroafricana',
    'República Checa',
    'República del Congo',
    'República Democrática del Congo',
    'República Dominicana',
    'Ruanda',
    'Rumanía',
    'Rusia',
    'Samoa',
    'San Cristóbal y Nieves',
    'San Marino',
    'San Vicente y las Granadinas',
    'Santa Lucía',
    'Santo Tomé y Príncipe',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leona',
    'Singapur',
    'Siria',
    'Somalia',
    'Sri Lanka',
    'Suazilandia',
    'Sudáfrica',
    'Sudán',
    'Sudán del Sur',
    'Suecia',
    'Suiza',
    'Surinam',
    'Tailandia',
    'Tanzania',
    'Tayikistán',
    'Timor Oriental',
    'Togo',
    'Tonga',
    'Trinidad y Tobago',
    'Túnez',
    'Turkmenistán',
    'Turquía',
    'Tuvalu',
    'Ucrania',
    'Uganda',
    'Uruguay',
    'Uzbekistán',
    'Vanuatu',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Yibuti',
    'Zambia',
    'Zimbabue'
  ];

  void _calcularEdad() {
    final now = DateTime.now();
    final age = now.year - _fechaNacimiento.year;
    if (_fechaNacimiento.month > now.month ||
        (_fechaNacimiento.month == now.month &&
            _fechaNacimiento.day > now.day)) {
      setState(() {
        _edad = (age - 1).toString();
      });
    } else {
      setState(() {
        _edad = age.toString();
      });
    }
    setState(() {
      _fotoperfil = null;
      _path = null;
      _frontImage = null;
      _path2 = null;
      _backImage = null;
      _path3 = null;
      _front_tutor_image = null;
      _path4 = null;
      _back_tutor_image = null;
      _path5 = null;
      if (int.parse(_edad) < 18) {
        _muestrapadretutor = true;
      }
      if (int.parse(_edad) >= 18) {
        _muestrapadretutor = false;
      }
    });
  }

  Future<void> _consultaNUI(String nui) async {
    final url = Uri.http(_urlBase, '/api/existe-nui/$nui');
    final respuesta2 = await http.get(url);
    if (mounted) {
      setState(() {
        existe_nui = json.decode(
            respuesta2.body)['data']; // Obtiene el valor de 'data' directamente
      });
    }
    // Verificar si existe_nui es true
    if (existe_nui == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('NUI ya registrado'),
            content:
                Text('El NUI ingresado ya ha sido registrado previamente.'),
            actions: <Widget>[
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el AlertDialog
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
            ],
          );
        },
      );
    }
  }

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

  Future<void> _pickImageExpediente(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? archivo = await picker.pickImage(
        source: source,
      );
      if (archivo != null) {
        setState(() {
          _path = archivo.path;
          _errorperfil = false;
        });
        // encoding 64
        List<int> bytes = await File(_path!).readAsBytes();
        _fotoperfil = base64.encode(bytes);
      }
    } catch (e) {
      print('Error al cargar imagen: $e');
    }
  }

  Future<void> _pickImageAnverso(ImageSource source1) async {
    try {
      final ImagePicker picker2 = ImagePicker();
      final XFile? archivo2 = await picker2.pickImage(
        source: source1,
      );
      if (archivo2 != null) {
        setState(() {
          _path2 = archivo2.path;
          _erroranverso = false;
        });
        // encoding 64
        List<int> bytes2 = await File(_path2!).readAsBytes();
        _frontImage = base64.encode(bytes2);
      }
    } catch (e) {
      print('Error al cargar imagen: $e');
    }
  }

  Future<void> _pickImageReverso(ImageSource source2) async {
    try {
      final ImagePicker picker3 = ImagePicker();
      final XFile? archivo3 = await picker3.pickImage(
        source: source2,
      );
      if (archivo3 != null) {
        setState(() {
          _path3 = archivo3.path;
          _errorreverso = false;
        });
        // encoding 64
        List<int> bytes3 = await File(_path3!).readAsBytes();
        _backImage = base64.encode(bytes3);
      }
    } catch (e) {
      print('Error al cargar imagen: $e');
    }
  }

  Future<void> _pickImageAnversoTutor(ImageSource source3) async {
    try {
      final ImagePicker picker4 = ImagePicker();
      final XFile? archivo4 = await picker4.pickImage(
        source: source3,
      );
      if (archivo4 != null) {
        setState(() {
          _path4 = archivo4.path;
          _erroranversotutor = false;
        });
        // encoding 64
        List<int> bytes4 = await File(_path4!).readAsBytes();
        _front_tutor_image = base64.encode(bytes4);
      }
    } catch (e) {
      print('Error al cargar imagen: $e');
    }
  }

  Future<void> _pickImageReversoTutor(ImageSource source4) async {
    try {
      final ImagePicker picker5 = ImagePicker();
      final XFile? archivo5 = await picker5.pickImage(
        source: source4,
      );
      if (archivo5 != null) {
        setState(() {
          _path5 = archivo5.path;
          _errorreversotutor = false;
        });
        // encoding 64
        List<int> bytes5 = await File(_path5!).readAsBytes();
        _back_tutor_image = base64.encode(bytes5);
      }
    } catch (e) {
      print('Error al cargar imagen: $e');
    }
  }

  Future<void> muestraModalFirmaImagen(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Firma de aceptación del padre o tutor'),
            content: Container(
              width: MediaQuery.of(context).size.width *
                  0.9, // Define un ancho para el Container
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Firma en el recuadro de manera autógrafa lo más parecido a tu identificación oficial.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Signature(
                      controller: controller2!,
                      backgroundColor: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.99,
                    ),
                    buildButtons2(context),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<void> muestraModalFirmaAutorizacion(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Firma de autorización del padre o tutor'),
            content: Container(
              width: MediaQuery.of(context).size.width *
                  0.9, // Define un ancho para el Container
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Firma en el recuadro de manera autógrafa lo más parecido a tu identificación oficial.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Signature(
                      controller: controller!,
                      backgroundColor: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.99,
                    ),
                    buildButtons(context)
                  ],
                ),
              ),
            ));
      },
    );
  }

  // Función que descarga el archivo y luego muestra el PDF

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        toolbarHeight: MediaQuery.of(context).size.height *
            0.1, // Ajusta el alto del AppBar según el tamaño de la pantalla
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
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Registro de Usuario',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.04, // Ajusta el tamaño del texto según el ancho de la pantalla
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                // Acción al presionar el IconButton
              },
              icon: Image.asset(
                'assets/logoblanco.png',
                width: MediaQuery.of(context).size.width *
                    0.1, // Ajusta el ancho de la imagen según el tamaño de la pantalla
              ),
            ),
          ),
        ],
      ),
      body: FractionallySizedBox(
        heightFactor: 1.0,
        widthFactor: 1.0,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
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
                  height: MediaQuery.of(context).size.height * 0.05,
                  // width: 430,
                  // color: Color(0xFF211A46),
                  child: Center(),
                ),
              ),
              EasyStepper(
                activeStep: _currentStep,
                lineStyle: LineStyle(lineLength: 35),

                stepShape: StepShape.circle,
                stepBorderRadius: 15,
                borderThickness: 2,
                stepRadius: 22,
                finishedStepBorderColor: Color(0xFFDADADA),
                finishedStepTextColor: Color(0xFFDADADA),
                finishedStepBackgroundColor: Color(0xFFDADADA),
                activeStepIconColor: Colors.white,
                showLoadingAnimation: false,
                steps: [
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _currentStep >= 0 ? 1 : 0.3,
                        child: Image.asset('assets/icono-usuario.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Registro de usuario',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _currentStep >= 1 ? 1 : 0.3,
                        child: Image.asset('assets/icono-datos.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Datos personales',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _currentStep >= 2 ? 1 : 0.3,
                        child: Image.asset('assets/icono-domicilio.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Domicilio',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _currentStep >= 3 ? 1 : 0.3,
                        child: Image.asset('assets/icono-balon.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Datos deportivos',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  EasyStep(
                    customStep: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: _currentStep >= 4 ? 1 : 0.3,
                        child: Image.asset('assets/icono-documentacion.png'),
                      ),
                    ),
                    customTitle: const Text(
                      'Documentos',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                // onStepReached: (index) => setState(() => _currentStep = index),
              ),
              _buildFormSection(_currentStep),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_currentStep > 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Ajusta el radio según tus necesidades
                          ),
                          minimumSize: const Size(
                              150, 50), // Ajusta el tamaño mínimo del botón
                        ),
                        child: Text(
                          'Anterior',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    SizedBox(
                      width: 15,
                    ),
                    if (_currentStep < 4)
                      ElevatedButton(
                        onPressed: () {
                          // Obtener el formulario actual
                          if (_currentStep == 0) {
                            final form = _formKey5.currentState;
                            // Validar el formulario actual
                            if (form != null && form.validate()) {
                              // Si el formulario es válido, avanzar al siguiente paso
                              setState(() {
                                _currentStep++;
                              });
                            }
                          }
                          if (_currentStep == 1) {
                            final form = _formKey.currentState;
                            if (_sexo == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage = 'Selecciona una opción';
                              });
                            }

                            if (_paisController == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage2 = 'Selecciona una país';
                              });
                            }

                            if (_gradoEstudiosController == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage3 = 'Selecciona una opción';
                              });
                            }
                            // Validar el formulario actual
                            if (form != null && form.validate()) {
                              // Si el formulario es válido, avanzar al siguiente paso
                              setState(() {
                                _currentStep++;
                              });
                            }
                          }
                          if (_currentStep == 2) {
                            final form = _formKey2.currentState;

                            // Validar el formulario actual
                            if (form != null && form.validate()) {
                              // Si el formulario es válido, avanzar al siguiente paso
                              setState(() {
                                _currentStep++;
                              });
                            }
                          }
                          if (_currentStep == 3) {
                            final form = _formKey3.currentState;

                            if (_division == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage10 = 'Selecciona una división';
                              });
                            }

                            if (_equipo == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage4 = 'Selecciona un equipo';
                              });
                            }

                            if (_categoria == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage5 = 'Selecciona una categoría';
                              });
                            }

                            if (_posicion == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage6 = 'Selecciona una posición';
                              });
                            }

                            if (_seleccion == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage7 = 'Selecciona una opción';
                              });
                            }
                            if (_estatusDeportivo == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage8 = 'Selecciona una opción';
                              });
                            }
                            if (_exFutbolista == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage9 = 'Selecciona una opción';
                              });
                            }
                            // Validar el formulario actual
                            if (form != null && form.validate()) {
                              // Si el formulario es válido, avanzar al siguiente paso
                              setState(() {
                                _currentStep++;
                              });
                              // Desplazarse al principio
                              _scrollController.animateTo(
                                0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
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
                          'Siguiente',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (_currentStep == 4)
                      ElevatedButton(
                        onPressed: () {
                          final form = _formKey4.currentState;

                          // Valida el formulario
                          if (form!.validate()) {
                            if (int.parse(_edad) >= 18) {
                              if (_path == null) {
                                setState(() {
                                  _errorperfil = true;
                                  NotificationsService.showSnackBar(
                                      '¡Adjuntar fotografía de expediente!');
                                });
                              } else if (_path2 == null) {
                                setState(() {
                                  NotificationsService.showSnackBar(
                                      '¡Adjuntar identificación oficial (Anverso)!');
                                  _erroranverso = true;
                                });
                              } else if (_path3 == null) {
                                setState(() {
                                  NotificationsService.showSnackBar(
                                      '¡Adjuntar identificación oficial (Reverso)!');
                                  _errorreverso = true;
                                });
                              } else if (_terminos == false) {
                                setState(() {
                                  _errortermino = true;
                                });
                              } else if (_avisoPrivacidad == false) {
                                setState(() {
                                  _erroraviso = true;
                                });
                              } else {
                                // Si el formulario es válido y el campo _path no es nulo, procede con el registro del usuario
                                _registerUser();
                              }
                            } else {
                              if (_path == null) {
                                setState(() {
                                  _errorperfil = true;
                                  NotificationsService.showSnackBar(
                                      '¡Adjuntar fotografía de expediente!');
                                });
                              } else if (_path2 == null) {
                                setState(() {
                                  NotificationsService.showSnackBar(
                                      '¡Adjuntar foto de credencial escolar o CURP!');
                                  _erroranverso = true;
                                });
                              } else if (_path4 == null) {
                                setState(() {
                                  NotificationsService.showSnackBar(
                                      '¡Adjuntar identificación oficial del padre o tutor (Anverso)!');
                                  _erroranversotutor = true;
                                });
                              } else if (_path5 == null) {
                                setState(() {
                                  NotificationsService.showSnackBar(
                                      '¡Adjuntar identificación oficial del padre o tutor (Reverso)!');
                                  _errorreversotutor = true;
                                });
                              } else if (_terminos == false) {
                                setState(() {
                                  _errortermino = true;
                                });
                              } else if (_avisoPrivacidad == false) {
                                setState(() {
                                  _erroraviso = true;
                                });
                              } else if (_tratamiento_datos_menores == false) {
                                setState(() {
                                  _errortratamiento = true;
                                });
                              } else if (_fotofirma == null) {
                                setState(() {
                                  NotificationsService.showSnackBar(
                                      '¡Capturar firma!');
                                  _errortratamiento = true;
                                  _tratamiento_datos_menores = false;
                                });
                              } else if (_uso_imagenes_menores == false) {
                                setState(() {
                                  _errorusoimagenes = true;
                                });
                              } else if (_fotofirma2 == null) {
                                setState(() {
                                  NotificationsService.showSnackBar(
                                      '¡Capturar firma!');
                                  _errorusoimagenes = true;
                                  _uso_imagenes_menores = false;
                                });
                              } else {
                                // Si el formulario es válido y el campo _path no es nulo, procede con el registro del usuario
                                _registerUser();
                              }
                            }
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
                          'Registrarse',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(int step) {
    switch (step) {
      case 0:
        return _buildRegistroUsuarioSection();
      case 1:
        return _buildDatosPersonalesSection();
      case 2:
        return _buildDomicilioSection();
      case 3:
        return _buildDatosDeportivosSection();
      case 4:
        return _buildDocumentacionSection();
      default:
        return Container();
    }
  }

  Widget _buildRegistroUsuarioSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icono-usuario.png'),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'REGISTRO DE USUARIO',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: buildInputDecoration('CORREO ELECTRÓNICO*'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _passwordController,
                decoration: buildInputDecoration('CONTRASEÑA*'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Ingresa una contraseña válida (mínimo 6 caracteres)';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatosPersonalesSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icono-datos.png'),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'DATOS PERSONALES',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration('NOMBRE*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa un Nombre válido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _a_patController,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration('APELLIDO PATERNO*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa un Apellido paterno válido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _a_matController,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration('APELLIDO MATERNO*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa un Apellido materno válido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _apodoController,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration('APODO DEPORTIVO'),
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              child: GestureDetector(
                onTap: () async {
                  final seleccion = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      locale: Locale('es', 'ES'));
                  if (seleccion != null) {
                    setState(() {
                      _fechaNacimiento = seleccion;
                      _calcularEdad();
                    });
                  }
                },
                child: Container(
                  // Alto deseado
                  decoration: buildBoxDecoration(),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width *
                        0.01, // Ajusta el espacio horizontal según el ancho de la pantalla
                    vertical: MediaQuery.of(context).size.height *
                        0.015, // Ajusta el espacio vertical según el alto de la pantalla
                  ),

                  width: MediaQuery.of(context).size.width *
                      0.95, // El 80% del ancho de la pantalla
                  height: MediaQuery.of(context).size.height *
                      0.08, // El 5% de la altura de la pantalla
                  // margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'FECHA DE NACIMIENTO*:',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Color(0xFF060606)),
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy').format(_fechaNacimiento),
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize:
                                MediaQuery.of(context).size.width * 0.035),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _muestrapadretutor == true ? SizedBox(height: 15) : Container(),
            _muestrapadretutor == true
                ? Material(
                    elevation: 7.0,
                    color: Colors.transparent,
                    shadowColor:
                        Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    child: TextFormField(
                      controller: _nombre_tutorController,
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(
                          'NOMBRE DEL PADRE O TUTOR RESPONSABLE*'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa el nombre del padre o tutor responsable';
                        }
                        return null;
                      },
                    ),
                  )
                : Container(),
            SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _sexo,
                items: [
                  DropdownMenuItem(
                    value: 'SELECCIONAR',
                    child: Text('SELECCIONAR',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Masculino',
                    child: Text('Masculino',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Femenino',
                    child: Text('Femenino',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value! == 'Femenino') {
                      _divisionPorSexo(value!);
                    }
                    if (value == 'Masculino') {
                      _division = 'SELECCIONAR';
                      _equipo = '';
                    }

                    _sexo = value;
                    _errorMessage = (_sexo == 'SELECCIONAR')
                        ? 'Selecciona una opción'
                        : null;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'SEXO*',
                  errorText: _errorMessage,
                  labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width *
                        0.035, // Ajusta el espaciado vertical según el ancho del dispositivo
                    horizontal: MediaQuery.of(context).size.width *
                        0.03, // Ajusta el espaciado horizontal según el ancho del dispositivo
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _paisController,
                items: countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(
                      country,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: MediaQuery.of(context).size.width * 0.03),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _paisController = value!;
                    _errorMessage2 = (_paisController == 'SELECCIONAR')
                        ? 'Selecciona una país'
                        : null;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'PAÍS*',
                  errorText: _errorMessage2,
                  labelStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height *
                        0.018, // Ajusta el espaciado vertical según el ancho del dispositivo
                    horizontal: MediaQuery.of(context).size.width *
                        0.03, // Ajusta el espaciado horizontal según el ancho del dispositivo
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _estadoOrigenController,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration('ESTADO DE ORIGEN*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa tu Estado de origen';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            if (_paisController == 'México')
              Material(
                elevation: 7.0,
                color: Colors.transparent,
                shadowColor:
                    Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                child: TextFormField(
                  controller: _curpController,
                  decoration: buildInputDecoration('CURP*'),
                  keyboardType: TextInputType.text,
                  textCapitalization:
                      TextCapitalization.characters, // Activar mayúsculas
                  textInputAction: TextInputAction
                      .done, // Esto cambia el botón de acción del teclado
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa tu CURP';
                    }
                    // Expresión regular para validar el formato de la CURP
                    RegExp curpRegExp = RegExp(
                      r'^[A-Z]{4}[0-9]{6}[H,M][A-Z]{5}[A-Z0-9]{2}$',
                    );
                    if (!curpRegExp.hasMatch(value)) {
                      return 'El formato de la CURP no es válido';
                    }
                    // Puedes agregar más validaciones de CURP aquí si lo deseas
                    return null;
                  },
                ),
              ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _gradoEstudiosController,
                items: [
                  DropdownMenuItem(
                    value: 'SELECCIONAR',
                    child: Text('SELECCIONAR',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Educacion Primaria',
                    child: Text('Educacion Primaria',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Educación secundaria',
                    child: Text('Educación secundaria',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Educación media superior',
                    child: Text('Educación media superior',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Educación superior',
                    child: Text('Educación superior',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _gradoEstudiosController = value!;
                    _errorMessage3 = (_gradoEstudiosController == 'SELECCIONAR')
                        ? 'Selecciona una opción'
                        : null;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ÚLTIMO GRADO DE ESTUDIOS*',
                  errorText: _errorMessage3,
                  labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDomicilioSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey2,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icono-domicilio.png'),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'DOMICILIO',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _estadoController,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration('ESTADO*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa un Estado';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _ciudadController,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration('CIUDAD*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa una Ciudad';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _coloniaController,
                keyboardType: TextInputType.text,
                decoration: buildInputDecoration('COLONIA*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa una Colonia';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _calleController,
                keyboardType: TextInputType.streetAddress,
                decoration: buildInputDecoration('CALLE Y NÚMERO*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingresa tu calle y número';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _cpController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration('CÓDIGO POSTAL*'),
                validator: (value) {
                  if (value?.length != 5) {
                    return 'Debe contener 5 números';
                  }
                  if (value!.isEmpty) {
                    return 'Ingresa tu código postal';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _celularController,
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration('TELÉFONO CELULAR*'),
                validator: (value) {
                  if (value?.length != 10) {
                    return 'Debe contener 10 dígitos';
                  }
                  if (value!.isEmpty) {
                    return 'Ingresa tu número celular';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _telCasaController,
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration('TELÉFONO CASA*'),
                validator: (value) {
                  if (value?.length != 10) {
                    return 'Debe contener 10 dígitos';
                  }
                  if (value!.isEmpty) {
                    return 'Ingresa tu número de casa';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatosDeportivosSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey3,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icono-balon.png'),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'DATOS DEPORTIVOS',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: TextFormField(
                controller: _nuiController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration('NUI*'),
                onChanged: (value) {
                  // Verificar si el valor tiene 5 o 6 dígitos
                  if (value.length == 5 || value.length == 6) {
                    // Ejecutar la consulta a la API aquí
                    _consultaNUI(value);
                  }
                },
                validator: (value) {
                  if (value!.length < 5 || value.length > 6) {
                    return 'Debe contener de 5 a 6 dígitos';
                  }
                  if (value.isEmpty) {
                    return 'Ingresa tu NUI';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _division,
                decoration: InputDecoration(
                  labelText: 'DIVISIÓN*',
                  errorText: _errorMessage10,
                  labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                items: (_sexo == 'Femenino')
                    ? [
                        'Liga MX Femenil',
                      ]
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      fontFamily: 'Roboto', fontSize: 14)),
                            ))
                        .toList()
                    : [
                        'SELECCIONAR',
                        'Liga MX',
                        'Liga Expansión MX',
                        'Liga Premier',
                        'Liga TDP',
                        'Otro'
                      ]
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      fontFamily: 'Roboto', fontSize: 14)),
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
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _equipo.isNotEmpty
                    ? _equipo
                    : (_equipos.isNotEmpty ? _equipos[0] : null),
                decoration: InputDecoration(
                  labelText: 'EQUIPO*',
                  errorText: _errorMessage4,
                  labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                items: _equipos
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 14)),
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
            _division == 'Liga MX' || _division == 'Liga MX Femenil'
                ? const SizedBox(height: 15)
                : Container(),
            _division == 'Liga MX' || _division == 'Liga MX Femenil'
                ? Material(
                    elevation: 7.0,
                    color: Colors.transparent,
                    shadowColor:
                        Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    child: DropdownButtonFormField<String>(
                      value: _categoria,
                      decoration: InputDecoration(
                        labelText: 'CATEGORIA',
                        errorText: _errorMessage5,
                        labelStyle:
                            TextStyle(fontFamily: 'Roboto', fontSize: 14),
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 12.0),
                      ),
                      items: _buildDropdownItems(),
                      onChanged: (value) {
                        setState(() {
                          _categoria = value!;
                          _errorMessage5 = (_categoria == 'SELECCIONAR')
                              ? 'Selecciona una categoría'
                              : null;
                        });
                      },
                    ),
                  )
                : Container(),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _posicion,
                items: [
                  DropdownMenuItem(
                    value: 'SELECCIONAR',
                    child: Text('SELECCIONAR',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Portero',
                    child: Text('Portero',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Defensa',
                    child: Text('Defensa',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Medio',
                    child: Text('Medio',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Delantero',
                    child: Text('Delantero',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    _posicion = value!;
                    _errorMessage6 = (_posicion == 'SELECCIONAR')
                        ? 'Selecciona una posición'
                        : null;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'POSICIÓN*',
                  errorText: _errorMessage6,
                  labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _seleccion,
                items: [
                  DropdownMenuItem(
                    value: 'SELECCIONAR',
                    child: Text('SELECCIONAR',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Si',
                    child: Text('Si',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'No',
                    child: Text('No',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _seleccion = value!;
                    _errorMessage7 = (_seleccion == 'SELECCIONAR')
                        ? 'Selecciona una opción'
                        : null;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'SELECCIÓN NACIONAL*',
                  errorText: _errorMessage7,
                  labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _estatusDeportivo,
                items: [
                  DropdownMenuItem(
                    value: 'SELECCIONAR',
                    child: Text('SELECCIONAR',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Activo',
                    child: Text('Activo',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Inactivo',
                    child: Text('Inactivo',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _estatusDeportivo = value!;
                    _estatusDeportivo == 'Activo'
                        ? _exFutbolista = 'No'
                        : _exFutbolista = 'Si';
                    _errorMessage8 = (_estatusDeportivo == 'SELECCIONAR')
                        ? 'Selecciona una opción'
                        : null;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ESTATUS DEPORTIVO*',
                  errorText: _errorMessage8,
                  labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 7.0,
              color: Colors.transparent,
              shadowColor: Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              child: DropdownButtonFormField<String>(
                value: _exFutbolista,
                items: [
                  DropdownMenuItem(
                    value: 'SELECCIONAR',
                    child: Text('SELECCIONAR',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'Si',
                    child: Text('Si',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: 'No',
                    child: Text('No',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _exFutbolista = value!;
                    _errorMessage9 = (_exFutbolista == 'SELECCIONAR')
                        ? 'Selecciona una opción'
                        : null;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'EX-FUTBOLISTA*',
                  errorText: _errorMessage9,
                  labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14),
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentacionSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey4,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icono-documentacion.png'),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'DOCUMENTACIÓN',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 25),
            int.parse(_edad) >= 18
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              ver_seccion = 0;
                            });
                          },
                          child: _errorperfil == true
                              ? Image.asset('assets/icono-foto-perfil-rojo.png')
                              : Image.asset('assets/icon-foto-perfil.png')),
                      SizedBox(width: 35),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              ver_seccion = 1;
                            });
                          },
                          child: _erroranverso == true
                              ? Image.asset('assets/icono-ine-anverso-rojo.png')
                              : Image.asset('assets/icon-ine-anverso.png')),
                      SizedBox(width: 35),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              ver_seccion = 2;
                            });
                          },
                          child: _errorreverso == true
                              ? Image.asset('assets/icono-ine-reverso-rojo.png')
                              : Image.asset('assets/icon-ine-reverso.png')),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              ver_seccion = 0;
                            });
                          },
                          child: _errorperfil == true
                              ? Image.asset('assets/icono-foto-perfil-rojo.png')
                              : Image.asset('assets/icon-foto-perfil.png')),
                      SizedBox(width: 35),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              ver_seccion = 1;
                            });
                          },
                          child: _erroranverso == true
                              ? Image.asset('assets/icono-ine-anverso-rojo.png')
                              : Image.asset('assets/icon-ine-anverso.png')),
                      SizedBox(width: 35),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              ver_seccion = 3;
                            });
                          },
                          child: _erroranversotutor == true
                              ? Image.asset('assets/icono-ine-anverso-rojo.png')
                              : Image.asset('assets/icon-ine-anverso.png')),
                      SizedBox(width: 35),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              ver_seccion = 4;
                            });
                          },
                          child: _errorreversotutor == true
                              ? Image.asset('assets/icono-ine-reverso-rojo.png')
                              : Image.asset('assets/icon-ine-reverso.png')),
                    ],
                  ),
            SizedBox(
              height: 20,
            ),
            (ver_seccion == 0)
                ? Text(
                    'Fotografía de expediente',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _errorperfil == true ? Colors.red : Colors.black,
                    ),
                  )
                : (ver_seccion == 1)
                    ? Text(
                        int.parse(_edad) >= 18
                            ? 'Identificación Oficial (anverso)'
                            : 'Foto de Credencial Escolar (anverso) o CURP',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:
                              _erroranverso == true ? Colors.red : Colors.black,
                        ),
                      )
                    : (ver_seccion == 2)
                        ? Text(
                            'Identificación Oficial (reverso)',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _errorreverso == true
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          )
                        : (ver_seccion == 3)
                            ? Text(
                                'Identificación Oficial del Padre o Tutor (anverso)',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: _erroranversotutor == true
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              )
                            : Text(
                                'Identificación Oficial del Padre o Tutor (reverso)',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: _errorreversotutor == true
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
            (ver_seccion == 0)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      _path != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(_path!),
                                width: 200,
                                height: 200,
                              ),
                            )
                          : Image.asset('assets/Vector.png'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF6EBC44),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                _pickImageExpediente(ImageSource.gallery);
                              },
                              icon: Image.asset(
                                'assets/gallery.png',
                              ),
                              iconSize: 50,
                              splashRadius: 20,
                              tooltip: 'Cargar imagen desde galería',
                            ),
                          ),
                          /* SizedBox(width: 30),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFCFC8C8),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                _pickImageExpediente(ImageSource.camera);
                              },
                              icon: Image.asset(
                                'assets/camara.png',
                              ),
                              iconSize: 50,
                              splashRadius: 20,
                              tooltip: 'Cargar imagen desde cámara',
                            ),
                          ), */
                        ],
                      ),
                    ],
                  )
                : (ver_seccion == 1)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20),
                          _path2 != null
                              ? Image.file(
                                  File(_path2!),
                                  width: 200,
                                  height: 200,
                                )
                              : Image.asset('assets/anverso.png'),
                          Container(
                            decoration: BoxDecoration(
                                color:
                                    Color(0xFFCFC8C8), // Color de fondo verde
                                shape: BoxShape
                                    .rectangle, // Forma del contenedor como un círculo
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: IconButton(
                              onPressed: () async {
                                _pickImageAnverso(ImageSource.gallery);
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
                        ],
                      )
                    : (ver_seccion == 2)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20),
                              _path3 != null
                                  ? Image.file(
                                      File(_path3!),
                                      width: 200,
                                      height: 200,
                                    )
                                  : Image.asset('assets/reverso.png'),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(
                                        0xFFCFC8C8), // Color de fondo verde
                                    shape: BoxShape
                                        .rectangle, // Forma del contenedor como un círculo
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: IconButton(
                                  onPressed: () async {
                                    _pickImageReverso(ImageSource.gallery);
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
                            ],
                          )
                        : (ver_seccion == 3)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  _path4 != null
                                      ? Image.file(
                                          File(_path4!),
                                          width: 200,
                                          height: 200,
                                        )
                                      : Image.asset('assets/anverso.png'),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(
                                            0xFFCFC8C8), // Color de fondo verde
                                        shape: BoxShape
                                            .rectangle, // Forma del contenedor como un círculo
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: IconButton(
                                      onPressed: () async {
                                        _pickImageAnversoTutor(
                                            ImageSource.gallery);
                                      },
                                      icon: Image.asset(
                                        'assets/gallery.png', // Ruta de tu imagen
                                      ), // Icono que deseas mostrar
                                      iconSize: 50, // Tamaño del icono
                                      splashRadius:
                                          20, // Radio del efecto splash
                                      tooltip:
                                          'Cargar imagen desde galería', // Texto que aparece al mantener presionado
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  _path5 != null
                                      ? Image.file(
                                          File(_path5!),
                                          width: 200,
                                          height: 200,
                                        )
                                      : Image.asset('assets/anverso.png'),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(
                                            0xFFCFC8C8), // Color de fondo verde
                                        shape: BoxShape
                                            .rectangle, // Forma del contenedor como un círculo
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: IconButton(
                                      onPressed: () async {
                                        _pickImageReversoTutor(
                                            ImageSource.gallery);
                                      },
                                      icon: Image.asset(
                                        'assets/gallery.png', // Ruta de tu imagen
                                      ), // Icono que deseas mostrar
                                      iconSize: 50, // Tamaño del icono
                                      splashRadius:
                                          20, // Radio del efecto splash
                                      tooltip:
                                          'Cargar imagen desde galería', // Texto que aparece al mantener presionado
                                    ),
                                  ),
                                ],
                              ),
            SizedBox(
              height: 20,
            ),
            CheckboxListTile(
                value: _terminos,
                activeColor: Color(0xFF211A46),
                controlAffinity: ListTileControlAffinity
                    .leading, // Establece el control (Checkbox) a la izquierda
                title: Text(
                  '¿ACEPTAS expresamente que es tu libre voluntad afiliarte a la AM FUT PRO A.C. (AMFpro) y, permitir que se envíe información comercial a tu domicilio, teléfono móvil y dirección de correo electrónico?',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _terminos = value!;
                    if (_terminos == true) {
                      _errortermino = false;
                    } else {
                      _errortermino = true;
                    }
                  });
                },
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0), // Agrega relleno horizontal
                tileColor: _errortermino == true ? Colors.red : null),
            CheckboxListTile(
                value: _avisoPrivacidad,
                activeColor: Color(0xFF211A46),
                controlAffinity: ListTileControlAffinity
                    .leading, // Establece el control (Checkbox) a la izquierda
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      _downloadAndShowPdf(context);
                    });
                  },
                  child: Text(
                    'Acepto Aviso de Privacidad y Política de Protección de Datos Personales.',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _avisoPrivacidad = value!;
                    if (_avisoPrivacidad == true) {
                      _erroraviso = false;
                    } else {
                      _erroraviso = true;
                    }
                  });
                },
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0), // Agrega relleno horizontal
                tileColor: _erroraviso == true ? Colors.red : null),
            int.parse(_edad) < 18
                ? CheckboxListTile(
                    value: _tratamiento_datos_menores,
                    activeColor: Color(0xFF211A46),
                    controlAffinity: ListTileControlAffinity
                        .leading, // Establece el control (Checkbox) a la izquierda
                    title: Text(
                      'Consiento y autorizo la recolección y tratamiento de los datos personales generales de mi hijo o pupilo.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _tratamiento_datos_menores = value!;
                        if (_tratamiento_datos_menores == true) {
                          _errortratamiento = false;
                          muestraModalFirmaAutorizacion(context);
                        } else {
                          _errortratamiento = true;
                        }
                      });
                    },
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0), // Agrega relleno horizontal
                    tileColor: _errortratamiento == true ? Colors.red : null)
                : Text(''),
            int.parse(_edad) < 18
                ? CheckboxListTile(
                    value: _uso_imagenes_menores,
                    activeColor: Color(0xFF211A46),
                    controlAffinity: ListTileControlAffinity
                        .leading, // Establece el control (Checkbox) a la izquierda
                    title: Text(
                      'Consiento y autorizo el uso de la imagen de mi hijo o pupilo para las finalidades descritas en el presente aviso de privacidad (fines publicitarios).',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _uso_imagenes_menores = value!;
                        if (_uso_imagenes_menores == true) {
                          _errorusoimagenes = false;
                          muestraModalFirmaImagen(context);
                        } else {
                          _errorusoimagenes = true;
                        }
                      });
                    },
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0), // Agrega relleno horizontal
                    tileColor: _errorusoimagenes == true ? Colors.red : null)
                : Text(''),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) => Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [buildCheck(context), buildClear()],
        ),
      );

  Widget buildCheck(BuildContext context) => IconButton(
        iconSize: 26,
        icon: Icon(Icons.check, color: Colors.green),
        onPressed: () async {
          if (controller!.isNotEmpty) {
            final signature = await () async {
              final exportController = SignatureController(
                penStrokeWidth: 2,
                penColor: Colors.black,
                exportBackgroundColor: Colors.white,
                points: controller?.points,
              );
              final signatureBytes = await exportController
                  .toPngBytes(); // Firma en formato de bytes
              exportController.dispose();
              return signatureBytes;
            }();

            if (signature != null) {
              // Convertir los bytes a Base64
              _fotofirma = base64Encode(signature);
            }
          }
          Navigator.of(context).pop();
        },
      );
  Widget buildClear() => IconButton(
        iconSize: 26,
        icon: Icon(Icons.clear, color: Colors.red),
        onPressed: () => controller?.clear(),
      );

  Widget buildButtons2(BuildContext context) => Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [buildCheck2(context), buildClear2()],
        ),
      );

  Widget buildCheck2(BuildContext context) => IconButton(
        iconSize: 26,
        icon: Icon(Icons.check, color: Colors.green),
        onPressed: () async {
          if (controller2!.isNotEmpty) {
            final signature2 = await () async {
              final exportController2 = SignatureController(
                penStrokeWidth: 2,
                penColor: Colors.black,
                exportBackgroundColor: Colors.white,
                points: controller2?.points,
              );
              final signatureBytes2 = await exportController2
                  .toPngBytes(); // Firma en formato de bytes
              exportController2.dispose();
              return signatureBytes2;
            }();

            if (signature2 != null) {
              // Convertir los bytes a Base64
              _fotofirma2 = base64Encode(signature2);
            }
          }
          Navigator.of(context).pop();
        },
      );
  Widget buildClear2() => IconButton(
        iconSize: 26,
        icon: Icon(Icons.clear, color: Colors.red),
        onPressed: () => controller2?.clear(),
      );
  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   _addressController.dispose();
  //   _phoneController.dispose();
  //   super.dispose();
  // }
}

Future<void> _downloadAndShowPdf(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Evita que el usuario pueda cerrar el diálogo
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(), // Indicador de carga circular
      );
    },
  );
  try {
    // URL completa del archivo PDF
    final url =
        'https://amfpro.mx/intranet/public/pdf/AVISO-DE-PRIVACIDAD-INTEGRAL-2024.pdf';

    // Obtén el directorio temporal para guardar el archivo
    var dir = await getTemporaryDirectory();
    String filePath =
        '${dir.path}/AVISO-DE-PRIVACIDAD-INTEGRAL-2024.pdf'; // Ruta local donde se guardará el archivo

    // Descarga el archivo
    await Dio().download(url, filePath);
    Navigator.of(context).pop(); // Cerrar la alerta al presionar el botón
    // Muestra el PDF en el modal
    muestraAvisoPrivacidad(context, filePath); // Pasa la ruta local del archivo
  } catch (e) {
    print('Error al descargar el archivo: $e');
    // Muestra un mensaje de error si ocurre algún problema
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error al abrir el archivo PDF')));
  }
}

void muestraAvisoPrivacidad(BuildContext context, String localPdfPath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int _totalPages = 0;
      int _currentPage = 0;
      bool _showCloseButton = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets
                .zero, // Elimina el padding para que ocupe todo el espacio
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Todo el ancho de la pantalla
                  height: MediaQuery.of(context)
                      .size
                      .height, // Todo el alto de la pantalla
                  child: PDFView(
                    filePath: localPdfPath, // Usa la ruta local del archivo PDF
                    enableSwipe: true,
                    swipeHorizontal: false, // Desliza hacia abajo
                    autoSpacing: false,
                    pageFling: false,
                    onError: (error) {
                      print('Error al abrir el PDF: $error');
                    },
                    onRender: (_pages) {
                      setState(() {
                        _totalPages = _pages!;
                      });
                    },
                    onPageChanged: (currentPage, totalPages) {
                      setState(() {
                        _currentPage = currentPage!;
                        // Si el usuario está en la última página, mostramos el botón de cerrar
                        _showCloseButton = _currentPage == _totalPages - 1;
                      });
                    },
                    onViewCreated: (PDFViewController pdfViewController) {},
                  ),
                ),
                if (_showCloseButton) // Si el botón debe mostrarse, lo añadimos sobre el PDF
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el modal
                      },
                      child: Text('Cerrar'),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
