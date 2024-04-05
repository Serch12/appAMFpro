import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(index);
    List<Widget> myList = [
      HomeScreen(),
      SolicitudesScreen(),
      ProfileScreen(),
      // const Solicitudes2Screen(),
      // const ContratoScreen()
    ];
    return myList[index];
  }
}
