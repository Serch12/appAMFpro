import 'dart:convert';
import 'dart:ui';

// import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:splash_animated/screens/screens.dart';
//import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/utils/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class editProfileScreen extends StatefulWidget {
  final id;
  final nombre;
  final apellidoPaterno;
  final apellidoMaterno;
  final sexo;
  final nui;
  final nacimiento;
  final curp;
  final escolaridad;
  final nacionalidad;
  final division;
  final club;
  final posicion;
  final apodo;
  final estatus;
  final calle;
  final colonia;
  final estado;
  final ciudad;
  final cp;
  final celular;
  final telCasa;
  const editProfileScreen(
      {super.key,
      this.id,
      this.nombre,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.sexo,
      this.nui,
      this.nacimiento,
      this.curp,
      this.escolaridad,
      this.nacionalidad,
      this.division,
      this.club,
      this.posicion,
      this.apodo,
      this.estatus,
      this.calle,
      this.colonia,
      this.estado,
      this.ciudad,
      this.cp,
      this.celular,
      this.telCasa});

  @override
  State<editProfileScreen> createState() => _editProfileScreenState();
}

class _editProfileScreenState extends State<editProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formEdit = GlobalKey<FormState>();
  late int? id;
  late String? nombre;
  late String? apellidoPaterno;
  late String? apellidoMaterno;
  late String? editsexo;
  late String? nacimiento;
  late TextEditingController editcurp;
  late String? editescolaridad;
  late String? nacionalidad;
  late String? division;
  late String? club;
  late String? posicion;
  late TextEditingController editapodo;
  late String? editestatus;
  late TextEditingController editcalle;
  late TextEditingController editcolonia;
  late TextEditingController editestado;
  late TextEditingController editciudad;
  late TextEditingController editcp;
  late TextEditingController editcelular;
  late TextEditingController edittelCasa;
  // Define las etiquetas de las pestañas
  final List<Tab> tabs = <Tab>[
    const Tab(text: 'Inf. Personal'),
    const Tab(text: 'Domicilio'),
    const Tab(text: 'Inf. Deportiva'),
    const Tab(text: 'Contacto'),
    // Agrega más pestañas si es necesario
  ];

  @override
  void initState() {
    super.initState();
    // Asigna los valores de las variables nui y foto desde el widget padre
    id = widget.id;
    nombre = widget.nombre.toString();
    apellidoPaterno = widget.apellidoPaterno.toString();
    apellidoMaterno = widget.apellidoMaterno.toString();
    editsexo = widget.sexo.toString();
    nacimiento = widget.nacimiento.toString();
    editcurp = TextEditingController(text: widget.curp.toString());
    editescolaridad = widget.escolaridad.toString();
    nacionalidad = widget.nacionalidad.toString();
    division = widget.division.toString();
    club = widget.club.toString();
    posicion = widget.posicion.toString();
    editapodo = TextEditingController(text: widget.apodo.toString());
    editestatus = widget.estatus.toString();
    editcalle = TextEditingController(text: widget.calle.toString());
    editcolonia = TextEditingController(text: widget.colonia.toString());
    editestado = TextEditingController(text: widget.estado.toString());
    editciudad = TextEditingController(text: widget.ciudad.toString());
    editcp = TextEditingController(text: widget.cp.toString());
    editcelular = TextEditingController(text: widget.celular.toString());
    edittelCasa = TextEditingController(text: widget.telCasa.toString());
  }

  void _eliminarPerfil() async {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                color: Colors.transparent,
              ),
              // Contenedor con filtro de desenfoque
              Positioned(
                top: MediaQuery.of(context).size.height /
                    6, // Posicionado en la mitad de la pantalla
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      color: Colors
                          .transparent, // Color transparente para aplicar el desenfoque
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: AlertDialog(
                        title: Text('¿Deseas eliminar la cuenta?'),
                        content: Text(
                            'Si eliminas tu cuenta de AMFpro, no podrás recuperar el contenido o la  información que has compartido. \n'
                            'También se eliminarán tus estatus de controversias, tus seguimientos y, todos los datos personales. \n'),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                              backgroundColor: Color(0xFFFF0000),
                            ),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                                backgroundColor: Color(0xFF6EBC44)),
                            child: Text(
                              'Confirmar',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _deleteUser();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Contenedor sin filtro

              // Resto del contenido de tu diálogo o pantalla
              Center(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0, // Quita el sombreado del AlertDialog
                  // Otro contenido que desees mostrar en la pantalla
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteUser() async {
    User? user = _auth.currentUser;
    final authService = Provider.of<AuthService>(context, listen: false);
    if (user != null) {
      try {
        // Cerrar sesión
        await authService.logout();
        await FirebaseAuth.instance.currentUser!.delete();

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario eliminado exitosamente')),
        );

        // Navegar a la pantalla de inicio de sesión o de bienvenida
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CheckAuthScreen()),
        );
      } catch (e) {
        print(e);
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar usuario: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Define las etiquetas de las pestañas

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
            // backgroundColor: Color(0xFF211A46),
            backgroundColor: Color(0xFF6EBC44),
            elevation: 0, // Establece la elevación del AppBar a cero
            toolbarHeight: MediaQuery.of(context).size.height *
                0.07, // Ajusta el alto del AppBar según el tamaño de la pantalla
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Edita Perfil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.0055),
                  ),
                ],
              ),
            )),
        body: Stack(
          children: [
            // Fondo principal
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6EBC44), Colors.black],
                  stops: [
                    0.0,
                    0.2
                  ], // Ajusta las paradas de color según lo necesites
                ),
              ),
              // color: const Color(0xFF211A46),
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Centra verticalmente
                  children: [
                    Text(
                      '$nombre',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'),
                    ),
                    Text(
                      '$apellidoPaterno $apellidoMaterno',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Roboto'),
                    ),
                    // Agrega más elementos si es necesario
                  ],
                ),
              ),
            ),
            // Fondo encima del fondo principal con bordes redondeados

            Positioned(
              top: MediaQuery.of(context).size.width * 0.25,

              height:
                  MediaQuery.of(context).size.height * 0.76, // Alto ajustado
              child: DefaultTabController(
                length: tabs.length, // Número de pestañas
                child: Container(
                  width: screenWidth, // Ancho ajustado al tamaño de la pantalla
                  height: screenHeight, // Ajusta la altura del fondo de encima
                  decoration: BoxDecoration(
                    color: Colors.white, // Color de fondo del segundo fondo
                    borderRadius: BorderRadius.circular(
                        30), // Radio de bordes redondeados
                  ),
                  child: Form(
                    key: _formEdit,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // // Valida el formulario
                                  // if (_formEdit.currentState!.validate()) {
                                  //   // Si la validación es exitosa, llamar al método para guardar la información
                                  //   _editarInfo();
                                  // }
                                  _eliminarPerfil();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF0000),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Ajusta el radio según tus necesidades
                                  ),
                                  minimumSize: Size(0,
                                      20), // Ajusta el tamaño mínimo del botón
                                ),
                                child: Text(
                                  'Eliminar cuenta',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06),
                        // Pestañas y contenido
                        TabBar(
                          tabs:
                              tabs, // Lista de pestañas definidas anteriormente
                          labelColor: Colors.black, // Color de etiqueta activa
                          unselectedLabelColor: const Color(
                              0xFF848587), // Color de etiqueta inactiva
                          indicatorColor: const Color(
                              0xFF211A46), // Cambia a tu color deseado para la línea activa
                          labelStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.025,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: TabBarView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(1.0),
                                        1: FlexColumnWidth(1.0),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  33, 26, 70, 0.04)),
                                          children: [
                                            TableCell(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Fecha de nacimiento:',
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.025,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      '${nacimiento ?? ''}',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontFamily:
                                                              'Roboto')),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        if (nacionalidad == 'México')
                                          TableRow(
                                            decoration: BoxDecoration(
                                                color: Color(0xffD8F2CA)),
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text('CURP:',
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Roboto')),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.025,
                                                      child: TextFormField(
                                                        controller: editcurp,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .characters, // Activar mayúsculas
                                                        textInputAction:
                                                            TextInputAction
                                                                .done, // Esto cambia el botón de acción del teclado
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Ingresa tu CURP',
                                                          // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                          hintStyle: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.02), // Tamaño de la fuente
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10.0), // Ajuste del padding interior
                                                          border:
                                                              OutlineInputBorder(), // Borde del campo de texto
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    Colors.red,
                                                                width:
                                                                    1.0), // Borde de error
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    Colors.red,
                                                                width:
                                                                    1.0), // Borde de error cuando está enfocado
                                                          ),
                                                          // errorMaxLines: 1,
                                                          helperMaxLines:
                                                              0, // Evita reservar espacio para el texto de ayuda
                                                          errorStyle: TextStyle(
                                                              fontSize:
                                                                  0), // Oculta el mensaje de error
                                                        ),
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.025), // Tamaño de la fuente del texto ingresado
                                                        validator: (value) {
                                                          // Validar el valor ingresado aquí
                                                          if (value!.isEmpty) {
                                                            return 'Por favor ingresa tu CURP';
                                                          }
                                                          // Expresión regular para validar el formato de la CURP
                                                          RegExp curpRegExp =
                                                              RegExp(
                                                            r'^[A-Z]{4}[0-9]{6}[H,M][A-Z]{5}[A-Z0-9]{2}$',
                                                          );
                                                          if (!curpRegExp
                                                              .hasMatch(
                                                                  value)) {
                                                            return 'El formato de la CURP no es válido';
                                                          }
                                                          // Otros casos de validación según el formato requerido
                                                          // Puedes agregar más condiciones según tus requisitos
                                                          return null; // Devuelve null si la validación es exitosa
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                              color: Color(0xffF6FEF2)),
                                          children: [
                                            TableCell(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('Sexo:',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'Roboto')),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.025,
                                                    child: Material(
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value: editsexo,
                                                        items: [
                                                          DropdownMenuItem(
                                                            value: 'Femenino',
                                                            child: Text(
                                                                'Femenino',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 'Masculino',
                                                            child: Text(
                                                                'Masculino',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                        ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            editsexo = value!;
                                                            // _errorMessage3 = (_gradoEstudiosController == 'SELECCIONAR')
                                                            //     ? 'Selecciona una opción'
                                                            //     : null;
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Selecciona sexo',
                                                          // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                          hintStyle: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.02), // Tamaño de la fuente
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      0.0), // Ajuste del padding interior
                                                          border:
                                                              OutlineInputBorder(), // Borde del campo de texto
                                                        ),
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.025), // Tamaño de la fuente del texto ingresado
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                              color: Color(0xffD8F2CA)),
                                          children: [
                                            TableCell(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Último grado de estudios:',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'Roboto')),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.025,
                                                    child: Material(
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value: editescolaridad,
                                                        items: [
                                                          DropdownMenuItem(
                                                            value:
                                                                'Educacion Primaria',
                                                            child: Text(
                                                                'Educacion Primaria',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                'Educación secundaria',
                                                            child: Text(
                                                                'Educación secundaria',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                'Educación media superior',
                                                            child: Text(
                                                                'Educación media superior',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize: 8,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          DropdownMenuItem(
                                                            value:
                                                                'Educación superior',
                                                            child: Text(
                                                                'Educación superior',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                        ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            editescolaridad =
                                                                value!;
                                                            // _errorMessage3 = (_gradoEstudiosController == 'SELECCIONAR')
                                                            //     ? 'Selecciona una opción'
                                                            //     : null;
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Selecciona último grado de estudios',
                                                          // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                          hintStyle: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.02), // Tamaño de la fuente
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      0.0), // Ajuste del padding interior
                                                          border:
                                                              OutlineInputBorder(), // Borde del campo de texto
                                                        ),
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.025), // Tamaño de la fuente del texto ingresado
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  33, 26, 70, 0.04)),
                                          children: [
                                            TableCell(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('Nacionalidad:',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'Roboto')),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      '${nacionalidad ?? ''}',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontFamily:
                                                              'Roboto')),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Contenido de la segunda pestaña
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1.0),
                                    1: FlexColumnWidth(1.0),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffF6FEF2)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Calle:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: TextFormField(
                                                  controller: editcalle,
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Ingresa la calle',
                                                    // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02), // Tamaño de la fuente
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10.0), // Ajuste del padding interior
                                                    border:
                                                        OutlineInputBorder(), // Borde del campo de texto
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025), // Tamaño de la fuente del texto ingresado
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffD8F2CA)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Colonia:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: TextFormField(
                                                  controller: editcolonia,
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Ingresa la colonia',
                                                    // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02), // Tamaño de la fuente
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10.0), // Ajuste del padding interior
                                                    border:
                                                        OutlineInputBorder(), // Borde del campo de texto
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025), // Tamaño de la fuente del texto ingresado
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffF6FEF2)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Estado:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: TextFormField(
                                                  controller: editestado,
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Ingresa el Estado',
                                                    // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02), // Tamaño de la fuente
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10.0), // Ajuste del padding interior
                                                    border:
                                                        OutlineInputBorder(), // Borde del campo de texto
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025), // Tamaño de la fuente del texto ingresado
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffD8F2CA)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Ciudad:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: TextFormField(
                                                  controller: editciudad,
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Ingresa la ciudad',
                                                    // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02), // Tamaño de la fuente
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10.0), // Ajuste del padding interior
                                                    border:
                                                        OutlineInputBorder(), // Borde del campo de texto
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025), // Tamaño de la fuente del texto ingresado
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffF6FEF2)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Código postal:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: TextFormField(
                                                  controller: editcp,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Ingresa el código postal',
                                                    // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02), // Tamaño de la fuente
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10.0), // Ajuste del padding interior
                                                    border:
                                                        OutlineInputBorder(), // Borde del campo de texto
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025), // Tamaño de la fuente del texto ingresado
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Contenido de la tercera pestaña
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Table(
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
                                              child: Text('División:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('${division ?? ''}',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    TableRow(
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(
                                              33, 26, 70, 0.04)), // Fila blanca
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Equipo:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('${club ?? ''}',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                              child: Text('Posición en cancha:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('${posicion ?? ''}',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffD8F2CA)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Apodo deportivo:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: TextFormField(
                                                  controller: editapodo,
                                                  // Aquí puedes agregar la lógica para guardar el valor del TextFormField en la variable nacimiento
                                                  // onChanged: (value) {
                                                  //   setState(() {
                                                  //     nacimiento = value;
                                                  //   });
                                                  // },
                                                  decoration: InputDecoration(
                                                    hintText: 'Ingresa apodo',
                                                    // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02), // Tamaño de la fuente
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10.0), // Ajuste del padding interior
                                                    border:
                                                        OutlineInputBorder(), // Borde del campo de texto
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025), // Tamaño de la fuente del texto ingresado
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffF6FEF2)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Estatus:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: Material(
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: editestatus,
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: 'Activo',
                                                        child: Text('Activo',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 'Inactivo',
                                                        child: Text('Inactivo',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        editestatus = value!;
                                                        // _errorMessage3 = (_gradoEstudiosController == 'SELECCIONAR')
                                                        //     ? 'Selecciona una opción'
                                                        //     : null;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Eststus deportivo',
                                                      // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                      hintStyle: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02), // Tamaño de la fuente
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  1.0), // Ajuste del padding interior
                                                      border:
                                                          OutlineInputBorder(), // Borde del campo de texto
                                                    ),
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.025), // Tamaño de la fuente del texto ingresado
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
                              ),
                              // Contenido de la cuarta pestaña
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1.0),
                                    1: FlexColumnWidth(1.0),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffF6FEF2)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Teléfono celular:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: TextFormField(
                                                  controller: editcelular,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Ingresa tu número de celular',
                                                    // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02), // Tamaño de la fuente
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10.0), // Ajuste del padding interior
                                                    border:
                                                        OutlineInputBorder(), // Borde del campo de texto
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025), // Tamaño de la fuente del texto ingresado
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Color(0xffD8F2CA)),
                                      children: [
                                        TableCell(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Teléfono fijo:',
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto')),
                                            ),
                                          ),
                                        ),
                                        TableCell(
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
                                                child: TextFormField(
                                                  controller: edittelCasa,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Ingresa tu número telefonico de casa',
                                                    // Aquí puedes personalizar el estilo del campo de texto, como el color del texto, el color del borde, etc.
                                                    hintStyle: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02), // Tamaño de la fuente
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                10.0), // Ajuste del padding interior
                                                    border:
                                                        OutlineInputBorder(), // Borde del campo de texto
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.025), // Tamaño de la fuente del texto ingresado
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Valida el formulario
                                if (_formEdit.currentState!.validate()) {
                                  // Si la validación es exitosa, llamar al método para guardar la información
                                  _editarInfo();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4FC028),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // Ajusta el radio según tus necesidades
                                ),
                                minimumSize: const Size(150,
                                    50), // Ajusta el tamaño mínimo del botón
                              ),
                              child: Text(
                                'Guardar',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _editarInfo() async {
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

    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/edita-registro-afiliados'); // Reemplaza con la URL de tu API de Laravel
    Map<String, dynamic> data = {
      "id": id,
      "apodo": editapodo.text,
      "sexo": editsexo,
      "escolaridad": editescolaridad, // Obtener el texto del controlador

      "curp": editcurp.text,
      // "nacimiento": DateFormat('yyyy-MM-dd').format(_fechaNacimiento),
      // Campos domicilio
      "calle": editcalle.text, // Obtener el texto del controlador
      'colonia': editcolonia.text, // Obtener el texto del controlador
      "estado": editestado.text, // Obtener el texto del controlador
      "ciudad": editciudad.text, // Obtener el texto del controlador
      "cp": editcp.text, // Obtener el texto del controlador
      "celular": editcelular.text,
      "telCasa": edittelCasa.text,
      // Campos datos deportivos
      // "division": _division,
      // "club": _equipo,
      // "categoria": _categoria,
      // "nui": _nuiController.text,
      // "posicion": _posicion,
      // "seleccion": _seleccion,
      "estatus": editestatus,
      // "exfut": _exFutbolista,
      // 'pdf': _frontImage,
      // "pdf2": _backImage,
      // "foto": _fotoperfil
    };

// String jsonData = jsonEncode(data);

    final response = await http.post(url, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    });

    Navigator.of(context).pop(); // Cerrar la alerta al presionar el botón

    if (response.statusCode == 200) {
      // El usuario se registró exitosamente
      // ocultar el teclado
      FocusScope.of(context).unfocus();
      final authService = Provider.of<AuthService>(context, listen: false);

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
                    'Se edito exitosamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap:
                        true, // Permite que el texto se ajuste al ancho disponible
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Cerrar la alerta al presionar el botón
                      Navigator.pushNamed(context, 'homeroutedos');
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
    setState(() {});
  }
}
