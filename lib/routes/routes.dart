import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [
      const HomeScreen(),
      const SolicitudesScreen(),
      const ProfileScreen(),
      const Solicitudes2Screen(),
      const ContratoScreen()
    ];
    return myList[index];
  }
}
