import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MyAppBar extends StatefulWidget {
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Acción al tocar el icono de campana o el contador
      },
      child: Stack(
        children: [
          IconButton(
            icon: Icon(LineIcons.bell),
            onPressed: () {
              // Al presionar el icono, muestra el menú desplegable
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width *
                      0.4, // 40% desde la izquierda
                  MediaQuery.of(context).size.height * 0.11, // 45% desde arriba
                  0,
                  0,
                ),
                color: Color(0xFFF3F3F3),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
                items: [
                  PopupMenuItem(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Jurido AMFpro",
                              style:
                                  TextStyle(fontFamily: 'Roboto', fontSize: 10),
                            ),
                            Text(
                              "ahora",
                              style:
                                  TextStyle(fontFamily: 'Roboto', fontSize: 10),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              LineIcons.recordVinyl,
                              color: Colors.black,
                              size: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Documentos faltantes",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Descripcion de la notificación para mostrar y que lleve a la sercción indicada",
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 12),
                        )
                      ],
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Jurido AMFpro",
                              style:
                                  TextStyle(fontFamily: 'Roboto', fontSize: 10),
                            ),
                            Text(
                              "04/04/2024",
                              style:
                                  TextStyle(fontFamily: 'Roboto', fontSize: 10),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              LineIcons.recordVinyl,
                              color: Colors.black,
                              size: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Seguimiento de audencia",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Descripcion de la notificación para mostrar y que lleve a la sercción indicada",
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 12),
                        )
                      ],
                    ),
                    value: 2,
                  ),
                ],
              );
            },
          ),
          Positioned(
            right: 10.5,
            top: 1,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum IconLabel {
  smile('Smile', Icons.sentiment_satisfied_outlined),
  cloud(
    'Cloud',
    Icons.cloud_outlined,
  ),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}
