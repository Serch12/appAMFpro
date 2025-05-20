import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splash_animated/event.dart';
import 'package:splash_animated/screens/appbar_screen.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/services/dialogflow_service.dart';
// import 'package:splash_animated/providers/twitter_provider.dart';
// import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/utils/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:card_swiper/card_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/dialogflow_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime fecha_evento = DateTime.now();
  final String _urlBase = 'test-intranet.amfpro.mx';
  List<Map<String, dynamic>> lista = [];
  List<Map<String, dynamic>> lista_publicaciones = [];
  List<Map<String, dynamic>> lista_eventos = [];
  dynamic jugador = [];
  int? id_afi;
  String? nombre;
  String? division;
  String? club;
  int? foto_perfil;
  String? _token = '';
  Map<DateTime, List<CleanCalendarEvent>> _events2 = {};

  late List<CleanCalendarEvent> _selectedEvents2;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((value) {
      _token = value;
    });
    _selectedDay = _focusedDay;

    // obtenerEventos();

    // _events2 = {
    //   DateTime.utc(2024, 9, 18): [
    //     CleanCalendarEvent(
    //         title: 'Reunión de trabajo',
    //         // startTime: DateTime.utc(2024, 9, 18, 10, 0),
    //         // endTime: DateTime.utc(2024, 9, 18, 12, 0),
    //         description: 'Reunión de equipo para discutir el proyecto',
    //         color: Colors.amber),
    //   ],
    //   DateTime.utc(2024, 9, 19): [
    //     CleanCalendarEvent(
    //         title: 'Consulta médica',
    //         // startTime: DateTime.utc(2024, 9, 19, 14, 0),
    //         // endTime: DateTime.utc(2024, 9, 19, 15, 0),
    //         description: 'Visita al doctor',
    //         color: Colors.blue),
    //   ],
    // };

    cargarUsername();
    obtenerDatosDeAPIPublicaciones();
    obtenerDatosDeAPIComunicados();
    _selectedEvents2 = [];
  }

  void cargarUsername() async {
    // final twitterProvider = Provider.of<TwitterProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    // final mapeoFinal = twitterProvider.listadoPublicaciones;
    final Future<String> userDataFuture = authService.autenticacion();
    userDataFuture.then((userDataString) {
      // ignore: unnecessary_null_comparison
      if (userDataString != null) {
        final Map<String, dynamic> userData = json.decode(userDataString);
        final String? username = userData['correo'];

        if (username != null) {
          obtenerDatosDeAPI(username);
        } else {
          print('No se encontró el campo "email" en userData.');
        }
      } else {
        print('El valor de userDataString es nulo.');
      }
    });
  }

  // void obtenerEventos() async {
  //   final url5 = Uri.http(_urlBase, '/api/lista-eventos');
  //   final respuesta5 = await http.get(url5);
  //   if (mounted) {
  //     setState(() {
  //       lista_eventos =
  //           List<Map<String, dynamic>>.from(json.decode(respuesta5.body));
  //     });
  //   }
  //   for (var event in lista_eventos) {
  //     // Parsear la fecha del evento
  //     DateTime eventDate = DateTime.parse(event['fecha']);

  //     // Extraer solo el año, mes y día y convertir a UTC para que todas las fechas sean iguales
  //     DateTime eventDateUtc =
  //         DateTime.utc(eventDate.year, eventDate.month, eventDate.day);

  //     // Crear el CleanCalendarEvent
  //     CleanCalendarEvent calendarEvent = CleanCalendarEvent(
  //       title: event['titulo'],
  //       startTime:
  //           eventDate, // Puedes ajustar el startTime si tienes información de la hora
  //       endTime: eventDate, // Igual aquí para el endTime
  //       description: event['descripcion'],
  //       color: Color(0xFF6EBC44),
  //       // Asignar color basado en el estatus
  //     );

  //     // Agregar el evento al mapa usando solo la fecha sin la hora como clave
  //     if (_events2[eventDateUtc] == null) {
  //       _events2[eventDateUtc] = [];
  //     }
  //     _events2[eventDateUtc]!.add(calendarEvent);
  //   }
  // }

  void obtenerDatosDeAPI(String userEmail) async {
    final url = Uri.http(_urlBase, '/api/datos-afiliados/correo/$userEmail');
    final respuesta = await http.get(url);
    if (mounted) {
      setState(() {
        jugador = json.decode(respuesta.body);
        id_afi = jugador['data']['id'];
        nombre = jugador['data']['nombre'];
        division = jugador['data']['division'];
        club = jugador['data']['club'];
        consultarTokenExiste(id_afi);
      });
    }
  }

  void consultarTokenExiste(id_afiliado) async {
    final url = Uri.http(_urlBase, '/api/consulta-token/$id_afiliado/$_token');
    final respuesta3 = await http.get(url);
  }

  void obtenerDatosDeAPIPublicaciones() async {
    final url = Uri.http(_urlBase, '/api/post/listado');
    final respuesta = await http.get(url);
    // Verificar si el widget está montado antes de llamar a setState()
    if (mounted) {
      setState(() {
        lista_publicaciones =
            List<Map<String, dynamic>>.from(json.decode(respuesta.body));
      });
    }
    print(lista_publicaciones);
  }

  void obtenerDatosDeAPIComunicados() async {
    final url = Uri.http(_urlBase, '/api/noticias/comunicados');
    final respuesta2 = await http.get(url);
    if (mounted) {
      setState(() {
        lista = List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
      });
    }
  }

  List<CleanCalendarEvent> _getEventsForDay(DateTime day) {
    return _events2[day] ?? [];
  }

  @override
  void dispose() {
    // _selectedEvents.dispose();
    super.dispose();
  }

  final kToday = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Future<DialogflowService> iniciaDialog() async {
      DialogflowAuth auth = DialogflowAuth();
      await auth.loadCredentials();
      String accessToken = await auth.getAccessToken();
      return DialogflowService(
          projectId: auth.projectId,
          accessToken: accessToken,
          idAfiliado: id_afi.toString());
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     DialogflowService? dialogflow = await iniciaDialog();
      //     if (dialogflow != null) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => chatBotScreen(
      //               dialogflow: dialogflow,
      //               nombre: nombre,
      //               division: division,
      //               club: club,
      //               id_afiliado: id_afi),
      //         ),
      //       );
      //     } else {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text('Error al inicializar el chatbot')),
      //       );
      //     }
      //   },
      //   child: Image.asset('assets/avatar_bot5.png'),
      //   backgroundColor: Color(0xFF4FC028),
      // ),
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
          ]), // Aquí se utiliza MyAppBar,
      body: SingleChildScrollView(
          child: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Container(
          //           padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          //           child: Image.asset('assets/logo-negro.png'))
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: double.infinity,
            height: size.height * 0.65,
            child: Stack(
              children: [
                Swiper(
                  autoplay: true,
                  autoplayDelay:
                      9000, // Duración en milisegundos (en este caso, 5 segundos)
                  itemBuilder: (_, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/no-image.jpg'),
                        image: NetworkImage(
                            'http://amfpro.mx/intranet/public/ArchivosSistema/PostApp/${lista_publicaciones[index]['archivo']}'),
                        // AssetImage("assets/Mask.png"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/no-image.jpg',
                              fit: BoxFit.cover);
                        },
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  itemCount: lista_publicaciones.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  pagination:
                      SwiperCustomPagination(builder: (context, config) {
                    return CustomPagination(config);
                  }),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey.shade300,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  'Calendario de eventos importantes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                ),
                TableCalendar(
                  locale: 'es_ES',
                  firstDay: DateTime.utc(2023, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  headerVisible: true,
                  rowHeight: 40,
                  headerStyle: const HeaderStyle(
                      titleCentered: true, formatButtonVisible: false),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.green),
                      weekendStyle: TextStyle(color: Colors.white)),
                  calendarStyle: CalendarStyle(
                    todayTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF6EBC44),
                    ),
                    selectedDecoration:
                        BoxDecoration(color: Colors.green.shade200),
                    markerDecoration: BoxDecoration(
                      color: Color(0xFF6EBC44), // Color del indicador
                      shape: BoxShape.circle, // Forma del indicador
                    ),
                    markersMaxCount: 3, // Límite de marcadores por día
                  ),
                  eventLoader: _getEventsForDay, // Define cómo cargar eventos
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
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
                      // _selectedEvents.value = _getEventsForDay(selectedDay);
                      _selectedEvents2 = _getEventsForDay(selectedDay);
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _selectedEvents2.isNotEmpty
                    ? ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: size.height * 0.15),
                        child: ListView.builder(
                          itemCount: _selectedEvents2.length,
                          itemBuilder: (context, index) {
                            final event = _selectedEvents2[index];
                            return ListTile(
                              leading: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: event.color, // Aplica el color aquí
                                ),
                              ),
                              title: Text(
                                event.title,
                                style: TextStyle(
                                    color: Color(0xFF6EBC44),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(event.description),
                              // trailing: Text(
                              //   '${event.startTime.hour}:${event.startTime.minute} - ${event.endTime.hour}:${event.endTime.minute}',
                              // ),
                            );
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          // Container(
          //   width: double.infinity,
          //   height: size.height * 0.35,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Expanded(
          //           child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: lista.length,
          //         itemBuilder: (context, index) {
          //           return GestureDetector(
          //             onTap: () {
          //               // Aquí manejas la navegación a la otra pantalla
          //               // Puedes usar Navigator para navegar a la nueva ruta
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) =>
          //                       detallePostScreen(value: lista[index]),
          //                 ),
          //               );
          //             },
          //             child: Container(
          //               width: size.width *
          //                   0.65, // El 80% del ancho de la pantalla
          //               height: size.height *
          //                   0.7, // El 60% de la altura de la pantalla
          //               margin:
          //                   EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Hero(
          //                     tag: lista[index]['id_p'],
          //                     child: ClipRRect(
          //                       borderRadius: BorderRadius.circular(20),
          //                       child: FadeInImage(
          //                           placeholder:
          //                               AssetImage('assets/no-image.jpg'),
          //                           image: NetworkImage(
          //                             'http://amfpro.mx/intranet/public/ArchivosSistema/Post/${lista[index]['imagen_p']}',
          //                           ),
          //                           width: MediaQuery.of(context).size.width *
          //                               0.9, // Ancho deseado
          //                           height: 150, // Altura deseada
          //                           fit: BoxFit.fill
          //                           // AssetImage('assets/ejemplo2.jpg'),
          //                           ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 2,
          //                   ),
          //                   Container(
          //                     width: MediaQuery.of(context).size.width *
          //                         0.9, // Ancho deseado
          //                     child: Text(
          //                       lista[index]['titulo'],
          //                       style: TextStyle(
          //                           fontFamily: 'Roboto',
          //                           fontWeight: FontWeight.bold,
          //                           fontSize:
          //                               MediaQuery.of(context).size.width *
          //                                   0.03),
          //                     ),
          //                   ),
          //                   Text(
          //                     lista[index]['fecha'],
          //                     style: TextStyle(
          //                         fontFamily: 'Roboto',
          //                         fontSize:
          //                             MediaQuery.of(context).size.width * 0.03),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           );
          //         },
          //       ))
          //     ],
          //   ),
          // ),
        ],
      )),
    );
  }
}

