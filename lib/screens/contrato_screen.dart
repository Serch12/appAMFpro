import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class ContratoScreen extends StatefulWidget {
  const ContratoScreen({super.key});

  @override
  State<ContratoScreen> createState() => _ContratoScreenState();
}

class _ContratoScreenState extends State<ContratoScreen> {
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
      body: Center(child: Text('Contratos Screen')),
    );
  }
}
