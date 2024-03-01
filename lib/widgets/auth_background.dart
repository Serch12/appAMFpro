import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _GreenBox(),
          _LogoImage(),
          this.child,
        ],
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 80),
      // child: const Image(
      //   image: AssetImage('assets/logo.png'),
      //   width: 200,
      //   height: 134,
      // ),
    );
  }
}

class _GreenBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _greenBackground(),
      child: Stack(
        children: [
          // Positioned(child: _Bubble(), top: 90, left: 30),
          // Positioned(child: _Bubble(), top: -40, left: -30),
          // Positioned(child: _Bubble(), top: -50, left: -20),
          // Positioned(child: _Bubble(), bottom: -50, left: 10),
          Positioned(child: _Bubble(), bottom: 50, right: -110),
        ],
      ),
    );
  }

  BoxDecoration _greenBackground() => BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 29, 113, 32),
        Colors.green,

        // Color.fromARGB(255, 43, 136, 47),
      ]));
}

class _Bubble extends StatelessWidget {
  const _Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 460,
      height: 460,
      child: Image(
        image: AssetImage('assets/Foto.png'),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(350),
          // color: Color.fromRGBO(200, 251, 213, 0.733)
          color: Color.fromARGB(0, 0, 0, 0)),
    );
  }
}
