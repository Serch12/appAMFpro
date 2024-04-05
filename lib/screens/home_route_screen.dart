import 'package:flutter/material.dart';
import 'package:splash_animated/routes/routes.dart';
import 'package:splash_animated/widgets/widgets.dart';

class HomeRouteScreen extends StatefulWidget {
  const HomeRouteScreen({Key? key}) : super(key: key);

  @override
  State<HomeRouteScreen> createState() => _HomeRouteScreenState();
}

class _HomeRouteScreenState extends State<HomeRouteScreen> {
  int index = 0;
  late NavegadorBar myButtonMain;

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
      // appBar: AppBar(
      //     backgroundColor: Color(0xFF211A46),
      //     // title: Image.asset(
      //     //   'assets/logo3.png',
      //     //   width: 80,
      //     //   height: 50,
      //     // ),
      //     automaticallyImplyLeading: false,
      //     title: Center(
      //       child: Text(
      //         '',
      //         style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
      //       ),
      //     ),
      //     actions: [
      //       Padding(
      //         padding: EdgeInsets.only(right: 20.0),
      //         child: IconButton(
      //           onPressed: () {
      //             Navigator.pushReplacementNamed(context, 'homeroute');
      //           },
      //           icon: Image.asset('assets/logoblanco.png'),
      //         ),
      //       ),
      //     ]),
      body: Routes(index: index),
      bottomNavigationBar: myButtonMain,
    );
  }
}
