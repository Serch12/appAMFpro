import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/screens.dart';

class CardTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          GestureDetector(
            onTap: () {
              //Cierra el cajón de navegación antes
              // Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, 'profile');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListaSolicitudesScreen()));
            },
            child: _SigleCard(
              // color: Colors.blue,
              // icon: Icons.border_all,
              text: 'Solicitudes',
              imagen: Image.asset('assets/solicitudes2.png'),
            ),
          ),
          GestureDetector(
            onTap: () {
              //Cierra el cajón de navegación antes
              // Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, 'profile');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListaContratosScreen()));
            },
            child: _SigleCard(
                // color: Colors.pinkAccent,
                // icon: Icons.car_rental,
                text: 'Contrato',
                imagen: Image.asset('assets/contratos2.png')),
          ),
          GestureDetector(
            onTap: () {
              //Cierra el cajón de navegación antes
              // Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, 'profile');
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const ContratoScreen()));
            },
            child: _SigleCard(
                // color: Colors.pinkAccent,
                // icon: Icons.car_rental,
                text: 'Título',
                imagen: Image.asset('assets/circulogris.png')),
          ),
        ]),
        TableRow(children: [
          GestureDetector(
            onTap: () {
              //Cierra el cajón de navegación antes
              // Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, 'profile');
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const ListaSolicitudesScreen()));
            },
            child: _SigleCard(
              // color: Colors.blue,
              // icon: Icons.border_all,
              text: 'Título',
              imagen: Image.asset('assets/circulogris.png'),
            ),
          ),
          GestureDetector(
            onTap: () {
              //Cierra el cajón de navegación antes
              // Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, 'profile');
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const ContratoScreen()));
            },
            child: _SigleCard(
                // color: Colors.pinkAccent,
                // icon: Icons.car_rental,
                text: 'Título',
                imagen: Image.asset('assets/circulogris.png')),
          ),
          GestureDetector(
            onTap: () {
              //Cierra el cajón de navegación antes
              // Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, 'profile');
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const ContratoScreen()));
            },
            child: _SigleCard(
                // color: Colors.pinkAccent,
                // icon: Icons.car_rental,
                text: 'Título',
                imagen: Image.asset('assets/circulogris.png')),
          ),
        ]),
        // TableRow(children: [
        //   _SigleCard(
        //       // color: Colors.purple,
        //       // icon: Icons.shop,
        //       text: 'Shopping',
        //       imagen: Image.asset('assets/contratos.png')),
        //   _SigleCard(
        //       // color: Colors.purpleAccent,
        //       // icon: Icons.cloud,
        //       text: 'Bill',
        //       imagen: Image.asset('assets/solicitud-afiliados.png')),
        // ]),
      ],
    );
  }
}

class _SigleCard extends StatelessWidget {
  const _SigleCard({
    Key? key,
    required this.text,
    required this.imagen,
  }) : super(key: key);

  final String text;
  final Image imagen;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Puedes ajustar el espaciado según tus necesidades
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          // Imagen
          Container(
            width: 90, // Ajusta el ancho según tus necesidades
            height: 90, // Ajusta la altura según tus necesidades
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0XFF636262), // Cambia el color según tus necesidades
            ),
            child: Center(
              child: imagen, // Aquí va tu imagen
            ),
          ),
          SizedBox(height: 8), // Espaciado entre la imagen y el texto
          // Texto
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _CardBackground extends StatelessWidget {
  final Widget child;

  const _CardBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
                color: Color(0XFF636262),
                borderRadius: BorderRadius.circular(90)),
            child: this.child,
          ),
        ),
      ),
    );
  }
}
