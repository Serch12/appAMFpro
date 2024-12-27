import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/utils/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({super.key});

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  final String _urlBase = 'test-intranet.amfpro.mx';
  // dynamic jugador = [];
  int? aprobado;
  Timer? _timer; // Declaro el Timer como una variable
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool isLoading = true;

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

  Future<int?> obtenerDatosDeAPI(String correo) async {
    final url = Uri.http(_urlBase, '/api/datos-afiliados/correo/$correo');
    try {
      final respuesta = await http.get(url);
      if (respuesta.statusCode == 200) {
        final data = json.decode(respuesta.body);
        final aprobacion = data['data']['aprobacion_app'];
        print("Esto es aprobado: $aprobacion");
        return aprobacion;
      } else {
        print("Error en la API: ${respuesta.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error al obtener datos de la API: $e");
      return null;
    }
  }

  Future<void> verificarAutenticacion(AuthService authService) async {
    print("Verificando autenticación...");
    final snapshotData = await authService.autenticacion();

    if (snapshotData == '' || snapshotData.isEmpty) {
      // Si no hay datos, navegar a AnimatedScreen

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => AnimatedScreen(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else {
      // Si hay datos, obtener correo y llamar a la API
      final data = jsonDecode(snapshotData);
      final correo = data['correo'];
      final aprobacion = await obtenerDatosDeAPI(correo);

      // if (aprobacion != null) {
      if (mounted) {
        setState(() {
          aprobado = aprobacion;
          isLoading = false; // Validación finalizada
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Llamar a la verificación de autenticación en initState
    final authService = Provider.of<AuthService>(context, listen: false);

    // Ejecutar una verificación inicial
    verificarAutenticacion(authService);
    startTimer(authService);
  }

  void startTimer(AuthService authService) {
    // Llamar a la verificación de autenticación en initState
    // final authService = Provider.of<AuthService>(context, listen: false);
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        verificarAutenticacion(authService);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    print("Disposing CheckAuthScreen...");
    _timer?.cancel(); // Cancelar el Timer para evitar memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(), // Indicador de carga
              )
            : aprobado == 1 || aprobado == null
                ? FractionallySizedBox(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/fondo-gris-principal-dos.jpg'),
                          fit: BoxFit.fill,
                          alignment: Alignment(-1, 1.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.height * 0.25,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.125,
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
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.09,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02,
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
                  )
                : aprobado == 2
                    ? Center(
                        child: Stack(
                          alignment: Alignment
                              .center, // Centra el contenido superpuesto
                          children: [
                            Image.asset(
                                'assets/validacioninfotwo.gif'), // GIF de fondo
                            Positioned(
                              top: MediaQuery.of(context).size.height *
                                  0.315, // Ajusta este valor
                              child: ElevatedButton(
                                child: Text(
                                  'Llamar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  const phoneNumber =
                                      'tel:7286906040'; // Reemplaza con tu número
                                  if (await canLaunch(phoneNumber)) {
                                    await launch(phoneNumber);
                                  } else {
                                    // Maneja el error si no puede abrir el marcador
                                    print('No se pudo realizar la llamada');
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.09,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.015,
                                  ),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(child: Image.asset('assets/validacioninfo.gif')));
  }
}
