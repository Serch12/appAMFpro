import 'package:splash_animated/providers/twitter_provider.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/screens/verification_code_password_screen.dart';
import 'package:splash_animated/screens/verification_code_screen.dart';
import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/src/services/afiliados_services.dart';
// import 'package:amf_app/screens/register_screen.dart';
import 'package:splash_animated/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'checkauth',
        routes: {
          'inicio_nui_screen': (_) => const InicioNuiScreen(),
          'animated_screen': (_) => const AnimatedScreen(),
          'basic_desing': (_) => const BasicDesingScreen(),
          'verification_code_screen': (_) =>
              const VerificationCodeScreen(value: [], codigo: 0),
          'login': (_) => LoginScreen(),
          'home': (_) => HomeScreen(),
          'homeroute': (_) => HomeRouteScreen(),
          'register': (_) => RegisterScreen(),
          'checkauth': (_) => CheckAuthScreen(),
          'profile': (_) => ProfileScreen(),
          'registro_afiliado': (_) => RegistroAfiliadoScreen(),
          'recuperar_password': (_) => recuperarPasswordScreen(),
          'new_password': (_) => newPasswordScreen(),
          'verification_code_password': (_) =>
              VerificationCodePasswordScreen(codigo: 0, correo: '')
          // 'register' : (_) => const RegisterScreen()
        },
        // theme: AppTheme.lightTheme,
      ),
    );
  }
}
