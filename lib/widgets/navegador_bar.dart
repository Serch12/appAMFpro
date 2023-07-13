import 'package:flutter/material.dart';

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
        selectedItemColor: Colors.green.shade700,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: index,
        onTap: (int i) {
          setState(() {
            index = i;
            widget.currentIndex(i);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Perfil'),
        ]);
  }
}
