import 'package:get/get.dart';
import 'package:splash_animated/providers/push_notifications_provider.dart';
import 'package:splash_animated/providers/twitter_provider.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/screens/verification_code_password_screen.dart';
import 'package:splash_animated/screens/verification_code_screen.dart';
// import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/utils/auth.dart';
import 'package:splash_animated/src/services/afiliados_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'models/notificaciones_model.dart';

final GlobalKey<NavigatorState> llavenavegador =
    new GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('====== On Launch seguro======');

    llavenavegador.currentState?.pushNamed('homeroutetres');
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => NotificacionesProvider()), // Agrega esta línea
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _textFieldFocusNode = FocusNode();
  final pushProvider = new NotificacionesPush();

  @override
  void initState() {
    super.initState();
    pushProvider.initNotifications();
    pushProvider.mensajes.listen((argumentos) {
      print(argumentos);
      if (mounted) {
        final provider =
            Provider.of<NotificacionesProvider>(context, listen: false);
        provider
            .actualizarNumeroNotificaciones(provider.numeroNotificaciones + 1);
        final nuevaNotificacion = Notificacion(
            titulo: argumentos.mensaje == "Se creo un término en tu solicitud."
                ? 'Término'
                : argumentos.mensaje == "Se creo una audiencia en tu solicitud."
                    ? 'Audiencia'
                    : argumentos.mensaje == "Se creo un pago en tu solicitud."
                        ? 'Pago'
                        : 'Solicitud afiliado',
            descripcion: "${argumentos.mensaje}",
            fecha: DateTime.now(),
            no_solicitud: argumentos.noSolicitud,
            nombre: argumentos.nombre,
            id_sol: argumentos.id_sol,
            division: argumentos.division,
            club: argumentos.club,
            nui: argumentos.nui,
            tramite: argumentos.tramite,
            observaciones: argumentos.observaciones,
            fechaSol: argumentos.fechaSol,
            estatus: argumentos.estatus);
        provider.agregarNotificacion(nuevaNotificacion);
        // Get.toNamed('lista_solicitudes');
      }
    });
    // Oculta el teclado cuando se carga el screen
    _textFieldFocusNode.unfocus();
  }

  @override
  void dispose() {
    // Asegúrate de eliminar el focus node cuando el widget se descarte
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AfiliadosService(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => MyProvider(),
        ),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (_) => TwitterProvider(),
          lazy: true,
        )
      ],
      child: GetMaterialApp(
        // Aquí agregamos las localizaciones específicas de Material para español
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es', 'ES'), // Español
        ],
        debugShowCheckedModeBanner: false,
        navigatorKey: llavenavegador,
        title: 'Material App',
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: 'checkauth',
        routes: {
          'circular': (_) => CircularStepperDemo(),
          'detalle_lesiones': (_) => DetalleLesionesScreen(id_afiliado: 0),
          'login': (_) => LoginScreen(),
          'biometricos': (_) => LoginBiometricsScreen(),
          'home': (_) => HomeScreen(),
          'homeroute': (_) => HomeRouteScreen(),
          'homeroutedos': (_) => HomeRouteDosScreen(),
          'homeroutetres': (_) => HomeRouteTresScreen(),
          'homeroutecuatro': (_) => HomeRouteCuatroScreen(),
          'register': (_) => RegisterScreen(),
          'checkauth': (_) => CheckAuthScreen(),
          'profile': (_) => ProfileScreen(),
          'registro_afiliado': (_) => RegistroAfiliadoScreen(),
          'recuperar_password': (_) => recuperarPasswordScreen(),
          'new_password': (_) => newPasswordScreen(),
          'lista_solicitudes': (_) => ListaSolicitudesScreen(),
          'lista_contratos': (_) => ListaContratosScreen(),
          'lista_notificaciones': (_) => listaNotificacionesScreen(),
          'contrato': (_) => ContratoScreen(),
          'informacion_solicitud': (_) => Solicitudes2Screen(value: []),
          'verification_code_password': (_) =>
              VerificationCodePasswordScreen(codigo: 0, correo: ''),
          'audiencia': (_) => AudienciaScreen(audiencia: {}),
          'terminos': (_) => TerminosScreen(termino: {}),
          'pagos': (_) => PagosScreen(pagos: {}),
          'detalle_post': (_) => detallePostScreen(value: {}),
          'edita_perfil': (_) => editProfileScreen(
              id: '',
              nombre: '',
              apellidoPaterno: '',
              apellidoMaterno: '',
              nacimiento: '',
              curp: '',
              sexo: '',
              escolaridad: '',
              nacionalidad: '',
              calle: '',
              colonia: '',
              estado: '',
              ciudad: '',
              cp: '',
              division: '',
              club: '',
              posicion: '',
              apodo: '',
              estatus: '',
              celular: '',
              telCasa: ''),
          'foto_perfil': (_) => fotoPerfilScreen(id: '', nui: '', foto: ''),
          'foto_anverso': (_) => fotoAnversoScreen(id: '', nui: '', pdf: ''),
          'foto_reverso': (_) => fotoReversoScreen(id: '', nui: '', pdf2: ''),
          'solicitudes_filtro': (_) =>
              SolicitudesFiltroScreen(listado: [], id_afiliado: ''),
          'nueva_solicitud': (_) => nuevaSolicitudScreen(
              id_afiliado2: 0, nombre2: '', ap2: '', am2: '', nui2: 0)

          // 'register' : (_) => const RegisterScreen()
        },
        // theme: AppTheme.lightTheme,
      ),
    );
  }
}

class NotificacionesProvider with ChangeNotifier {
  int _numeroNotificaciones = 0;
  List<Notificacion> _notificaciones = [];
  int get numeroNotificaciones => _numeroNotificaciones;
  List<Notificacion> get notificaciones => _notificaciones;

  void actualizarNumeroNotificaciones(int nuevoNumero) {
    _numeroNotificaciones = nuevoNumero;
    notifyListeners();
  }

  void agregarNotificacion(Notificacion notificacion) {
    _notificaciones.add(notificacion);
    _numeroNotificaciones = _notificaciones.length;
    notifyListeners();
  }

  void eliminarNotificacion(Notificacion notificacion) {
    _notificaciones.remove(notificacion);
    _numeroNotificaciones = _notificaciones.length;
    notifyListeners();
  }

  void limpiarNotificaciones() {
    _notificaciones.clear();
    _numeroNotificaciones = 0;
    notifyListeners();
  }
}

class NotificacionDatos {
  final String mensaje;
  final int id_sol;
  final String noSolicitud;
  final String nombre;
  final String division;
  final String club;
  final int nui;
  final String tramite;
  final String observaciones;
  final DateTime fechaSol;
  final int estatus;

  NotificacionDatos({
    required this.mensaje,
    required this.noSolicitud,
    required this.nombre,
    required this.id_sol,
    required this.division,
    required this.club,
    required this.nui,
    required this.tramite,
    required this.observaciones,
    required this.fechaSol,
    required this.estatus,
  });
}
