import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/services/services.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

class LoginBiometricsScreen extends StatelessWidget {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  // const LoginBiometricsScreen({Key? key}) : super(key: key);

  // Nueva función para la navegación
  void _navigateToHomeRoute(BuildContext context) {
    Navigator.pushNamed(context, 'homeroute');
  }

  Future<void> _authenticate(BuildContext context) async {
    bool authenticated = false;

    try {
      authenticated = await _localAuthentication.authenticate(
          localizedReason: 'Autenticación biométrica requerida',
          options: const AuthenticationOptions(
            useErrorDialogs: true, // Mostrar diálogos de error
            stickyAuth:
                true, // Mantener el diálogo de autenticación abierto hasta que el usuario lo cierre
          ));
    } catch (e) {
      print("Error en la autenticación biométrica: $e");
    }

    if (authenticated) {
      // El usuario fue autenticado exitosamente
      print("Autenticación exitosa");
      // Aquí puedes navegar a la siguiente pantalla o realizar acciones después de la autenticación exitosa
      Navigator.pushNamed(context, 'homeroute');
    } else {
      // La autenticación falló
      print("Autenticación fallida");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back.jpg'), // Ruta de la imagen
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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 30),
                  const Image(
                    image: AssetImage('assets/logoblanco.png'),
                    width: 73,
                    height: 93,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      child: Text('Bienvenido',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.bold))),
                  // SizedBox(
                  //     child: Text('Emmanuel Damian Peña',
                  //         style: TextStyle(
                  //             fontSize: 28,
                  //             fontFamily: 'RobotoMono',
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.green))),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    child: Text(
                      'Ingresar con huella o rostro',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _authenticate(
                          context); // Llamar a la función de navegación
                    },
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
                  const SizedBox(
                    height: 30,
                  ),
                  const Image(
                    image: AssetImage('assets/bio.png'),
                    width: 73,
                    height: 93,
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
