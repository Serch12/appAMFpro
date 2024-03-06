import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/screens/verification_code_screen.dart';
// import 'package:splash_animated/theme/app_theme.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

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

  @override
  void dispose() {
    pinController
        .dispose(); // Liberar el controlador cuando el widget se elimine
    super.dispose();
  }

  Color getItemTextColor(int value) {
    return value == selectedLength ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    MyProvider myProvider = Provider.of<MyProvider>(context, listen: false);
    MyProvider myProvider2 = Provider.of<MyProvider>(context);
    dynamic ver = false;
    dynamic jugador = [];

    Future<void> _enviaCodigoVerificacion() async {
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
      setState(() {
        isLoading = false; // Activar el indicador de carga
      });
    }

    return Scaffold(
      body: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back.jpg'), // Ruta de la imagen
              fit: BoxFit.cover,
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
                  const Image(
                    image: AssetImage('assets/logoblanco.png'),
                    width: 73,
                    height: 93,
                  ),
                  // const SizedBox(height: 30),
                  // const SizedBox(
                  //     child: Text('BIENVENIDO',
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 40,
                  //             fontFamily: 'RobotoMono',
                  //             fontWeight: FontWeight.bold))),
                  const SizedBox(height: 30),
                  const SizedBox(
                      // width: MediaQuery.of(context).size.width,//le decimmos que ocupe todo el ancho
                      child: Text(
                    'SELECCIONA LA CANTIDAD DE DÍGITOS DE TU NUI.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
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
                      style: TextStyle(color: Colors.white),
                      value: selectedLength,
                      items: [
                        DropdownMenuItem(
                          value: 5,
                          child: Text('5 Dígitos',
                              style: TextStyle(color: getItemTextColor(5))),
                        ),
                        DropdownMenuItem(
                          value: 6,
                          child: Text('6 Dígitos',
                              style: TextStyle(color: getItemTextColor(6))),
                        ),
                      ],
                      onChanged: (value) {
                        // myProviderDigitos.sendData(value!);
                        // print(value);
                        setState(() {
                          selectedLength = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          // Establecer el borde como un OutlineInputBorder
                          borderSide: BorderSide(
                              color: Color(0xFF4FC028)), // Borde verde
                          borderRadius: BorderRadius.circular(
                              8.0), // Radio de borde de 8.0 (ajusta según tus necesidades)
                        ),
                        enabledBorder: OutlineInputBorder(
                          // Establecer el borde habilitado
                          borderSide: BorderSide(
                              color: Color(0xFF4FC028)), // Borde verde
                          borderRadius: BorderRadius.circular(
                              8.0), // Radio de borde de 8.0 (ajusta según tus necesidades)
                        ),
                        focusedBorder: OutlineInputBorder(
                          // Establecer el borde enfocado
                          borderSide: BorderSide(
                              color: Color(0xFF4FC028)), // Borde verde
                          borderRadius: BorderRadius.circular(
                              8.0), // Radio de borde de 8.0 (ajusta según tus necesidades)
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
                        length: selectedLength,
                        cursorHeight: 19,
                        enableActiveFill: true,
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
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
                          if (value.length == selectedLength) {
                            await myProvider.sendData(value, ver, jugador);
                            setState(() {});
                            if (myProvider2._vizualiza == false) {
                              showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // No permite cerrar la alerta al tocar fuera de ella
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Row(
                                        children: [
                                          Icon(Icons.cancel,
                                              color: Colors
                                                  .red), // Icono a la izquierda del texto
                                          SizedBox(
                                              width:
                                                  10.0), // Espacio entre el icono y el texto
                                          Flexible(
                                            child: Text(
                                              'NUI no registrado en AMFpro.',
                                              style: TextStyle(
                                                  color: Color(0xFF1AD598)),
                                              overflow: TextOverflow.visible,
                                              softWrap:
                                                  false, // Permite que el texto se desborde
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Cerrar la alerta al presionar el botón
                                                pinController.text = "";
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.black,
                                              )),
                                        ],
                                      ),

                                      contentPadding: EdgeInsets.fromLTRB(
                                          15.0,
                                          10.0,
                                          0.0,
                                          0.0), // Ajustar el padding del contenido
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Ajustar el radio del borde
                                      ),
                                      actions: [],
                                    );
                                  });
                            }
                          }
                        }),
                      )),
                  // const SizedBox(height: 15),
                  Visibility(
                    visible: myProvider2._vizualiza,
                    child: TextButton(
                      onPressed: isLoading ? null : _enviaCodigoVerificacion,
                      child: isLoading
                          ? SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'ENVIAR CÓDIGO DE VERIFICACIÓN',
                              style: TextStyle(
                                color:
                                    Colors.white, // Color del texto del botón
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
                          horizontal: MediaQuery.of(context).size.width * 0.09,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        backgroundColor: Color(0xFF4FC028),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !myProvider2._vizualiza,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'registro_afiliado');
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
                          horizontal: MediaQuery.of(context).size.width * 0.3,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        backgroundColor: Color(0xFF4FC028),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
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
    print(_vizualiza);
    notifyListeners();
  }

  // }
}
