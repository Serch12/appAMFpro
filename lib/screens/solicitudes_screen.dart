import 'package:flutter/material.dart';
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
          backgroundColor: Color(0xFF211A46),
          // title: Image.asset(
          //   'assets/logo3.png',
          //   width: 80,
          //   height: 50,
          // ),
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              '',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'homeroute');
                },
                icon: Image.asset('assets/logoblanco.png'),
              ),
            ),
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

