import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';
// import 'package:splash_animated/providers/twitter_provider.dart';
import 'package:splash_animated/services/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:card_swiper/card_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _urlBase = 'test-intranet.amfpro.mx';
  List<Map<String, dynamic>> lista = [];
  List<Map<String, dynamic>> lista_publicaciones = [];

  @override
  void initState() {
    super.initState();
    obtenerDatosDeAPIPublicaciones();
    obtenerDatosDeAPI();
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
  }

  void obtenerDatosDeAPI() async {
    final url = Uri.http(_urlBase, '/api/noticias/comunicados');
    final respuesta2 = await http.get(url);
    if (mounted) {
      setState(() {
        lista = List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // final twitterProvider = Provider.of<TwitterProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    // final mapeoFinal = twitterProvider.listadoPublicaciones;
    final Future<String> userDataFuture = authService.autenticacion();
    userDataFuture.then((userDataString) {
      // ignore: unnecessary_null_comparison
      if (userDataString != null) {
        final Map<String, dynamic> userData = json.decode(userDataString);
        print(userData);
        final String? username = userData['correo'];

        if (username != null) {
          // Puedes acceder a 'username' aquí
          print('Nombre de usuario: $username');
        } else {
          print('No se encontró el campo "email" en userData.');
        }
      } else {
        print('El valor de userDataString es nulo.');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF211A46),
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            '',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'homeroute');
              },
              icon: Image.asset(
                'assets/logoblanco.png',
                width: MediaQuery.of(context).size.width * 0.08,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Image.asset('assets/logo-negro.png'))
              ],
            ),
          ),
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
                      8000, // Duración en milisegundos (en este caso, 5 segundos)
                  itemBuilder: (_, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/no-image.jpg'),
                        image:
                            // NetworkImage(
                            //     'http://amfpro.mx/intranet/public/ArchivosSistema/PostApp/${lista_publicaciones[index]['archivo']}'),
                            AssetImage("assets/Mask.png"),
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
            width: double.infinity,
            height: size.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Aquí manejas la navegación a la otra pantalla
                        // Puedes usar Navigator para navegar a la nueva ruta
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                detallePostScreen(value: lista[index]),
                          ),
                        );
                      },
                      child: Container(
                        width: 250,
                        height: 300,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: lista[index]['id_p'],
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FadeInImage(
                                    placeholder:
                                        AssetImage('assets/no-image.jpg'),
                                    image: NetworkImage(
                                      'http://amfpro.mx/intranet/public/ArchivosSistema/Post/${lista[index]['imagen_p']}',
                                    ),
                                    width: 250, // Ancho deseado
                                    height: 150, // Altura deseada
                                    fit: BoxFit.cover
                                    // AssetImage('assets/ejemplo2.jpg'),
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              lista[index]['titulo'],
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Text(
                              lista[index]['fecha'],
                              style:
                                  TextStyle(fontFamily: 'Roboto', fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
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
                  width: isActive
                      ? 30.0
                      : 5.0, // Ajusta el ancho según esté activo o no
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
            height: 20,
          ),
          Container(
            // Utiliza MediaQuery para obtener el ancho del dispositivo
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
                      backgroundColor: Color(0xFF4FC028),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      'Mas Información',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width *
                            0.02, // Ajusta el tamaño del texto según el ancho de la pantalla
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
// class _bannerHorizontal extends StatelessWidget {
//   const _bannerHorizontal({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 250,
//       height: 300,
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: FadeInImage(
//               placeholder: AssetImage('assets/no-image.jpg'),
//               image: // NetworkImage('https://via.placeholder.com/300x400'),
//                   AssetImage('assets/ejemplo2.jpg'),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Text('Titulo de la noticia')
//         ],
//       ),
//     );
//   }
// }
