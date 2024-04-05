import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:splash_animated/screens/appbar_screen.dart';
import 'package:splash_animated/screens/screens.dart';

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
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height *
              0.07, // Ajusta el alto del AppBar según el tamaño de la pantalla
          centerTitle: true,
          flexibleSpace: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.03), // Espacio para bajar la imagen
                Image.asset(
                  'assets/logoblanco.png',
                  // width: MediaQuery.of(context).size.width * 0.07,
                  height: MediaQuery.of(context).size.height * 0.04,
                )
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6EBC44),
                  Color(0xFF000000),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          actions: [
            Padding(padding: EdgeInsets.only(right: 10.0), child: MyAppBar()),
          ]),
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

