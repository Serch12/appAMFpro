import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../services/services.dart';

class NavegadorBar extends StatefulWidget {
  final Function(int) currentIndex;

  const NavegadorBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _NavegadorBarState createState() => _NavegadorBarState();
}

class _NavegadorBarState extends State<NavegadorBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: CurvedNavigationBar(
          index: _index,
          height: 60.0,
          items: <Widget>[
            _buildIcon(LineIcons.home, 0),
            _buildIcon(LineIcons.folder, 1),
            _buildIcon(LineIcons.user, 2),
            _buildIcon(LineIcons.alternateSignOut, 3),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Color(0xFF6EBC44),
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int i) {
            if (i == 3) {
              // Si el índice es 3 (Cerrar Sesión), realiza la operación de cierre de sesión
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              authService.logout();
              // Navega a la pantalla de inicio de sesión
              Navigator.pushReplacementNamed(context, 'login');
            } else {
              // Si el índice no es 3, actualiza el índice y notifica al widget padre
              setState(() {
                _index = i;
                widget.currentIndex(i);
              });
            }
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(10),
      child: Icon(
        iconData,
        size: 30,
        color: _index == index ? Color(0xFF6EBC44) : Colors.black,
      ),
    );
  }
}
