import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:splash_animated/services/services.dart';
import 'package:provider/provider.dart';
import 'package:accordion/accordion.dart';

import '../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final double coverHeight = 280;

  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight / 2;
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[];
        },
        body: ListView(padding: EdgeInsets.zero, shrinkWrap: true, children: [
          buildTop(
              coverHeight: coverHeight, top: top, profileHeight: profileHeight),
          buildContent(),
        ]),
      ),
    );
  }
}

class buildContent extends StatelessWidget {
  final List<String> entries = <String>[
    'Contraseña',
    'info.General',
    'Historial',
    'Datos deportivos'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Emmanuel Damian',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              'Flutter Software Enginner',
              style: TextStyle(fontSize: 18, height: 1),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // const Text(
          //   'Información',
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          ListView.builder(
            itemCount: entries.length,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => Card(
              elevation: 4,
              shadowColor: Colors.green,
              child: ListTile(
                title: Text(
                  '${entries[index]}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // subtitle: Text('Email $index'),
                trailing: const Icon(
                  Icons.arrow_forward,
                  color: Colors.green,
                ),
                onTap: () {
                  print('click');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class buildTop extends StatelessWidget {
  const buildTop({
    super.key,
    required this.coverHeight,
    required this.top,
    required this.profileHeight,
  });

  final double coverHeight;
  final double top;
  final double profileHeight;

  @override
  Widget build(BuildContext context) {
    final bottom = profileHeight / 2;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: bottom),
              child: buildCoverImage(coverHeight)),
          Positioned(top: top, child: buildProfileImage(profileHeight))
        ]);
  }
}

class buildCoverImage extends StatefulWidget {
  final double coverHeight;
  const buildCoverImage(this.coverHeight);

  @override
  State<buildCoverImage> createState() => _buildCoverImageState();
}

class _buildCoverImageState extends State<buildCoverImage> {
  // final double coverHeight = 280;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey,
      child: Image.asset(
        'assets/fondoverde2.jpg',
        width: double.infinity,
        height: widget.coverHeight,
        fit: BoxFit.cover,
      ),
    );
  }
}

class buildProfileImage extends StatelessWidget {
  final double profileHeight;
  const buildProfileImage(this.profileHeight);
  // final double profileHeight = 144;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: profileHeight / 2,
      // backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: profileHeight / 2 - 6,
        // backgroundColor: Colors.grey.shade800,
        backgroundImage: AssetImage('assets/usuarios.png'),
      ),
    );
  }
}
