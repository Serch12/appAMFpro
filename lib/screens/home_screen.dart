import 'package:flutter/material.dart';
// import 'package:splash_animated/providers/twitter_provider.dart';
import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(context);
    // final twitterProvider = Provider.of<TwitterProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    // final mapeoFinal = twitterProvider.listadoPublicaciones;

    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 20,
        displacement: 50,
        strokeWidth: 2,
        color: Colors.green,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: _refresh,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: [
            // for (int i = 0; i < mapeoFinal.length; i++)
            //   CustomCardNoticia(publicacion: mapeoFinal[i]),
            // SizedBox(
            //   height: 10,
            // ),
          ],
        ),
      ),
    );
  }
}

Future<void> _refresh() async {
  print('hola mundo');
}
