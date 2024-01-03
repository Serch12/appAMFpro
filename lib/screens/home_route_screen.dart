import 'package:flutter/material.dart';
import 'package:splash_animated/routes/routes.dart';
import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeRouteScreen extends StatefulWidget {
  const HomeRouteScreen({super.key});

  @override
  State<HomeRouteScreen> createState() => _HomeRouteScreenState();
}

class _HomeRouteScreenState extends State<HomeRouteScreen> {
  int index = 0;
  NavegadorBar? myButtonMain;

  @override
  void initState() {
    myButtonMain = NavegadorBar(currentIndex: (i) {
      setState(() {
        index = i;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF211A46),
          // title: Image.asset(
          //   'assets/logo3.png',
          //   width: 80,
          //   height: 50,
          // ),
          title: Center(
            child: Text(
              '',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'homeroute');
                },
                icon: Image.asset('assets/logoblanco.png'),
              ),
            ),
          ]),
      body: Routes(index: index),
      bottomNavigationBar: myButtonMain,
    );
  }
}
