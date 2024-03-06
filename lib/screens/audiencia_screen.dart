import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AudienciaScreen extends StatefulWidget {
  final Map<String, dynamic> audiencia;
  const AudienciaScreen({super.key, required this.audiencia});

  @override
  State<AudienciaScreen> createState() => _AudienciaScreenState();
}

class _AudienciaScreenState extends State<AudienciaScreen> {
  String fechaFormateada = '';
  @override
  void initState() {
    super.initState();
    main();
  }

  void main() async {
    // Inicializa la información de localización antes de utilizar DateFormat
    await initializeDateFormatting('es');
  }

  @override
  Widget build(BuildContext context) {
    // Resto de tu código...
    String fechaStr = widget.audiencia['fecha'];
    DateTime fecha = DateTime.parse(fechaStr);

    // Utiliza un formateador para obtener la fecha en el formato deseado
    fechaFormateada = DateFormat('EEEE d MMMM y', 'es').format(fecha);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Audiencia',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.white, height: 6),
            ),
          ],
        ),
        backgroundColor: Color(0XFF6EBC44),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                // Acción al presionar el IconButton
              },
              icon: Image.asset('assets/logoblanco.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              color: Color(0XFF6EBC44),
              child: Center(),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.check_circle_rounded,
                          color: Colors.green, size: 30.0),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //   'Título del Card',
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            Text(
                              widget.audiencia['info'],
                              style: TextStyle(
                                color: Color(0xFF3C3C3B),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: Divider(
                                color: Color(0xFFC0BBBB),
                                height: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Alinea los elementos a los extremos
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month,
                                        color: Color(0xff3C3C3B), size: 20.0),
                                    SizedBox(
                                        width:
                                            5.0), // Espacio entre el ícono y el texto
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Color(0xff3C3C3B),
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${fechaFormateada}',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        color: Color(0xff3C3C3B), size: 20.0),
                                    SizedBox(
                                        width:
                                            8.0), // Espacio entre el ícono y el texto
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Color(0xff3C3C3B),
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.audiencia['hora'],
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
