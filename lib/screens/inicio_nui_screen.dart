import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/screens/verification_code_screen.dart';
// import 'package:splash_animated/theme/app_theme.dart';
import 'dart:convert' as convert;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:splash_animated/services/notification_service.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class InicioNuiScreen extends StatefulWidget {
  const InicioNuiScreen({Key? key}) : super(key: key);

  @override
  State<InicioNuiScreen> createState() => _InicioNuiScreenState();
}

class _InicioNuiScreenState extends State<InicioNuiScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: contenido(),
    );
  }
}

class contenido extends StatefulWidget {
  const contenido({
    Key? key,
  }) : super(key: key);

  @override
  State<contenido> createState() => _contenidoState();
}

class _contenidoState extends State<contenido> {
  int selectedLength = 6;
  TextEditingController pinController = TextEditingController();
  String username = 'intranet@amfpro.mx';
  String password = 'A1b2c3d4.';
  bool isLoading = false;
  bool isLoading2 = false;
  bool botonverde = false;
  bool? _aceptarmail = false;
  bool? _aceptartext = false;

  @override
  void dispose() {
    pinController
        .dispose(); // Liberar el controlador cuando el widget se elimine
    super.dispose();
  }

  // Color getItemTextColor(int value) {
  //   return value == selectedLength ? Colors.white : Colors.black;
  // }

  @override
  Widget build(BuildContext context) {
    MyProvider myProvider = Provider.of<MyProvider>(context, listen: false);
    MyProvider myProvider2 = Provider.of<MyProvider>(context);
    dynamic ver = false;
    dynamic jugador = [];

    Future<void> _enviaCodigoVerificacion() async {
      if (_aceptarmail == false && _aceptartext == false) {
        NotificationsService.showSnackBar('¡Debes seleccionar una opción!');
      } else {
        setState(() {
          isLoading = true; // Activar el indicador de carga
        });
        // Navigator.pushReplacementNamed(
        //     context, 'verification_code_screen');

        Random random = Random();
        int code1 = random.nextInt(900000) +
            100000; // Generar un número aleatorio de 6 dígitos
        final code = code1.toString();
        // String cuerpo = 'Tu código de verificación es: $code';
        // List<String> recipients = ['+527293641178'];
        // sendSMS(message: cuerpo, recipients: recipients);
        // print('SMS enviado exitosamente');

        if (_aceptarmail == true) {
          final smtpServer = SmtpServer('smtp.hostinger.com',
              username: username,
              password: password,
              port: 465,
              ssl:
                  true // Puerto del servidor SMTP (puede variar según el proveedor)
              ); // Utiliza SSL/TLS si es necesario (puede variar según el proveedor)

          final message = Message()
            ..from = Address(username)
            ..recipients.add(myProvider2._jugador["data"]["mail"])
            ..subject = 'Código de verificación'
            ..html = '''
                <html>
                  <body>
                    <p>Tu código de verificación es:</p>
                    <h1>$code</h1>
                  </body>
                </html>
              ''';
          try {
            final sendReport = await send(message, smtpServer);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationCodeScreen(
                    value: myProvider2._jugador, codigo: code1),
              ),
            );
          } catch (e) {
            print('Error al enviar el correo electrónico: $e');
          }
        }
        if (_aceptartext == true) {
          try {
            final twilio = TwilioFlutter(
              accountSid: 'AC4b5fea5f68d38c49c1ebeabbaca75795',
              authToken: 'c5967971fcecaeca2cdc9508f01f5311',
              twilioNumber: '+525596616798',
            );

            await twilio.sendSMS(
              toNumber:
                  '+52${myProvider2._jugador["data"]["celular"]}', // Número de destino
              messageBody: 'Tu codigo de verificación es: ${code}',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationCodeScreen(
                    value: myProvider2._jugador, codigo: code1),
              ),
            );
          } catch (e) {
            print('Error al enviar el mensaje: $e');
          }
        }

