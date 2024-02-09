import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';

import '../widgets/widgets.dart';
import 'package:flutter_gif/flutter_gif.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen>
    with TickerProviderStateMixin {
  late FlutterGifController controller6, controller7;

  @override
  void initState() {
    controller6 = FlutterGifController(vsync: this);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller6.repeat(
        min: 0,
        max: 99,
        period: const Duration(seconds: 4),
      );
    });
    controller7 = FlutterGifController(vsync: this);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller7.repeat(
        min: 0,
        max: 99,
        period: const Duration(seconds: 4),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    // Cerrar el AnimationController y cualquier otro objeto Ticker que estés utilizando
    controller6.dispose();
    controller7.dispose();
    // Resto de tu código de liberación...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ListaSolicitudesScreen()));
              },
              child: GifImage(
                controller: controller6,
                image: AssetImage("assets/Solicitudes-icono-tipo.gif"),
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.45,
              ),
            ),
            // SizedBox(height: 10), // Espacio entre los dos GIFs
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ListaContratosScreen()));
              },
              child:
                  // Image.asset(
                  //   'assets/Contratos-icono-tipo.gif', // Ruta del segundo GIF
                  //   width: MediaQuery.of(context).size.width * 0.45,
                  //   height: MediaQuery.of(context).size.width * 0.45,
                  // ),
                  GifImage(
                controller: controller7,
                image: AssetImage("assets/Contratos-icono-tipo.gif"),
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import '../widgets/widgets.dart';

// class SolicitudesScreen extends StatelessWidget {
//   const SolicitudesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Background
//           // Background(),
//           // Home Body
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Titulos
//                 PageTitle(),

//                 // Card Table
//                 CardTable(),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

