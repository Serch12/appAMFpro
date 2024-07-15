import 'package:flutter/material.dart';
import 'package:splash_animated/routes/routes.dart';
import 'package:splash_animated/widgets/widgets.dart';

class HomeRouteDosScreen extends StatefulWidget {
  const HomeRouteDosScreen({Key? key}) : super(key: key);

  @override
  State<HomeRouteDosScreen> createState() => _HomeRouteDosScreenState();
}

class _HomeRouteDosScreenState extends State<HomeRouteDosScreen> {
  int index = 3;
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
