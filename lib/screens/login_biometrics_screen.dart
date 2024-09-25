import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginBiometricsScreen extends StatelessWidget {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> _authenticate(BuildContext context) async {
    bool authenticated = false;
    bool canCheckBiometrics = false;
    List<BiometricType> availableBiometrics = [];

    try {
      // Comprobar si se puede verificar biometría
      canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      // Obtener los tipos de biometría disponibles
      availableBiometrics = await _localAuthentication.getAvailableBiometrics();

      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        // Intentar autenticar con biometría si está disponible
        authenticated = await _localAuthentication.authenticate(
          localizedReason: 'Autenticación biométrica requerida',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } else {
        // Si no hay biometría configurada, permitir acceso sin biometría
        print("No hay biometría configurada en este dispositivo.");
        Navigator.pushReplacementNamed(context, 'homeroute');
        return; // Salir de la función
      }
    } catch (e) {
      print("Error en la autenticación biométrica: $e");
    }

    if (authenticated) {
      print("Autenticación exitosa");
      Navigator.pushReplacementNamed(context, 'homeroute');
    } else {
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
              image: AssetImage('assets/fondo-gris-principal-dos.jpg'),
              fit: BoxFit.fill,
              alignment: Alignment(-1, 1.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.125,
                    child: Text(''),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    child: Text('Bienvenido',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.bold)),
                  ),
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
                      _authenticate(context);
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
                  const SizedBox(height: 30),
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
