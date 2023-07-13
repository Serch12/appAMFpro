import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class CustomCardNoticia extends StatelessWidget {
  final Map<String, dynamic> publicacion;
  CustomCardNoticia({
    super.key,
    required this.publicacion,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> elementosCarrusel = [];
    String textoConURL = publicacion['text'];
    String textoSinURL = textoConURL.replaceAll(RegExp(r'http\S+'), '');
    final dato = publicacion['created_at'];
    final dateFormat = DateFormat("EEE MMM dd HH:mm:ss '+0000' yyyy", "en_US");
    final dateTime2 = dateFormat.parse(
        dato); // Aquí usarías el valor de la propiedad `created_at` en tu objeto

    final dateFormat2 = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('hh:mm a');

    final dateString = dateFormat2.format(dateTime2);
    final timeString = timeFormat.format(dateTime2);

    final formattedDateTime = '$dateString a las $timeString';
    if (publicacion['entities']['media'] == null) {
      // print(titulo);
      return Card(
        //adecua el contenido
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              leading: Image.asset(
                'assets/twitter.png',
                width: 30,
              ),
              title: Text(textoSinURL, style: TextStyle(color: Colors.green)),
              // subtitle: Text(
              //     'Esto es una texto que muiestra lel contenido del card para ver que se haga muy extenso y ver como se ve el height del contenido fdthrtntrer rthrth rth rthrth rth rhrthtrhrthrthrt rthrthrthrt.'),
              subtitle: Text(formattedDateTime),
            ),
          ],
        ),
      );
    } else {
      if (publicacion["extended_entities"]['media'].length > 1) {
        for (int i = 0;
            i < publicacion["extended_entities"]['media'].length;
            i++) {
          elementosCarrusel.add(
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleImagen(
                        imagen: publicacion["extended_entities"]['media'][i]
                            ['media_url']),
                  ),
                );
              },
              child: Container(
                child: Image.network(
                    publicacion["extended_entities"]['media'][i]['media_url']),
                // O cualquier otro widget que desees mostrar en el carrusel
              ),
            ),
          );
        }
        return Card(
          //adecua el contenido
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          child: Column(
            children: [
              CarouselSlider(
                items: elementosCarrusel,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 1.5,
                  viewportFraction: 1.0,
                  // enlargeCenterPage: true,
                ),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/twitter.png',
                  width: 30,
                ),
                title: Text(textoSinURL, style: TextStyle(color: Colors.green)),
                subtitle: Text(formattedDateTime),
              ),
            ],
          ),
        );
      } else {
        return Card(
          //adecua el contenido
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleImagen(
                          imagen: publicacion["entities"]["media"][0]
                              ["media_url"]),
                    ),
                  );
                },
                child: FadeInImage(
                  placeholder: AssetImage('assets/loading3.gif'),
                  image: NetworkImage(
                      '${publicacion["entities"]["media"][0]["media_url"]}'),
                  width: double.infinity,
                  height: 230,
                  //define que la imagen tome el ancho del contenedor
                  fit: BoxFit.fill,
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/twitter.png',
                  width: 30,
                ),
                title: Text(textoSinURL, style: TextStyle(color: Colors.green)),
                subtitle: Text(formattedDateTime),
              ),
            ],
          ),
        );
      }
    }
  }
}

class DetalleImagen extends StatelessWidget {
  final String imagen;

  DetalleImagen({required this.imagen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(imagen),
        ),
      ),
    );
  }
}
