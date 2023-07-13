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
          backgroundColor: Colors.green.shade700,
          title: Image.asset(
            'assets/logo3.png',
            width: 80,
            height: 50,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  authService.logout();
                  Navigator.pushReplacementNamed(context, 'login');
                },
                icon: Icon(Icons.login_outlined)),
          ]),
      body: Routes(index: index),
      bottomNavigationBar: myButtonMain,
    );
  }
}
