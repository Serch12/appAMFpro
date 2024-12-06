import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:splash_animated/main.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:badges/badges.dart' as badges;

// import '../main.dart';

class MyAppBar extends StatefulWidget {
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificacionesProvider>(context);
    return GestureDetector(
      onTap: () {
        // Acción al tocar el icono de campana o el contador
      },
      child: Stack(
        children: [
          badges.Badge(
            badgeAnimation: badges.BadgeAnimation.size(),
            badgeContent: Text(
              '${provider.numeroNotificaciones.toString()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Icon(
              LineIcons.bell,
              color: Colors.white,
            ),
            onTap: () {
              if (provider.notificaciones.isNotEmpty) {
                // Al presionar el icono, muestra el menú desplegable
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width *
                        0.4, // 40% desde la izquierda
                    MediaQuery.of(context).size.height *
                        0.11, // 11% desde arriba
                    0,
                    0,
                  ),
                  color: Color(0xFFF3F3F3),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bordes redondeados
                  ),
                  items: provider.notificaciones.map((notificacion) {
                    return PopupMenuItem(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height:
                                    20, // Ajusta la altura según lo necesario
                                width: 20, // Ajusta el ancho si es necesario
                                child: IconButton(
                                  padding: EdgeInsets.all(
                                      0), // Quitar padding para que no tenga bordes extra
                                  constraints: BoxConstraints(),
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    provider.eliminarNotificacion(notificacion);
                                    Navigator.pop(context); // Cerrar el menú
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Solicitudes2Screen(value: {
                                          'no_solicitud':
                                              notificacion.no_solicitud,
                                          'nombre': notificacion.nombre,
                                          'division': notificacion.division,
                                          'club': notificacion.club,
                                          'nui': notificacion.nui,
                                          'tramite': notificacion.tramite,
                                          'observaciones':
                                              notificacion.observaciones,
                                          'tipo_solicitud':
                                              notificacion.tipo_solicitud,
                                          'observaciones_solicitud':
                                              notificacion
                                                  .observaciones_solicitud,
                                          'archivo_solicitud':
                                              notificacion.archivo_solicitud,
                                          'estatus': notificacion.estatus,
                                          'fecha': notificacion.fechaSol,
                                        }),
                                      ),
                                    );
                                    // Navigator.pushNamed(context,
                                    //     'homeroutetres'); // Navegar al listado de solicitudes
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notificacion.titulo,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${notificacion.fecha.hour}:${notificacion.fecha.minute}",
                                style: TextStyle(
                                    fontFamily: 'Roboto', fontSize: 10),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                LineIcons.recordVinyl,
                                color: Colors.black,
                                size: 10,
                              ),
                              SizedBox(width: 10),
                              Text(
                                notificacion.descripcion,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 5),
                          // Text(
                          //   notificacion.descripcion,
                          //   style: TextStyle(
                          //       fontFamily: 'Roboto',
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                      value: notificacion,
                    );
                  }).toList(),
                );
              } else {
                // Mostrar mensaje o no hacer nada si no hay notificaciones
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Center(child: Text('No hay notificaciones'))),
                );
              }
            },
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
