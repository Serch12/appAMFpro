import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash_animated/screens/screens.dart';

void main() => runApp(const AnimatedScreen());

class AnimatedScreen extends StatefulWidget {
  const AnimatedScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _animationController.repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 3000), () {
      // _animationController.stop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => InicioNuiScreen()));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        canvasColor: Colors.black, // Establecer el fondo negro
      ),
      home: Scaffold(
        backgroundColor: Colors.black, // Establecer el fondo negro
        body: Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 200, // Establecer el ancho deseado
                  height: 200, // Establecer la altura deseada
                  child: Image(image: AssetImage('assets/logoblanco.png')),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
