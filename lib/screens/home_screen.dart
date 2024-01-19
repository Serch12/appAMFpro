import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:splash_animated/screens/screens.dart';
// import 'package:splash_animated/providers/twitter_provider.dart';
import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:card_swiper/card_swiper.dart';

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
    setState(() {
      lista_publicaciones =
          List<Map<String, dynamic>>.from(json.decode(respuesta.body));
    });
  }

  void obtenerDatosDeAPI() async {
    final url = Uri.http(_urlBase, '/api/noticias/comunicados');
    final respuesta2 = await http.get(url);
    setState(() {
      lista = List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // final twitterProvider = Provider.of<TwitterProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    // final mapeoFinal = twitterProvider.listadoPublicaciones;
    final Future<String> userDataFuture = authService.autenticacion();
    userDataFuture.then((userDataString) {
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.5,
            child: Stack(
              children: [
                Swiper(
                  autoplay: true,
                  autoplayDelay:
                      8000, // Duración en milisegundos (en este caso, 5 segundos)
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color:
                          Colors.grey, // Color de los puntos no seleccionados
                      activeColor:
                          Color(0XFF6EBC44), // Color del punto seleccionado
                      size: 8.0, // Tamaño de los puntos
                      activeSize: 10.0, // Tamaño del punto seleccionado
                      space: 5.0, // Espaciado entre los puntos
                    ),
                  ),
                  itemCount: lista_publicaciones.length,
                  layout: SwiperLayout.STACK,
                  itemWidth: size.width,
                  itemHeight: size.height,
                  itemBuilder: (_, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/no-image.jpg'),
                        image: NetworkImage(
                            'http://amfpro.mx/intranet/public/ArchivosSistema/PostApp/${lista_publicaciones[index]['archivo']}'),
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'Lorem ipsum dolor',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      // fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF424753),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis quis nisi elit. Sed ut auctor nulla. Suspendisse potenti. Aenean in elementum quam, a tincidunt libero. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin volutpat sodales diam vitae suscipit. Sed pulvinar ipsum metus, sagittis ultrices leo pretium ut. Maecenas mattis, nibh sit amet lobortis luctus, felis metus aliquam eli',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      // fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF9A9A9A),
                    ),
                  ),
                )
              ],
            ),
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
