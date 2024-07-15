import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:splash_animated/screens/login_screen.dart';

class newPasswordScreen extends StatefulWidget {
  const newPasswordScreen({super.key});

  @override
  State<newPasswordScreen> createState() => _newPasswordScreenState();
}

class _newPasswordScreenState extends State<newPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmaPasswordController = TextEditingController();
  bool isLoading = false;
  // Variable para controlar la visibilidad de la contraseña
  bool _passwordVisible = false;

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }
    return null;
  }

  String? _validateConfirmaPassword(String? value) {
    if (value!.isEmpty) {
      return 'Por favor confirma tu contraseña';
    } else if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _recuperarContrasena() async {
    if (_formKey.currentState!.validate() == false) {
      print('error');
    } else {
      setState(() {
        isLoading = true; // Activar el indicador de carga
      });
      try {
        isLoading = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } catch (e) {
        print('Error al cambiar contraseña: $e');
      }
      setState(() {});
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
        body: SingleChildScrollView(
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
              SizedBox(
                height: 30,
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: 344,
                    child: Column(
                      children: [
                        Material(
                          elevation: 7.0,
                          color: Colors.transparent,
                          shadowColor: Color.fromARGB(255, 193, 192, 192)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          child: TextFormField(
                            autocorrect: false,
                            obscureText: !_passwordVisible,
                            controller: _passwordController,
                            validator: _validatePassword,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'NUEVA CONTRASEÑA*',
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
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // validator: (value) {
                            //   if (value!.isEmpty || !value.contains('@')) {
                            //     return 'Ingresa un correo electrónico válido';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        const SizedBox(height: 25),
                        Material(
                          elevation: 7.0,
                          color: Colors.transparent,
                          shadowColor: Color.fromARGB(255, 193, 192, 192)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          child: TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            controller: _confirmaPasswordController,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'CONFIMACIÓN DE CONTRASEÑA*',
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
                            validator: _validateConfirmaPassword,
                            // validator: (value) {
                            //   if (value!.isEmpty || !value.contains('@')) {
                            //     return 'Ingresa un correo electrónico válido';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        // ElevatedButton(
                        //     onPressed: isLoading ? null : _recuperarContrasena,
                        //     child: isLoading
                        //         ? SizedBox(
                        //             width: 20.0,
                        //             height: 20.0,
                        //             child: CircularProgressIndicator(
                        //               strokeWidth: 3.0,
                        //               valueColor: AlwaysStoppedAnimation<Color>(
                        //                   Colors.white),
                        //             ),
                        //           ) // Indicador de carga
                        //         : Text(
                        //             'Recuperar contraseña',
                        //             style: GoogleFonts.roboto(
                        //               color: Colors.white,
                        //               fontSize: 15.0,
                        //             ),
                        //             softWrap: false,
                        //           ),
                        //     style: TextButton.styleFrom(
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: 100.00, vertical: 15.00),
                        //         backgroundColor: Color(0xFF4FC028),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(15.0),
                        //           side: BorderSide(color: Colors.green),
                        //         )))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: ElevatedButton(
                    onPressed: isLoading ? null : _recuperarContrasena,
                    child: isLoading
                        ? SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
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
                        ))),
              ),
              SizedBox(height: 310),
              Container(
                width: 320,
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
                            fontSize: 16,
                            color: Color(0xFF060606))),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
