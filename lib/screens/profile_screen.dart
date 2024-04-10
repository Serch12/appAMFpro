import 'dart:convert';

// import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/services/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:splash_animated/widgets/widgets.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  int index = 2;
  NavegadorBar? myButtonMain;
  String? username;
  final String _urlBase = 'test-intranet.amfpro.mx';
  dynamic jugador = [];
  int? id;
  String? nombre;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? sexo;
  int? nui;
  String? nacimiento;
  String? curp;
  String? escolaridad;
  String? nacionalidad;
  String? division;
  String? club;
  String? posicion;
  String? apodo;
  String? estatus;
  String? calle;
  String? colonia;
  String? estado;
  String? ciudad;
  int? cp;
  String? celular;
  String? telCasa;
  String? foto;
  String? pdf;
  String? pdf2;
  bool boton1Activado = false;
  bool boton2Activado = false;

  @override
  void initState() {
    myButtonMain = NavegadorBar(currentIndex: (i) {
      setState(() {
        index = i;
      });
    });
    cargarUsername();
    super.initState();
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
        print('No se encontró el campo "correo" en userData.');
        username = 'Usuario Desconocido';
      }
    } else {
      print('El valor de userDataString es nulo.');
      username = 'Usuario Desconocido'; // Asigna un valor predeterminado
    }
  }

  void obtenerDatosDeAPI(String userEmail) async {
    final url = Uri.http(_urlBase, '/api/datos-afiliados/correo/$userEmail');
    final respuesta = await http.get(url);
    if (mounted) {
      username = userEmail;
      jugador = json.decode(respuesta.body);
      id = jugador['data']['id'];
      nombre = jugador['data']['nombre'];
      apellidoPaterno = jugador['data']['apellido_paterno'];
      apellidoMaterno = jugador['data']['apellido_materno'];
      sexo = jugador['data']['sexo'];
      nui = jugador['data']['nui'];
      nacimiento = jugador['data']['nacimiento'];
      curp = jugador['data']['curp'];
      escolaridad = jugador['data']['escolaridad'];
      nacionalidad = jugador['data']['nacionalidad'];
      division = jugador['data']['division'];
      club = jugador['data']['club'];
      posicion = jugador['data']['posicion'];
      apodo = jugador['data']['apodo'];
      estatus = jugador['data']['estatus'];
      calle = jugador['data']['calle'];
      colonia = jugador['data']['colonia'];
      estado = jugador['data']['estado'];
      ciudad = jugador['data']['ciudad'];
      cp = jugador['data']['cp'];
      celular = jugador['data']['celular'];
      telCasa = jugador['data']['telCasa'];
      foto = jugador['data']['foto'];
      pdf = jugador['data']['pdf'];
      pdf2 = jugador['data']['pdf2'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Define las etiquetas de las pestañas
    final List<Tab> tabs = <Tab>[
      const Tab(text: 'Inf. Personal'),
      const Tab(text: 'Domicilio'),
      const Tab(text: 'Inf. Deportiva'),
      const Tab(text: 'Contacto'),
      // Agrega más pestañas si es necesario
    ];

    return Scaffold(
        appBar: AppBar(
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
                    'Perfil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.005),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(LineIcons.editAlt),
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => editProfileScreen(
                          //         id: id,
                          //         nombre: nombre,
                          //         apellidoPaterno: apellidoPaterno,
                          //         apellidoMaterno: apellidoMaterno,
                          //         nacimiento: nacimiento,
                          //         curp: curp,
                          //         sexo: sexo,
                          //         escolaridad: escolaridad,
                          //         nacionalidad: nacionalidad,
                          //         calle: calle,
                          //         colonia: colonia,
                          //         estado: estado,
                          //         ciudad: ciudad,
                          //         cp: cp,
                          //         division: division,
                          //         club: club,
                          //         posicion: posicion,
                          //         apodo: apodo,
                          //         estatus: estatus,
                          //         celular: celular,
                          //         telCasa: telCasa))
                          //         );
                          Get.to(
                              () => editProfileScreen(
                                  id: id,
                                  nombre: nombre,
                                  apellidoPaterno: apellidoPaterno,
                                  apellidoMaterno: apellidoMaterno,
                                  nacimiento: nacimiento,
                                  curp: curp,
                                  sexo: sexo,
                                  escolaridad: escolaridad,
                                  nacionalidad: nacionalidad,
                                  calle: calle,
                                  colonia: colonia,
                                  estado: estado,
                                  ciudad: ciudad,
                                  cp: cp,
                                  division: division,
                                  club: club,
                                  posicion: posicion,
                                  apodo: apodo,
                                  estatus: estatus,
                                  celular: celular,
                                  telCasa: telCasa),
                              transition: Transition.downToUp);
                        },
                      )
                    ],
                  )),
            ]),
        body: FutureBuilder(
            // Reducimos la duración del tiempo de carga a medio segundo
            future: Future.delayed(Duration(seconds: 3)),
            builder: (context, snapshot) {
              // Verifica si el Future ha completado
              if (snapshot.connectionState == ConnectionState.done) {
                // Muestra tu contenido después de la carga
                return Stack(
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
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto'),
                            ),
                            Text(
                              '$apellidoPaterno $apellidoMaterno',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
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

                      height: MediaQuery.of(context).size.height *
                          0.74, // Alto ajustado
                      child: DefaultTabController(
                        length: tabs.length, // Número de pestañas
                        child: Container(
                          width:
                              screenWidth, // Ancho ajustado al tamaño de la pantalla
                          height:
                              screenHeight, // Ajusta la altura del fondo de encima
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Color de fondo del segundo fondo
                            borderRadius: BorderRadius.circular(
                                30), // Radio de bordes redondeados
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height *
                                    0.20, // Ajusta la altura del contenedor superior
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'ID: ',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'AMF-${id}',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'NUI: ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${nui}',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.06),
                              // Pestañas y contenido
                              TabBar(
                                tabs:
                                    tabs, // Lista de pestañas definidas anteriormente
                                labelColor:
                                    Colors.black, // Color de etiqueta activa
                                unselectedLabelColor: const Color(
                                    0xFF848587), // Color de etiqueta inactiva
                                indicatorColor: const Color(
                                    0xFF211A46), // Cambia a tu color deseado para la línea activa
                                labelStyle: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
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
                                                children: [
                                                  TableCell(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            'Fecha de nacimiento:',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            '${nacimiento ?? ''}',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontFamily:
                                                                    'Roboto')),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              TableRow(
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        33,
                                                        26,
                                                        70,
                                                        0.04)), // Fila blanca
                                                children: [
                                                  TableCell(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('CURP:',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            '${curp ?? ''}',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.023, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontFamily:
                                                                    'Roboto')),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('Sexo:',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            '${sexo ?? ''}',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontFamily:
                                                                    'Roboto')),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              TableRow(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        33,
                                                        26,
                                                        70,
                                                        0.04)), // Fila blanca
                                                children: [
                                                  TableCell(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                            'Último grado de estudios:',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            '${escolaridad ?? ''}',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontFamily:
                                                                    'Roboto')),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                            'Nacionalidad:',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            '${nacionalidad ?? ''}',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025, // Ajusta el tamaño del texto según el ancho de la pantalla
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
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
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Calle:',
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
                                                    child: Text(
                                                        '${calle ?? ''}',
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
                                          TableRow(
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(33, 26,
                                                    70, 0.04)), // Fila blanca
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Colonia:',
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
                                                    child: Text(
                                                        '${colonia ?? ''}',
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
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Estado:',
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
                                                    child: Text(
                                                        '${estado ?? ''}',
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
                                          TableRow(
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(33, 26,
                                                    70, 0.04)), // Fila blanca
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Ciudad:',
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
                                                    child: Text(
                                                        '${ciudad ?? ''}',
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
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        'Código postal:',
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
                                                    child: Text('${cp ?? ''}',
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('División:',
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
                                                    child: Text(
                                                        '${division ?? ''}',
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
                                          TableRow(
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(33, 26,
                                                    70, 0.04)), // Fila blanca
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Equipo:',
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
                                                    child: Text('${club ?? ''}',
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
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        'Posición en cancha:',
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
                                                    child: Text(
                                                        '${posicion ?? ''}',
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
                                          TableRow(
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(33, 26,
                                                    70, 0.04)), // Fila blanca
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        'Apodo deportivo:',
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
                                                    child: Text(
                                                        '${apodo ?? ''}',
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
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text('Estatus:',
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
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 25.0,
                                                        vertical: 4.0),
                                                    decoration: BoxDecoration(
                                                      color: estatus == 'Activo'
                                                          ? Colors.green
                                                              .shade200 // Color verde si estatus es 'Activo'
                                                          : Colors
                                                              .red, // Color rojo en caso contrario
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Text(
                                                      '${estatus}',
                                                      style: const TextStyle(
                                                        color: Colors
                                                            .white, // Color del texto blanco
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
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
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        'Teléfono celular:',
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
                                                    child: Text(
                                                        '${celular ?? ''}',
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
                                          TableRow(
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(33, 26,
                                                    70, 0.04)), // Fila blanca
                                            children: [
                                              TableCell(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        'Teléfono fijo:',
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
                                                    child: Text(
                                                        '${telCasa ?? ''}',
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
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(1.0),
                                decoration: BoxDecoration(
                                  // color: const Color(0xFF6EBC44),
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    fotoAnversoScreen(
                                        id: id, nui: nui, pdf: pdf),
                                    fotoReversoScreen(
                                        id: id, nui: nui, pdf2: pdf2),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.13,
                      left: MediaQuery.of(context).size.width * 0.30,
                      right: MediaQuery.of(context).size.width * 0.30,
                      bottom:
                          MediaQuery.of(context).size.height * 0.42, // bottom

                      child: fotoPerfilScreen(id: id, nui: nui, foto: foto),
                    )
                  ],
                );
              } else {
                // Muestra un indicador de carga mientras se está cargando
                return Center(
                    child: Container(
                  width:
                      MediaQuery.of(context).size.width * 0.3, // Ancho del GIF
                  height:
                      MediaQuery.of(context).size.height * 0.3, // Alto del GIF
                  child: Image.asset(
                    "assets/balon-loading.gif",
                    key: UniqueKey(),
                  ),
                ));
              }
            }));
  }
}
