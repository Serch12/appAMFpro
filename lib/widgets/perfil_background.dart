import 'package:flutter/material.dart';

class PerfilBackground extends StatelessWidget {
  final Widget child;

  const PerfilBackground({super.key, required this.child});
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
      margin: EdgeInsets.only(top: 20),
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
      height: size.height * 0.35,
      decoration: _greenBackground(),
      child: Stack(
        children: [],
      ),
    );
  }

  BoxDecoration _greenBackground() => BoxDecoration(
          gradient: LinearGradient(colors: [
        // Color.fromARGB(255, 29, 113, 32),
        Colors.green.shade700,
        Colors.green.shade700,

        // Color.fromARGB(255, 43, 136, 47),
      ]));
}

class _Bubble extends StatelessWidget {
  const _Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 460,
      // height: 460,
      child: Image(
        image: AssetImage('assets/vec.png'),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(350),
          // color: Color.fromRGBO(200, 251, 213, 0.733)
          color: Color.fromARGB(0, 0, 0, 0)),
    );
  }
}
