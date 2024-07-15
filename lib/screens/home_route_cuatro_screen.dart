import 'package:flutter/material.dart';
import 'package:splash_animated/routes/routes.dart';
import 'package:splash_animated/widgets/widgets.dart';

class HomeRouteCuatroScreen extends StatefulWidget {
  const HomeRouteCuatroScreen({Key? key}) : super(key: key);

  @override
  State<HomeRouteCuatroScreen> createState() => _HomeRouteCuatroScreenState();
}

class _HomeRouteCuatroScreenState extends State<HomeRouteCuatroScreen> {
  int index = 1;
  late NavegadorBar myButtonMain; // Cambiado a late

  @override
  void initState() {
    myButtonMain = NavegadorBar(
      currentIndex: (i) {
        setState(() {
          index = i;
        });
      },
      initialIndex: index, // Establece el índice inicial aquí
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Routes(index: index),
      bottomNavigationBar: myButtonMain,
    );
  }
}
