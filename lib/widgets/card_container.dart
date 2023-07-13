import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        // height: 300,
        decoration: _createCardLogin(),
        child: this.child,
      ),
    );
  }

  BoxDecoration _createCardLogin() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                // color: Color.fromARGB(255, 25, 116, 28),
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5))
          ]);
}
