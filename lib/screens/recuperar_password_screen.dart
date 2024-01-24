import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:splash_animated/screens/verification_code_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class recuperarPasswordScreen extends StatefulWidget {
  const recuperarPasswordScreen({super.key});

  @override
  State<recuperarPasswordScreen> createState() =>
      _recuperarPasswordScreenState();
}

class _recuperarPasswordScreenState extends State<recuperarPasswordScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String username = 'intranet@amfpro.mx';
  String password = 'A1b2c3d4.';
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Future<void> _recuperarContrasena() async {
  //   if (_formKey.currentState!.validate() == false) {
  //     print('error');
  //   } else {
  //     setState(() {
  //       isLoading = true; // Activar el indicador de carga
  //     });

  //     Random random = Random();
  //     int code1 = random.nextInt(900000) +
  //         100000; // Generar un número aleatorio de 6 dígitos
  //     final code = code1.toString();

  //     final smtpServer = SmtpServer(
  //       'smtp.hostinger.com',
  //       username: username,
  //       password: password,
  //       port: 465,
  //       ssl: true,
  //     );

  //     final message = Message()
  //       ..from = Address(username)
  //       ..recipients.add(_emailController.text)
  //       ..subject = 'Código de verificación para recuperación de contraseña'
  //       ..html = '''
  //       <html>
  //         <body>
  //           <p>Tu código de verificación es:</p>
  //           <h1>$code</h1>
  //         </body>
  //       </html>
  //     ''';
  //     print(_emailController.text);
  //     try {
  //       final sendReport = await send(message, smtpServer);
  //       isLoading = false;
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => VerificationCodePasswordScreen(
  //               codigo: code1, correo: _emailController.text),
  //         ),
  //       );
  //     } catch (e) {
  //       print('Error al enviar el correo electrónico: $e');
  //     }
  //     setState(() {});
  //   }
  // }

  Future<void> _recuperarContrasena() async {
    try {
      setState(() {
        isLoading = true; // Activar el indicador de carga
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      isLoading = false;
      Navigator.pushReplacementNamed(context, 'login');
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          barrierDismissible:
              false, // No permite cerrar la alerta al tocar fuera de ella
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  Icon(Icons.cancel,
                      color: Colors.red), // Icono a la izquierda del texto
                  SizedBox(width: 10.0), // Espacio entre el icono y el texto
                  Flexible(
                    child: Text(
                      'El correo ingresado no existe en AMFPro.',
                      style: TextStyle(color: Color(0xFF1AD598)),
                      overflow: TextOverflow.visible,
                      softWrap: false, // Permite que el texto se desborde
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Cerrar la alerta al presionar el botón
                        _emailController.text = "";
                        setState(() {
                          isLoading = false; // Activar el indicador de carga
                        });
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
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          toolbarHeight: 80.0,
          centerTitle: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Olvidaste tu contraseña?',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16.0, color: Colors.white, height: 6),
              ),
            ],
          ),
          backgroundColor: Color(0xFF211A46),
          // shape: ContinuousRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(80.0),
          //     bottomRight: Radius.circular(80.0),
          //   ),
          // ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  // Acción al presionar el IconButton
                },
                icon: Image.asset('assets/logoblanco.png'),
              ),
            ),
          ],
        ),
        body: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      height: 40,
                      width: 430,
                      color: Color(0xFF211A46),
                      child: Center(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                      size: 80.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 320,
                  child: Center(
                    child: Text(
                        'Ingresa tu correo electrónico,te enviaremos un código de recuperación a la brevedad.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Color(0xFF060606))),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.07,
                        // vertical: MediaQuery.of(context).size.height * 0.25,
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 7.0,
                              color: Colors.transparent,
                              shadowColor: Color.fromARGB(255, 193, 192, 192)
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'CORREO ELECTRÓNICO*',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      color: Color(0xFF060606)),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 12.0),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Ingresa un correo electrónico válido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 25),
                            ElevatedButton(
                                onPressed:
                                    isLoading ? null : _recuperarContrasena,
                                child: isLoading
                                    ? SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ) // Indicador de carga
                                    : Text(
                                        'Recuperar contraseña',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            color: Colors.white),
                                        softWrap: false,
                                      ),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 100.00, vertical: 15.00),
                                    backgroundColor: Color(0xFF4FC028),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: Colors.green),
                                    )))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Container(
                  // width: 320,
                  child: Center(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, 'login'),
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Colors.green.withOpacity(0.1)),
                          shape: MaterialStateProperty.all(StadiumBorder())),
                      child: Text('Regresa al inicio',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              color: Color(0xFF060606))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
