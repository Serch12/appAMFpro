import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class CircularDosStepper extends StatefulWidget {
  final Function(String) onStepChanged;
  CircularDosStepper({required this.onStepChanged});
  @override
  _CircularStepperState createState() => _CircularStepperState();
}

class _CircularStepperState extends State<CircularDosStepper>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  final int totalSteps = 3;
  late AnimationController _controller;
  late Animation<double> _animation;
  List<List<ui.Image>> stepImages = []; // Initialize with an empty list
  List<String> texts = ['Jugador', 'Partido', 'Entrenamiento'];
  late ui.Image placeholderImage;
  List<List<String>> imagePaths = [
    ['assets/RN2.png', 'assets/R2.png'],
    ['assets/RN3.png', 'assets/R3.png'],
    ['assets/RN1.png', 'assets/R1.png'],
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _loadImages();
  }

  void _loadImages() async {
    List<Future<List<ui.Image>>> imageFutures = imagePaths.map((paths) async {
      List<Future<ui.Image>> futures = paths.map(_loadImage).toList();
      return Future.wait(futures);
    }).toList();
    stepImages = await Future.wait(imageFutures);
    setState(() {});
  }

  Future<ui.Image> _loadImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  void _nextStep() {
    setState(() {
      // Move the first image to the end of the list
      stepImages.insert(0, stepImages.removeLast());

      currentStep = (currentStep + 1) % totalSteps;
      widget.onStepChanged(texts[currentStep]);
    });
    _controller.forward(from: 0);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      // Deslizar a la izquierda
      _nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stepImages.isEmpty || stepImages.length < totalSteps) {
      return CircularProgressIndicator(); // Show a loading indicator while images are loading
    }
    // return GestureDetector(
    //   onTap: _nextStep,
    //   child: CustomPaint(
    //     painter: CircularStepperPainter(
    //         currentStep, totalSteps, _animation, stepImages),
    //     size: Size(200, 200),
    //   ),
    // );

    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Column(
        children: [
          CustomPaint(
            painter: CircularStepperPainter(
                currentStep, totalSteps, _animation, stepImages),
            size: Size(200, 200),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            texts[currentStep],
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CircularStepperPainter extends CustomPainter {
  final int currentStep;
  final int totalSteps;
  final Animation<double> animation;
  final List<List<ui.Image>> stepImages;
  CircularStepperPainter(
      this.currentStep, this.totalSteps, this.animation, this.stepImages)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFF6EBC44)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final double radius = size.width / 1.5;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the dotted border circle (larger)
    final double outerRadius = radius + 7;
    paint
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();
    for (double i = 0; i < 360; i += 10) {
      path.addArc(Rect.fromCircle(center: center, radius: outerRadius),
          i * pi / 180, 5 * pi / 180);
    }
    canvas.drawPath(path, paint..color = Colors.green);

    // Draw the background circle
    paint
      ..color = Color(0xFF6EBC44)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    // Draw the progress arc
    paint.color = Color(0xFF6EBC44);
    final double sweepAngle = (2 * pi) / totalSteps;
    for (int i = 0; i < currentStep; i++) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          -pi / 2 + i * sweepAngle, sweepAngle, false, paint);
    }

    // Draw the transitioning arc
    paint.color = Color(0xFF6EBC44);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + currentStep * sweepAngle,
        sweepAngle * animation.value,
        false,
        paint);

    // Draw step indicators
    for (int i = 0; i < totalSteps; i++) {
      final double angle = -pi / 2 + i * sweepAngle;
      final double rotatedAngle = angle + (sweepAngle * animation.value);
      final double x = center.dx + radius * cos(rotatedAngle);
      final double y = center.dy + radius * sin(rotatedAngle);
      // final ui.Image image = stepImages[i];
      final List<ui.Image> images = stepImages[i];
      final double imageWidth = i == 2 ? 185 : 140;
      final double imageHeight = i == 2 ? 185 : 140;

      // Draw each image for this step
      if (i == 2) {
        paintImage(
          canvas: canvas,
          image: images[1],
          rect: Rect.fromLTWH(
              x - imageWidth / 2, y - imageHeight / 2, imageWidth, imageHeight),
          fit: BoxFit.cover,
        );
      } else {
        paintImage(
          canvas: canvas,
          image: images[0],
          rect: Rect.fromLTWH(
              x - imageWidth / 2, y - imageHeight / 2, imageWidth, imageHeight),
          fit: BoxFit.cover,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
