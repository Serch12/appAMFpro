import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:splash_animated/services/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class RegistroAfiliadoScreen extends StatefulWidget {
  @override
  _RegistroAfiliadoScreenState createState() => _RegistroAfiliadoScreenState();
}

class _RegistroAfiliadoScreenState extends State<RegistroAfiliadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _a_patController = TextEditingController();
  final _a_matController = TextEditingController();
  String _sexo = 'SELECCIONAR';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime _fechaNacimiento = DateTime.now();
  String _edad = '0';
  final _curpController = TextEditingController();
  final _celularController = TextEditingController();
  String _division = 'SELECCIONAR';
  List<String> _equipos = [];
  String _equipo = '';
  final _divisionController = TextEditingController();
  final _clubController = TextEditingController();
  final _nuiController = TextEditingController();
  String _posicion = 'SELECCIONAR';
  bool _esMexicano = false;
  String? _errorMessage;
  String? _errorMessage2;
  String? _errorMessage3;
  String? _errorMessage4;

  Future<void> _registerUser() async {
    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/registro-afiliados-api'); // Reemplaza con la URL de tu API de Laravel

    final response = await http.post(
      url,
      body: {
        "name": _nameController.text,
        "a_pat": _a_patController.text,
        "a_mat": _a_matController.text,
        "sexo": _sexo,
        "email": _emailController.text,
        "edad": _edad,
        "curp": _curpController.text,
        "nacimiento": DateFormat('yyyy-MM-dd').format(_fechaNacimiento),
        "celular": _celularController.text,
        "division": _division,
        "club": _equipo,
        "nui": _nuiController.text,
        "posicion": _posicion
      },
    );

    if (response.statusCode == 200) {
      // El usuario se registró exitosamente
      // ocultar el teclado
      FocusScope.of(context).unfocus();
      final authService = Provider.of<AuthService>(context, listen: false);

      //validar si el login es correcto
      final String? mensajeError = await authService.createUser(
          _emailController.text, _passwordController.text);
      if (mensajeError == null) {
        Navigator.pushReplacementNamed(context, 'homeroute');
      } else {
        if (mensajeError == 'EMAIL_EXISTS') {
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
        }
      }
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
                    'Usuario registrado exitosamente',
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
                Flexible(
                  child: Text(
                    'Error al registrar el usuario',
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
    }
  }

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

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _a_patController.dispose();
  //   _a_matController.dispose();
  //   _sexo.dispose();
  //   _emailController.dispose();
  //   _edadController.dispose();
  //   _curpController.dispose();
  //   _nacimientoController.dispose();
  //   _celularController.dispose();
  //   _divisionController.dispose();
  //   _clubController.dispose();
  //   _nuiController.dispose();
  //   _posicionController.dispose();
  //   super.dispose();
  // }
  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.roboto(fontSize: 14, color: Color(0xFF060606)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Registro de Usuario',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, color: Colors.white, height: 6),
            ),
          ],
        ),
        backgroundColor: Color(0xFF211A46),
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
        child: Center(
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: 40,
                  width: 430,
                  color: Color(0xFF211A46),
                  child: Center(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Material(
                        elevation: 7.0,
                        color: Colors.transparent,
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
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
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
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
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
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
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: DropdownButtonFormField<String>(
                          value: _sexo,
                          items: [
                            DropdownMenuItem(
                              value: 'SELECCIONAR',
                              child: Text('SELECCIONAR',
                                  style: GoogleFonts.roboto(fontSize: 14)),
                            ),
                            DropdownMenuItem(
                              value: 'Masculino',
                              child: Text('Masculino',
                                  style: GoogleFonts.roboto(fontSize: 14)),
                            ),
                            DropdownMenuItem(
                              value: 'Femenino',
                              child: Text('Femenino',
                                  style: GoogleFonts.roboto(fontSize: 14)),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _sexo = value!;
                              _errorMessage2 = (_sexo == 'SELECCIONAR')
                                  ? 'Selecciona una opción'
                                  : null;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'SEXO*',
                            errorText: _errorMessage2,
                            labelStyle: GoogleFonts.roboto(fontSize: 14),
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
                        ),
                      ),
                      const SizedBox(height: 15),
                      Material(
                        elevation: 7.0,
                        color: Colors.transparent,
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              buildInputDecoration('CORREO ELECTRÓNICO*'),
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
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
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
                      const SizedBox(height: 15),
                      Container(
                        width: 500, // Ancho deseado
                        height: 52, // Alto deseado
                        decoration: buildBoxDecoration(),
                        child: CheckboxListTile(
                          title: Text('¿MEXICANO?',
                              style: GoogleFonts.roboto(fontSize: 14)),
                          value: _esMexicano,
                          activeColor: Color(0xFF211A46),
                          onChanged: (value) {
                            setState(() {
                              _esMexicano = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (_esMexicano)
                        Material(
                          elevation: 7.0,
                          color: Colors.transparent,
                          shadowColor: Color.fromARGB(255, 193, 192, 192)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          child: TextFormField(
                            controller: _curpController,
                            decoration: buildInputDecoration('CURP*'),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor ingresa tu CURP';
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
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
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
                                _fechaNacimiento = seleccion;
                                _calcularEdad();
                              });
                            }
                          },
                          child: Container(
                            // Alto deseado
                            decoration: buildBoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            width: 500,
                            height: 52,
                            // margin: EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'FECHA DE NACIMIENTO*:',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14, color: Color(0xFF060606)),
                                ),
                                Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(_fechaNacimiento),
                                  style: GoogleFonts.roboto(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Material(
                        elevation: 7.0,
                        color: Colors.transparent,
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: TextFormField(
                          controller: _celularController,
                          keyboardType: TextInputType.number,
                          decoration: buildInputDecoration('TELÉFONO MOVIL*'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingresa un número de teléfono válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Material(
                        elevation: 7.0,
                        color: Colors.transparent,
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: DropdownButtonFormField<String>(
                          value: _division,
                          decoration: InputDecoration(
                            labelText: 'DIVISIÓN*',
                            errorText: _errorMessage3,
                            labelStyle: GoogleFonts.roboto(fontSize: 14),
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
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style:
                                            GoogleFonts.roboto(fontSize: 14)),
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
                              _errorMessage3 = (_division == 'SELECCIONAR')
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
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: DropdownButtonFormField<String>(
                          value: _equipo.isNotEmpty
                              ? _equipo
                              : (_equipos.isNotEmpty ? _equipos[0] : null),
                          decoration: InputDecoration(
                            labelText: 'EQUIPO*',
                            errorText: _errorMessage4,
                            labelStyle: GoogleFonts.roboto(fontSize: 14),
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
                          items: _equipos
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style:
                                            GoogleFonts.roboto(fontSize: 14)),
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
                      const SizedBox(height: 15),
                      Material(
                        elevation: 7.0,
                        color: Colors.transparent,
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: DropdownButtonFormField<String>(
                          value: _posicion,
                          items: [
                            DropdownMenuItem(
                              value: 'SELECCIONAR',
                              child: Text('SELECCIONAR',
                                  style: GoogleFonts.roboto(fontSize: 14)),
                            ),
                            DropdownMenuItem(
                              value: 'Portero',
                              child: Text('Portero',
                                  style: GoogleFonts.roboto(fontSize: 14)),
                            ),
                            DropdownMenuItem(
                              value: 'Defensa',
                              child: Text('Defensa',
                                  style: GoogleFonts.roboto(fontSize: 14)),
                            ),
                            DropdownMenuItem(
                              value: 'Medio',
                              child: Text('Medio',
                                  style: GoogleFonts.roboto(fontSize: 14)),
                            ),
                            DropdownMenuItem(
                              value: 'Delantero',
                              child: Text('Delantero',
                                  style: GoogleFonts.roboto(fontSize: 14)),
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              _posicion = value!;
                              _errorMessage = (_posicion == 'SELECCIONAR')
                                  ? 'Selecciona una posición'
                                  : null;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'POSICIÓN*',
                            errorText: _errorMessage,
                            labelStyle: GoogleFonts.roboto(fontSize: 14),
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
                        ),
                      ),
                      const SizedBox(height: 15),
                      Material(
                        elevation: 20.0,
                        color: Colors.transparent,
                        shadowColor:
                            Color.fromARGB(255, 193, 192, 192).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        child: TextFormField(
                          controller: _nuiController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'NUI',
                            labelStyle:
                                TextStyle(fontSize: 14, fontFamily: 'Roboto'),
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingresa NUI válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          print(_formKey.currentState!.validate());

                          if (_formKey.currentState!.validate() == false) {
                            if (_sexo == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage2 = 'Selecciona una opción';
                              });
                            }
                            if (_division == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage3 = 'Selecciona una division';
                              });
                            }
                            if (_equipo == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage4 = 'Selecciona un equipo';
                              });
                            }
                            if (_posicion == 'SELECCIONAR') {
                              setState(() {
                                _errorMessage = 'Selecciona una posición';
                              });
                            }
                          } else {
                            setState(() {
                              _errorMessage = null;
                              _errorMessage2 = null;
                              _errorMessage3 = null;
                              _errorMessage4 = null;
                            });
                            _registerUser();
                          }
                          setState(() {});
                        },
                        // child: Text(
                        //   'Regístrate',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 18.0,
                        //   ),
                        // ),
                        // style: TextButton.styleFrom(
                        //   padding: EdgeInsets.all(16.0),
                        //   backgroundColor: Colors.green,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(25.0),
                        //     side: BorderSide(color: Colors.green),
                        //   ),
                        // ),
                        child: Text(
                          'REGISTRATE',
                          style: GoogleFonts.roboto(
                            color: Colors.white, // Color del texto del botón
                            fontSize:
                                15.0, // Tamaño de fuente del texto del botón
                          ),
                          softWrap:
                              false, // Evitar que el texto se divida en varias líneas
                        ),
                        // child: const Text('Enviar código de verificacón.',
                        //     style: TextStyle(color: Colors.green, fontSize: 14)),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 140.00, vertical: 15.00),
                          backgroundColor: Color(0xFF4FC028),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
