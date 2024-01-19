import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class detallePostScreen extends StatefulWidget {
  final dynamic value;
  const detallePostScreen({super.key, this.value});

  @override
  State<detallePostScreen> createState() => _detallePostScreenState();
}

class _detallePostScreenState extends State<detallePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFF211A46),
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // centerTitle: true,
              // titlePadding: EdgeInsets.all(0),
              // title: Text(widget.value['titulo']),
              background: Hero(
                tag: widget.value['id_p'],
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(
                    'http://amfpro.mx/intranet/public/ArchivosSistema/Post/${widget.value['imagen_p']}',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),

                  // Título
                  Text(
                    widget.value['titulo'],
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'),
                  ),
                  if (widget.value['subtitulo'] != null) SizedBox(height: 8.0),

                  // Subtítulo
                  if (widget.value['subtitulo'] != null)
                    Text(
                      widget.value['subtitulo'],
                      style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Roboto'),
                    ),
                  SizedBox(height: 8.0),
                  // Fecha
                  Text(
                    'Fecha: ${widget.value['fecha']}',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                        fontFamily: 'Roboto'),
                  ),
                  SizedBox(height: 8.0),
                  // Descripción
                  HtmlWidget(
                    widget.value['informacion'],
                    textStyle: TextStyle(fontFamily: 'Roboto', fontSize: 12),
                    customWidgetBuilder: (element) {
                      if (element.localName == 'p' ||
                          element.localName == 'div') {
                        // Si el elemento es un párrafo o una división, justificar el texto
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: Colors
                                    .black, // Puedes ajustar el color del texto
                              ),
                              text: element.text,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        );
                      }
                      // Otros elementos se manejan de forma predeterminada
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
