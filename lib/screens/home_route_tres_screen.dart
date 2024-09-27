import 'package:flutter/material.dart';
import 'package:splash_animated/routes/routes.dart';
import 'package:splash_animated/widgets/widgets.dart';

class HomeRouteTresScreen extends StatefulWidget {
  const HomeRouteTresScreen({Key? key}) : super(key: key);

  @override
  State<HomeRouteTresScreen> createState() => _HomeRouteTresScreenState();
}

class _HomeRouteTresScreenState extends State<HomeRouteTresScreen> {
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