class CustomPagination extends StatelessWidget {
  final SwiperPluginConfig config;

  CustomPagination(this.config);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: 10,
      left: screenWidth *
          0.1, // 10% del ancho de la pantalla desde el borde izquierdo
      right: screenWidth *
          0.1, // 10% del ancho de la pantalla desde el borde derecho
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              config.itemCount,
              (index) {
                bool isActive = index == config.activeIndex;
                return Container(
                  width: isActive ? 30.0 : 5.0,
                  height: 5.0,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width *
                          0.01), // Ajusta el padding horizontal según el ancho de la pantalla
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Alinea los elementos de la fila
                    children: [
                      IconButton(
                        onPressed: () {
                          // Acción cuando se presiona el primer botón
                          _launchFacebookApp();
                        },
                        icon: Image.asset('assets/social_facebook.png'),
                        tooltip: 'Facebook',
                      ),
                      IconButton(
                        onPressed: () {
                          // Acción cuando se presiona el segundo botón
                          _launchInstagramApp();
                        },
                        icon: Image.asset('assets/social_instagram.png'),
                        tooltip: 'Instagram',
                      ),
                      IconButton(
                        onPressed: () {
                          // Acción cuando se presiona el tercer botón
                          _launchLinkedInProfile();
                        },
                        icon: Image.asset('assets/social_linkedin.png'),
                        tooltip: 'LinkedIn',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width *
                          0.02), // Ajusta el padding horizontal según el ancho de la pantalla
                  child: ElevatedButton(
                    onPressed: () {
                      _launchURL();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      'Más Información',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width *
                            0.023, // Ajusta el tamaño del texto según el ancho de la pantalla
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void _launchFacebookApp() async {
  final facebookUrl =
      "fb://page/AMFproMX"; // Esquema de URL de Facebook para abrir la página
  final webUrl =
      "https://www.facebook.com/AMFproMX"; // URL de respaldo para abrir en el navegador si la aplicación de Facebook no está instalada
  try {
    // ignore: deprecated_member_use
    bool launched = await launch(facebookUrl, forceSafariVC: false);
    if (!launched) {
      // ignore: deprecated_member_use
      await launch(webUrl, forceSafariVC: false);
    }
  } catch (e) {
    // ignore: deprecated_member_use
    await launch(webUrl, forceSafariVC: false);
  }
}

void _launchInstagramApp() async {
  final instagramUrl =
      "instagram://user?username=AMFproMX"; // Esquema de URL de Instagram para abrir el perfil
  final webUrl =
      "https://www.instagram.com/AMFproMX/"; // URL de respaldo para abrir en el navegador si la aplicación de Instagram no está instalada
  try {
    // ignore: deprecated_member_use
    bool launched = await launch(instagramUrl, forceSafariVC: false);
    if (!launched) {
      // ignore: deprecated_member_use
      await launch(webUrl, forceSafariVC: false);
    }
  } catch (e) {
    // ignore: deprecated_member_use
    await launch(webUrl, forceSafariVC: false);
  }
}

void _launchLinkedInProfile() async {
  final linkedInUrl =
      "linkedin://profile/company/amfpromx"; // Esquema de URL de LinkedIn para abrir el perfil de la empresa
  final webUrl =
      "https://www.linkedin.com/company/amfpromx/mycompany/"; // URL de respaldo para abrir en el navegador si la aplicación de LinkedIn no está instalada
  try {
    // ignore: deprecated_member_use
    bool launched = await launch(linkedInUrl, forceSafariVC: false);
    if (!launched) {
      // ignore: deprecated_member_use
      await launch(webUrl, forceSafariVC: false);
    }
  } catch (e) {
    // ignore: deprecated_member_use
    await launch(webUrl, forceSafariVC: false);
  }
}

void _launchURL() async {
  final url = 'https://amfpro.mx/asesorias';
  // ignore: deprecated_member_use
  await launch(url, forceSafariVC: false);
}

class CleanCalendarEvent {
  final String title;
  final DateTime? startTime;
  final DateTime? endTime;
  final String description;
  final Color color;

  CleanCalendarEvent({
    required this.title,
    this.startTime,
    this.endTime,
    this.description = '',
    required this.color,
  });
}
