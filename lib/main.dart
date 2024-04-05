import 'package:get/get.dart';
import 'package:splash_animated/providers/twitter_provider.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/screens/verification_code_password_screen.dart';
import 'package:splash_animated/screens/verification_code_screen.dart';
import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/src/services/afiliados_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
          lazy: false,
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
        title: 'Material App',
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: 'checkauth',
        routes: {
          'inicio_nui_screen': (_) => const InicioNuiScreen(),
          'animated_screen': (_) => const AnimatedScreen(),
          'basic_desing': (_) => const BasicDesingScreen(),
          'verification_code_screen': (_) =>
              const VerificationCodeScreen(value: [], codigo: 0),
          'login': (_) => LoginScreen(),
          'biometricos': (_) => LoginBiometricsScreen(),
          'home': (_) => HomeScreen(),
          'homeroute': (_) => HomeRouteScreen(),
          'homeroutedos': (_) => HomeRouteDosScreen(),
          'register': (_) => RegisterScreen(),
          'checkauth': (_) => CheckAuthScreen(),
          'profile': (_) => ProfileScreen(),
          'registro_afiliado': (_) => RegistroAfiliadoScreen(),
          'recuperar_password': (_) => recuperarPasswordScreen(),
          'new_password': (_) => newPasswordScreen(),
          'lista_solicitudes': (_) => ListaSolicitudesScreen(),
          'lista_contratos': (_) => ListaContratosScreen(),
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
          'foto_reverso': (_) => fotoReversoScreen(id: '', nui: '', pdf2: '')

          // 'register' : (_) => const RegisterScreen()
        },
        // theme: AppTheme.lightTheme,
      ),
    );
  }
}
