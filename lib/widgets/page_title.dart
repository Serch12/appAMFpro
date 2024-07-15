import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Selecciona una opción',
            //     style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.black)),
            SizedBox(height: 10),
            // Text('Clasificado por tipo de solicitudes                   ',
            //     style: TextStyle(fontSize: 16, color: Colors.black45)),
          ],
        ),
      ),
    );
  }
}
