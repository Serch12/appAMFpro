import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class fotoReversoScreen extends StatefulWidget {
  final id;
  final nui;
  final pdf2;
  const fotoReversoScreen({Key? key, this.id, this.nui, this.pdf2})
      : super(key: key);

  @override
  State<fotoReversoScreen> createState() => _fotoReversoScreenState();
}

class _fotoReversoScreenState extends State<fotoReversoScreen> {
  late String nui;
  late String pdf2;
  late String id;
  bool boton2Activado = false;
  String? _nuevafoto;
  String? _path;

  @override
  void initState() {
    super.initState();
    // Asigna los valores de las variables nui y foto desde el widget padre
    nui = widget.nui.toString(); // Convertir a String
    pdf2 = widget.pdf2.toString();
    id = widget.id.toString(); // Convertir a String
  }

  Future<void> _pickImageAnverso(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? archivo = await picker.pickImage(
        source: source,
      );
      if (archivo != null) {
        _path = archivo.path;
        List<int> bytes = File(_path!).readAsBytesSync();
        _nuevafoto = base64.encode(bytes);
        // Mueve la lógica de mostrar la imagen aquí
        // En lugar de esperar a que se cierre el AlertDialog

        // Cierra el AlertDialog actualmente abierto
        Navigator.of(context).pop();
        // Llama a _mostrarAlertDialogPerfil() después de cerrar el AlertDialog para abrirlo nuevamente con la imagen seleccionada
        _mostrarAlertDialogReverso();
      }
    } catch (e) {
      print('Error al cargar imagen de perfil: $e');
    }
  }

  void _mostrarAlertDialogReverso() async {
    showDialog(
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
                    7, // Posicionado en la mitad de la pantalla
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      color: Colors
                          .transparent, // Color transparente para aplicar el desenfoque
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0, // Quita el sombreado del AlertDialog
                        contentPadding: EdgeInsets.only(
                          // top: MediaQuery.of(context).size.height *
                          //     0.1, // Sube el contenido un 10% de la altura de la pantalla
                          bottom: MediaQuery.of(context).size.height *
                              0.4, // También puedes ajustar el margen inferior si lo deseas
                        ),
                        content: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: _nuevafoto == null
                              ? _buildDefaultContent()
                              : _buildSelectedImageContent(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Contenedor sin filtro
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultContent() {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.8, // Utiliza el 80% del ancho del dispositivo
      height: MediaQuery.of(context).size.height *
          0.5, // Utiliza el 80% del ancho del dispositivo
      alignment: Alignment.center,
      child: Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                ), // Icono de tache
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl:
                    'https://test-intranet.amfpro.mx/ArchivosSistema/Afiliados/$nui/$pdf2',
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width *
                    0.6, // Tamaño máximo de la imagen
                height: MediaQuery.of(context).size.height * 0.4,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ],
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FractionalTranslation(
            translation: Offset(-0.4, 0.3),
            child: GestureDetector(
              onTap: () {
                // Al presionar el icono, muestra el menú desplegable
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                      MediaQuery.of(context).size.width *
                          0.4, // Posición x en un 40% desde la izquierda
                      MediaQuery.of(context).size.height *
                          0.72, // Posición y en un 70% desde arriba
                      MediaQuery.of(context).size.width *
                          0.4, // Misma posición x de inicio
                      0), // Misma posición y de inicio
                  color: Color(0xFFF3F3F3),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bordes redondeados
                  ),

                  items: [
                    PopupMenuItem(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Cambiar archivo",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                color: Color(0xFF6EBC44)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 1.0, right: 1.0),
                            child: Divider(
                              color: Color(0xFFC0BBBB),
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      value: 1000,
                    ),
                    // PopupMenuItem(
                    //   // padding: EdgeInsets.all(5),
                    //   child: Text(
                    //     "Hacer una foto nueva",
                    //     style: TextStyle(fontFamily: 'Roboto', fontSize: 10),
                    //   ),
                    //   value: 1001,
                    //   onTap: () async {
                    //     _pickImageAnverso(ImageSource.camera);
                    //   },
                    // ),
                    PopupMenuItem(
                      // padding: EdgeInsets.all(5),
                      child: Text(
                        "Elegir archivo de galería",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 10),
                      ),
                      value: 1002,
                      onTap: () async {
                        _pickImageAnverso(ImageSource.gallery);
                      },
                    ),
                  ],
                );
              },
              child: Image.asset(
                'assets/editaimagen.png',
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildSelectedImageContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20), // Radio de los bordes
          child: Image.file(
            File(_path!),
            height: MediaQuery.of(context).size.height * 0.3,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                  onPressed: () async {
                    _regresaVistaAnterior();
                  },
                  icon: Image.asset(
                    'assets/regresar.png',
                  ),
                  iconSize: 50,
                  splashRadius: 20),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ElevatedButton(
                onPressed: () {
                  editaFotoReverso();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF4FC028),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50.0)),
                child: Text(
                  'Actualizar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width *
                        0.03, // Ajusta el tamaño del texto según el ancho de la pantalla
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _regresaVistaAnterior() async {
    _nuevafoto = null;
    // Cierra el AlertDialog actualmente abierto
    Navigator.of(context).pop();
    // Llama a _mostrarAlertDialogPerfil() después de cerrar el AlertDialog para abrirlo nuevamente con la imagen seleccionada
    _mostrarAlertDialogReverso();
  }

  Future<void> editaFotoReverso() async {
    Navigator.of(context).pop();
    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/editafotoreverso'); // Reemplaza con la URL de tu API de Laravel
    Map<String, dynamic> data = {
      "id_afi": id,
      "nui": nui,
      "nueva_foto": _nuevafoto,
      "pdf2": pdf2
    };

    final response = await http.post(url, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    });
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
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
                    'Se edito correctamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap:
                        true, // Permite que el texto se ajuste al ancho disponible
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.pushReplacementNamed(context, 'homeroute');
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
      // Actualiza la URL de la foto con la nueva URL devuelta por el servidor

      setState(() {
        pdf2 = jsonResponse['url_foto_nueva'];
      });
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
                    'Error al editar foto de perfil',
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
    _nuevafoto = null;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // setState(() {
        //   boton1Activado = false;
        //   boton2Activado = true;
        // });
        _mostrarAlertDialogReverso();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: boton2Activado ? Colors.white : Color(0xFF211A46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              25.0), // Ajusta el radio según tus necesidades
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width *
              0.4, // Ajusta el ancho del botón según el ancho de la pantalla
          MediaQuery.of(context).size.height *
              0.05, // Ajusta el alto del botón según el ancho de la pantalla
        ),
      ),
      child: Text(
        'Reverso',
        style: TextStyle(
          color: boton2Activado ? Color(0xFF211A46) : Colors.white,
        ),
      ),
    );
  }
}
