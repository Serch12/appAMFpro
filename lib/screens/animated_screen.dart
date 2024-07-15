import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
  // late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // _scaleAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
    //   CurvedAnimation(
    //     parent: _animationController,
    //     curve: Curves.fastLinearToSlowEaseIn,
    //   ),
    // );

    _animationController.repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 6500), () {
      // _animationController.stop();
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType
                  .rightToLeft, // Tipo de transición (en este caso, desvanecimiento)
              child: InicioNuiScreen(),
              isIos: true));
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
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60.0), // Ajustar el espacio superior según sea necesario
              child: Container(
                width: 250, // Establecer el ancho deseado
                height: 250, // Establecer la altura deseada
                child:
                    Image.asset('assets/logo-amf.gif'), // Cambiar a Image.asset
              ),
            ),
          ),
        ),
      ),
    );
  }
}
