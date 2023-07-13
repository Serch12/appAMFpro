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
                  builder: (context) => const Solicitudes2Screen()));
            },
            child: _SigleCard(
              // color: Colors.blue,
              // icon: Icons.border_all,
              text: 'Solicitudes',
              imagen: Image.asset('assets/solicitudes.png'),
            ),
          ),
          GestureDetector(
            onTap: () {
              //Cierra el cajón de navegación antes
              // Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, 'profile');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContratoScreen()));
            },
            child: _SigleCard(
                // color: Colors.pinkAccent,
                // icon: Icons.car_rental,
                text: 'Contrato',
                imagen: Image.asset('assets/cuentas-contables.png')),
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
  // final IconData icon;
  // final Color color;
  final String text;
  final Image imagen;

  const _SigleCard(
      {Key? key,
      // required this.icon,
      // required this.color,
      required this.text,
      required this.imagen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CardBackground(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Color.fromRGBO(62, 66, 107, 0),
          child: this.imagen,
          radius: 70,
        ),
        // SizedBox(height: 10),
        Text(
          this.text,
          // style: TextStyle(color: this.color, fontSize: 18),
          style: TextStyle(fontSize: 20),
        )
      ],
    ));
  }
}

class _CardBackground extends StatelessWidget {
  final Widget child;

  const _CardBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
                color: Color.fromRGBO(62, 66, 107, 0.205),
                borderRadius: BorderRadius.circular(20)),
            child: this.child,
          ),
        ),
      ),
    );
  }
}
