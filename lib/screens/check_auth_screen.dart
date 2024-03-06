import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:splash_animated/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.autenticacion(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return Text('Cargando...');
            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => AnimatedScreen(),
                        transitionDuration: Duration(seconds: 0)));
                // Navigator.of(context).pushReplacementNamed('login');
              });
            } else {
              // Future.microtask(() {
              //   Navigator.pushReplacement(
              //       context,
              //       PageRouteBuilder(
              //           pageBuilder: (_, __, ___) => HomeRouteScreen(),
              //           transitionDuration: Duration(seconds: 0)));
              //   // Navigator.of(context).pushReplacementNamed('login');
              // });
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LoginBiometricsScreen(),
                        transitionDuration: Duration(seconds: 0)));
                // Navigator.of(context).pushReplacementNamed('login');
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
