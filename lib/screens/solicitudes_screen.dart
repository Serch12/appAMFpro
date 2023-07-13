import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class SolicitudesScreen extends StatelessWidget {
  const SolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background
          // Background(),
          // Home Body
          SingleChildScrollView(
            child: Column(
              children: [
                // Titulos
                PageTitle(),

                // Card Table
                CardTable(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
