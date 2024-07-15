import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:splash_animated/utils/auth.dart';
import '../screens/screens.dart';

class NavegadorBar extends StatefulWidget {
  final Function(int) currentIndex;
  final initialIndex; // Nuevo atributo para el índice inicial

  const NavegadorBar({
    Key? key,
    required this.currentIndex,
    this.initialIndex, // Valor por defecto para el índice inicial
  }) : super(key: key);

  @override
  _NavegadorBarState createState() => _NavegadorBarState();
}

class _NavegadorBarState extends State<NavegadorBar> {
  late int _index; // Cambiado a late

  @override
  void initState() {
    _index = widget.initialIndex; // Establece el índice inicial
    super.initState();
  }

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
          index: _index, // Establece el índice inicial aquí
          height: MediaQuery.of(context).size.height * 0.07,
          items: <Widget>[
            _buildIcon(LineIcons.home, 0),
            _buildIcon(LineIcons.running, 1),
            _buildIcon(LineIcons.folder, 2),
            _buildIcon(LineIcons.user, 3),
            _buildIcon(LineIcons.alternateSignOut, 4),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Color(0xFF6EBC44),
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int i) {
            if (i == 4) {
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            } else {
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
