import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';

import '../widgets/widgets.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  String controller6 = "assets/Solicitudes-icono-tipo.gif";
  String controller7 = "assets/Contratos-icono-tipo.gif";

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
              child: Image.asset(
                "assets/Solicitudes-icono-tipo.gif",
                key: UniqueKey(), // Clave única para el primer GIF
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
              child: Image.asset(
                "assets/Contratos-icono-tipo.gif",
                key: UniqueKey(), // Clave única para el segundo GIF
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