        setState(() {
          isLoading = false; // Activar el indicador de carga
        });
      }
    }

    Future<void> actualizaLongitud(int? value) async {
      setState(() {
        pinController.clear();
        selectedLength = value!;
      });
    }

    return Scaffold(
      body: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/fondo-gris-principal-dos.jpg'), // Ruta de la imagen
              fit: BoxFit.fill,
              alignment: Alignment(-1,
                  1.0), // Opcional: ajusta la imagen al tamaño del contenedor
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10),
                  // const Image(
                  //   image: AssetImage('assets/logoblanco.png'),
                  //   width: 73,
                  //   height: 93,
                  // ),
                  const SizedBox(height: 80),
                  const SizedBox(
                      child: Text('BIENVENIDO',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.bold))),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.0,
                    child: Text(''),
                  ),
                  SizedBox(
                      // width: MediaQuery.of(context).size.width,//le decimmos que ocupe todo el ancho
                      child: Text(
                    'SELECCIONA LA CANTIDAD',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  )),
                  SizedBox(
                      // width: MediaQuery.of(context).size.width,//le decimmos que ocupe todo el ancho
                      child: Text(
                    'DE DÍGITOS DE TU NUI.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  )),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.transparent), // Bordes verdes
                      borderRadius: BorderRadius.circular(
                          8.0), // Radio de borde de 8.0 (ajusta según tus necesidades)
                      color: Colors.transparent,
                      // Fondo transparente
                    ),
                    width: 240,
                    height: 60,
                    child: DropdownButtonFormField<int>(
                      style: TextStyle(color: Colors.green),
                      value: selectedLength,
                      items: [
                        DropdownMenuItem(
                          value: 5,
                          child: Text('5 Dígitos'),
                        ),
                        DropdownMenuItem(
                          value: 6,
                          child: Text('6 Dígitos'),
                        ),
                      ],
                      onChanged: (value) async {
                        actualizaLongitud(value);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4FC028), // Borde verde
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4FC028), // Borde verde
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4FC028), // Borde verde
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const SizedBox(
                      // width: MediaQuery.of(context).size.width,//le decimmos que ocupe todo el ancho
                      child: Text(
                    'INGRESA TU NUI PARA INGRESAR',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )),
                  const SizedBox(height: 20),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: PinCodeTextField(
                        keyboardType: TextInputType.number,
                        appContext: context,
                        controller: pinController,
                        length: selectedLength, // Usar el valor seleccionado
                        cursorHeight: 19,
                        enableActiveFill: true,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          inactiveColor:
                              Color(0xFF4FC028), //color del borde inactivo
                          selectedColor: Color(
                              0xFF4FC028), //color de border de casilla seleccionada
                          activeFillColor:
                              Colors.transparent, // color de casilla llena
                          selectedFillColor:
                              Color(0xFF4FC028), //color de casilla seleccionada
                          inactiveFillColor:
                              Colors.white, //color de casilla sin seleccionar
                          borderWidth: 1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onChanged: ((value) async {
                          setState(() {
                            isLoading2 = false; // Mostrar loading
                            _aceptarmail = false;
                            _aceptartext = false;
                          });
                          if (value.length == selectedLength) {
                            setState(() {
                              isLoading2 = true; // Mostrar loading
                            });
                            await myProvider.sendData(value, ver, jugador);
                            setState(() {
                              botonverde = true;
                              isLoading2 = false;
                            });
                            if (myProvider2._vizualiza == false) {
                              NotificationsService.showSnackBar(
                                  'NUI no registrado en AMFpro. ¡Registrate!');
                              // Navigator.of(context).pop();
                              pinController.text = "";
                              isLoading2 = false;
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (BuildContext context) {
                              //     return AlertDialog(
                              //       content: Row(
                              //         children: [
                              //           Icon(
                              //             Icons.cancel,
                              //             color: Colors.red,
                              //           ),
                              //           SizedBox(width: 10.0),
                              //           Flexible(
                              //             child: Text(
                              //               'NUI no registrado en AMFpro.',
                              //               style: TextStyle(
                              //                 color: Colors.red,
                              //               ),
                              //               overflow: TextOverflow.visible,
                              //               softWrap:
                              //                   true, // Permite que el texto se desborde
                              //             ),
                              //           ),
                              //           TextButton(
                              //             onPressed: () {
                              //               Navigator.of(context).pop();
                              //               pinController.text = "";
                              //               isLoading2 = false;
                              //             },
                              //             child: Icon(
                              //               Icons.clear,
                              //               color: Colors.black,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       contentPadding: EdgeInsets.fromLTRB(
                              //           15.0, 10.0, 0.0, 0.0),
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10.0),
                              //       ),
                              //       actions: [],
                              //     );
                              //   },
                              // );
                            }
                          }
                        }),
                      )),
                  isLoading2
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Colors
                                  .white), // Indicador de carga en el centro
                        )
                      : Column(
                          children: [
                            botonverde == true
                                ? Visibility(
                                    visible: myProvider2._vizualiza,
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  'assets/message_mail.png'),
                                              SizedBox(width: 50),
                                              Image.asset(
                                                  'assets/message_text.png'),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: CheckboxListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 117),
                                                  value: _aceptarmail,
                                                  activeColor:
                                                      Color(0xFF211A46),
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading, // Establece el control (Checkbox) a la izquierda

                                                  onChanged: (value) {
                                                    setState(() {
                                                      _aceptarmail = value!;
                                                      _aceptartext = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                              // SizedBox(width: 50),
                                              Expanded(
                                                child: CheckboxListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(left: 37),
                                                  value: _aceptartext,
                                                  activeColor:
                                                      Color(0xFF211A46),
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading, // Establece el control (Checkbox) a la izquierda

                                                  onChanged: (value) {
                                                    setState(() {
                                                      _aceptartext = value!;
                                                      _aceptarmail = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Center(
                                            child: _aceptarmail == true
                                                ? Text(
                                                    formatEmail(myProvider2
                                                            ._jugador["data"]
                                                        ["mail"]),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : _aceptartext == true
                                                    ? Text(
                                                        '...${myProvider2._jugador["data"]["celular"].toString().substring(myProvider2._jugador["data"]["celular"].toString().length - 4)}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))
                                                    : Text(''),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _aceptarmail == true ||
                                                _aceptartext == true
                                            ? TextButton(
                                                onPressed: isLoading
                                                    ? null
                                                    : _enviaCodigoVerificacion,
                                                child: isLoading
                                                    ? SizedBox(
                                                        width: 20.0,
                                                        height: 20.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 3.0,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    : Text(
                                                        'ENVIAR CÓDIGO DE VERIFICACIÓN',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .white, // Color del texto del botón
                                                          fontSize:
                                                              15.0, // Tamaño de fuente del texto del botón
                                                          overflow: TextOverflow
                                                              .visible, // Permite que el texto se desborde
                                                        ),
                                                        softWrap:
                                                            false, // Evitar que el texto se divida en varias líneas
                                                      ),
                                                // child: const Text('Enviar código de verificacón.',
                                                //     style: TextStyle(color: Colors.green, fontSize: 14)),
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.09,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                  ),
                                                  backgroundColor:
                                                      Color(0xFF4FC028),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    side: BorderSide(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  )
                                : Container(),
                            botonverde == true
                                ? Visibility(
                                    visible: !myProvider2._vizualiza,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, 'registro_afiliado');
                                      },
                                      child: Text(
                                        'Regístrate',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        backgroundColor: Color(0xFF4FC028),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          side: BorderSide(color: Colors.green),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                  // const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Proveedor
class MyProvider with ChangeNotifier {
  dynamic _parameter;

  dynamic get data => _parameter;
  dynamic _vizualiza = false;
  dynamic get ver => _vizualiza;
  dynamic _jugador;
  dynamic get infojugador => _jugador;

  Future<void> sendData(dynamic value, bool vizualiza, dynamic jugador) async {
    // Realiza las operaciones necesarias con los datos recibidos
    final _urlBase = 'test-intranet.amfpro.mx';
    _parameter = value;
    _vizualiza = vizualiza;
    _jugador = jugador;
    final url = Uri.http(_urlBase, '/api/datos-afiliados/nui/$_parameter');
    final respuesta = await http.get(url);
    _jugador = json.decode(respuesta.body);
    // Notifica a los oyentes del cambio en los datos
    if (_jugador["data"] == 'No se encontro ningun resultado') {
      _vizualiza = false;
    } else {
      _vizualiza = true;
    }
    notifyListeners();
  }

  // }
}

String formatEmail(String email) {
  if (!email.contains('@')) return email; // Verifica si es un email válido.

  final splitEmail = email.split('@');
  final username = splitEmail[0];
  final domain = splitEmail[1];

  // Asegúrate de que el nombre de usuario tenga al menos 2 caracteres.
  final formattedUsername =
      username.length > 4 ? '${username.substring(0, 4)}...' : '$username...';

  return '$formattedUsername@$domain';
}
