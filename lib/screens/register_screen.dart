import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/providers/login_form_provider.dart';
import 'package:splash_animated/services/notification_service.dart';
import 'package:splash_animated/utils/auth.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FractionallySizedBox(
        heightFactor: 1.0,
        widthFactor: 1.0,
        child: Stack(
          fit:
              StackFit.expand, // Ajusta el tamaño del Stack al tamaño del padre
          children: [
            // Imagen de fondo que abarca toda la pantalla
            Image.asset(
              'assets/back.jpg',
              fit: BoxFit.fill,
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Imagen centrada encima de la imagen de fondo
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Image.asset(
                        'assets/logoblanco.png',
                        width: 73,
                        height: 93,
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // Texto debajo de la imagen centrada
                    const Text(
                      'Registrarse',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                        create: (_) => LoginFormProvider(), child: _LoginForm())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  // Variable para controlar la visibilidad de la contraseña
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final AuthService _auth = AuthService();

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07,
          // vertical: MediaQuery.of(context).size.height * 0.25,
        ),
        child: Form(
            key: loginForm.keyFormLogin,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.transparent, //color de fondo del contenedor
                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .transparent, //color del fondo de alerta e input
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Roboto'),
                    decoration: InputDecoration(
                      hintText: 'example@gmail.com',
                      labelText: 'CORREO ELECTRÓNICO',
                      // prefixIcon: Icons.email_outlined,
                      labelStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Color(0xFF979797)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                    onChanged: (value) => loginForm.email = value,
                    validator: (value) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = new RegExp(pattern);
                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'El valor ingresado no luce como un correo.';
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.transparent, //color de fondo del contenedor
                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .transparent, //color del fondo de alerta e input
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    autocorrect: false,
                    obscureText:
                        !_passwordVisible, // Usar la variable _passwordVisible para determinar si se oculta o muestra la contraseña
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                    decoration: InputDecoration(
                      hintText: '******',
                      labelText: 'CONTRASEÑA',
                      labelStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Color(0xFF979797)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: MediaQuery.of(context).size.height * 0.025,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          print(!_passwordVisible);

                          setState(() {
                            _passwordVisible =
                                !_passwordVisible; // Cambiar el estado de visibilidad de la contraseña
                          });
                        },
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Color(0xFFFFFDFD),
                        ),
                      ),
                    ),
                    onChanged: (value) => loginForm.password = value,
                    validator: (value) {
                      if (value != null && value.length >= 6) return null;
                      return 'La contraseña debe ser mayor o igual a 6 caracteres.';
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: Colors.green,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.09,
                            vertical:
                                MediaQuery.of(context).size.height * 0.018,
                          ),
                          child: Text(
                            loginForm.isLoading
                                ? 'GENERANDO USUARIO ...'
                                : 'GUARDAR',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        //si loginform no ejecuta arroja null de lo contrario entra a la ejecucion
                        onPressed: loginForm.isLoading
                            ? null
                            : () async {
                                // ocultar el teclado
                                FocusScope.of(context).unfocus();
                                if (!loginForm.isValidForm()) return;
                                loginForm.isLoading = true;
                                var result = await _auth.createAcount(
                                    loginForm.email, loginForm.password);

                                if (result == 1) {
                                  NotificationsService.showSnackBar(
                                      'Password demasiado débil, favor de cambiar');
                                } else if (result == 2) {
                                  NotificationsService.showSnackBar(
                                      'Email ya está en uso');
                                } else if (result != null) {
                                  Navigator.pushReplacementNamed(
                                      context, 'homeroute');
                                }
                              })),
                SizedBox(
                  height:
                      50, // Alto fijo para el espacio del texto "Registrate aquí"
                  child: Container(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, 'login'),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                          Colors.green.withOpacity(0.1),
                        ),
                        shape: MaterialStateProperty.all(const StadiumBorder()),
                      ),
                      child: const Text(
                        '¿Ya tienes una cuenta? Iniciar Sesión.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
