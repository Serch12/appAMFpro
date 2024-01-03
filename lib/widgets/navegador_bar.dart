import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class NavegadorBar extends StatefulWidget {
  final Function currentIndex;

  const NavegadorBar({super.key, required this.currentIndex});
  @override
  State<NavegadorBar> createState() => _NavegadorBarState();
}

class _NavegadorBarState extends State<NavegadorBar> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.grey.shade300,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF211A46),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: index,
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
              index = i;
              widget.currentIndex(i);
            });
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            label: 'Cerrar Sesión',
          ),
        ]);
  }
}
