import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class fotoPerfilScreen extends StatefulWidget {
  final id;
  final nui;
  final foto;
  const fotoPerfilScreen({Key? key, this.id, this.nui, this.foto})
      : super(key: key);

  @override
  State<fotoPerfilScreen> createState() => _fotoPerfilScreenState();
}

class _fotoPerfilScreenState extends State<fotoPerfilScreen> {
  late String nui;
  late String foto;
  late String id;
  String? _nuevafoto;
  String? _path;

  @override
  void initState() {
    super.initState();
    // Asigna los valores de las variables nui y foto desde el widget padre
    nui = widget.nui.toString(); // Convertir a String
    foto = widget.foto.toString();
    id = widget.id.toString(); // Convertir a String
  }

  Future<void> _mostrarAlertDialogPerfil() async {
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
                              0.3, // También puedes ajustar el margen inferior si lo deseas
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

  Widget _buildDefaultContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Botón de cierre
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
          borderRadius: BorderRadius.circular(20), // Radio de los bordes
          child: CachedNetworkImage(
            imageUrl:
                'https://test-intranet.amfpro.mx/ArchivosSistema/Afiliados/$nui/$foto',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.3,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF6EBC44),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                onPressed: () async {
                  _pickImagePerfil(ImageSource.gallery);
                },
                icon: Image.asset(
                  'assets/gallery1.png',
                ),
                iconSize: 50,
                splashRadius: 20,
                tooltip: 'Cargar imagen desde galería',
              ),
            ),
            // SizedBox(width: 30),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Color(0xFF6D6F70),
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //   ),
            //   child: IconButton(
            //     onPressed: () async {
            //       _pickImagePerfil(ImageSource.camera);
            //     },
            //     icon: Image.asset(
            //       'assets/camara1.png',
            //     ),
            //     iconSize: 50,
            //     splashRadius: 20,
            //     tooltip: 'Cargar imagen desde cámara',
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedImageContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _path != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20), // Radio de los bordes
                child: Image.file(
                  File(_path!),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20), // Radio de los bordes
                child: CachedNetworkImage(
                  imageUrl:
                      'https://test-intranet.amfpro.mx/ArchivosSistema/Afiliados/$nui/$foto',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.3,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                  editaFotoPerfil();
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

  Future<void> _pickImagePerfil(ImageSource source) async {
    try {
      // // Solicitar permisos
      // PermissionStatus cameraStatus = await Permission.camera.status;
      // PermissionStatus storageStatus = await Permission.storage.status;

      // if (!cameraStatus.isGranted) {
      //   cameraStatus = await Permission.camera.request();
      // }
      // if (!storageStatus.isGranted) {
      //   storageStatus = await Permission.storage.request();
      // }
      // // Si los permisos son otorgados, proceder con la selección de imagen
      // if (cameraStatus.isGranted && storageStatus.isGranted) {
      // final picker = ImagePicker();
      final XFile? archivo =
          await ImagePicker().pickImage(source: source, imageQuality: 100);
      if (archivo != null) {
        _path = archivo.path;
        List<int> bytes = await File(_path!).readAsBytes();
        _nuevafoto = base64.encode(bytes);
        // Mueve la lógica de mostrar la imagen aquí
        // En lugar de esperar a que se cierre el AlertDialog
        if (mounted) {
          // Cierra el AlertDialog actualmente abierto
          Navigator.of(context).pop();
          // Llama a _mostrarAlertDialogPerfil() después de cerrar el AlertDialog para abrirlo nuevamente con la imagen seleccionada
          _mostrarAlertDialogPerfil();
        }
      }
      // } else {
      //   print('Permisos de cámara o almacenamiento no otorgados');
      // }
    } catch (e) {
      print('Error al cargar imagen de perfil: $e');
    }
  }

  Future<void> _regresaVistaAnterior() async {
    _nuevafoto = null;
    // Cierra el AlertDialog actualmente abierto
    Navigator.of(context).pop();
    // Llama a _mostrarAlertDialogPerfil() después de cerrar el AlertDialog para abrirlo nuevamente con la imagen seleccionada
    _mostrarAlertDialogPerfil();
  }

  Future<void> editaFotoPerfil() async {
    Navigator.of(context).pop();
    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/editafotoperfil'); // Reemplaza con la URL de tu API de Laravel
    Map<String, dynamic> data = {
      "id_afi": id,
      "nui": nui,
      "nueva_foto": _nuevafoto,
      "foto": foto
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
        foto = jsonResponse['url_foto_nueva'];
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

    // cargarUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFCFC8C8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl:
                    'https://test-intranet.amfpro.mx/ArchivosSistema/Afiliados/$nui/$foto',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: FractionalTranslation(
              translation: Offset(0.2, 0.4),
              child: GestureDetector(
                onTap: () async {
                  // Aquí puedes mostrar el modal
                  // showModal(context);
                  _mostrarAlertDialogPerfil();
                },
                child: Image.asset(
                  'assets/editaimagen.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
