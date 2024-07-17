import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("entramos a rutas");
    print(index);
    List<Widget> myList = [
      HomeScreen(),
      CircularStepperDemo(),
      ListaSolicitudesScreen(),

      ProfileScreen(),
      // SolicitudesScreen(),
      // const Solicitudes2Screen(),
      // const ContratoScreen()
    ];
    return myList[index];
  }
}
