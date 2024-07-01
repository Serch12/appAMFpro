import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splash_animated/screens/screens.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';

import 'appbar_screen.dart';

class DetalleLesionesScreen extends StatefulWidget {
  final int id_afiliado;
  DetalleLesionesScreen({super.key, required this.id_afiliado});

  @override
  State<DetalleLesionesScreen> createState() => _DetalleLesionesScreenState();
}

class _DetalleLesionesScreenState extends State<DetalleLesionesScreen> {
  late String _urlBase = 'test-intranet.amfpro.mx';
  late List<Map<String, dynamic>> lista = [];
  bool mostrareditar = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _descripcionController;
  String? _eventoController;
  String selectedInjury = ''; // Store the selected injury
  bool mostrar = false;
  String? lesion;
  String? _lesion_registrada;
  int? _editar_id_seguimiento;
  List<dynamic> datoslesion = [];
  Map<String, List<_SalesData>> dataMap = {};
  List<Map<String, dynamic>> anosList = [];

  // List<_SalesData> data = [
  //   _SalesData('Semestre 1', 0),
  //   _SalesData('Semestre 2', 3),
  // ];

  // List<_SalesData> data2 = [
  //   _SalesData('Semestre 1', 4),
  //   _SalesData('Semestre 2', 0),
  // ];

  @override
  void initState() {
    super.initState();
    obtenerLesionesDeAPI();
    _dateController = TextEditingController();
    _descripcionController = TextEditingController();
    datosGrafica();
  }

  void datosGrafica() async {
    String apiUrl =
        'https://test-intranet.amfpro.mx/api/datos-grafica-lesiones';
    final response =
        await http.get(Uri.parse(apiUrl)).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      datoslesion = json.decode(response.body);

      // Inicializar listas vacías en el mapa
      for (int i = 0; i < datoslesion.length; i++) {
        var ano = datoslesion[i]['ano'];
        if (!dataMap.containsKey('data_$ano')) {
          dataMap['data_$ano'] = [];
          anosList.add({'ano': ano, 'data': dataMap['data_$ano']});
        }
      }
      for (var result in datoslesion) {
        dynamic ano = result['ano'];
        int cantidad = result['cantidad'];

        dataMap['data_$ano']!.add(_SalesData(result['semestre'], cantidad));
      }

      anosList.forEach((element) {
        print(element['data']);
        print(element['ano']);
        List<_SalesData> dataList = element['data'];
        dataList.forEach((data) {
          print('${data.semestre}: ${data.cantidad}');
        });
        print('');
      });
      setState(() {}); // Actualizar la UI
    } else {
      throw Exception('Error al cargar los equipos');
    }
  }

  void obtenerLesionesDeAPI() async {
    final url = Uri.http(_urlBase, '/api/lista_lesiones/${widget.id_afiliado}');
    final respuesta2 = await http.get(url);
    if (mounted) {
      setState(() {
        lista = List<Map<String, dynamic>>.from(json.decode(respuesta2.body));
      });
    }
  }

  void _showDeleteDialog(int id_seguimiento, String lesion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar "${lesion}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo actual
                _siAceptaEliminar(id_seguimiento);
              },
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _siAceptaEliminar(id_seguimiento) async {
    showDialog(
      context: context, // Usa el contexto del Builder
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    await Future.delayed(Duration(seconds: 3));
    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/eliminar-lesion-api/${id_seguimiento}');
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode == 404 || response.statusCode == 200) {
      showDialog(
        context: context, // Usa el contexto del Builder
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF1AD598)),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Lesión eliminada correctamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo de éxito
                    Navigator.pushReplacementNamed(context, 'homeroutecuatro');
                  },
                  child: Icon(Icons.clear, color: Colors.black),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: [],
          );
        },
      );
    } else {
      showDialog(
        context: context, // Usa el contexto del Builder
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Error al eliminar la lesión',
                    style: TextStyle(color: Colors.red),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo de error
                  },
                  child: Icon(Icons.clear, color: Colors.black),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: [],
          );
        },
      );
    }
  }

  void _onCheckboxChanged(String value) {
    setState(() {
      _lesion_registrada = value;

      if (value != 'Otro' && value != 'Lesion grave') {
        _descripcionController.text = '';
        mostrar = false;
      } else {
        mostrar = true;
      }

      if (selectedInjury == value) {
        selectedInjury = '';
      } else {
        selectedInjury = value;
      }
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int year = DateTime.now().year;

    int month = DateTime.now().month;
    DateTime thisMonth = DateTime(year, month, 0);
    DateTime nextMonth = DateTime(year, month + 1, 0);
    int totalDiasMesActual = nextMonth.difference(thisMonth).inDays;
    Set<dynamic?> diasEnLista = lista.map((item) => item['dia']).toSet();
    Set<dynamic?> lesionesEnLista = lista.map((item) => item['lesion']).toSet();
    List<dynamic> lesionesEnListaList = lesionesEnLista.toList();
    final Map<dynamic, dynamic> diaALesion =
        Map.fromIterables(diasEnLista, lesionesEnLista);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: mostrareditar == false
            ? AppBar(
                leading: IconButton(
                  onPressed: () {
                    // Acción al presionar el botón de retroceso
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white, // Color blanco para el icono
                  ),
                ),
                automaticallyImplyLeading: false,
                elevation: 0,
                toolbarHeight: MediaQuery.of(context).size.height *
                    0.07, // Ajusta el alto del AppBar según el tamaño de la pantalla
                centerTitle: true,
                flexibleSpace: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.03), // Espacio para bajar la imagen
                      Image.asset(
                        'assets/logoblanco.png',
                        // width: MediaQuery.of(context).size.width * 0.07,
                        height: MediaQuery.of(context).size.height * 0.04,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF6EBC44),
                        Color(0xFF000000),
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
                actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: MyAppBar()),
                  ])
            : AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                toolbarHeight: MediaQuery.of(context).size.height *
                    0.07, // Ajusta el alto del AppBar según el tamaño de la pantalla
                centerTitle: true,
                flexibleSpace: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.03), // Espacio para bajar la imagen
                      Image.asset(
                        'assets/logoblanco.png',
                        // width: MediaQuery.of(context).size.width * 0.07,
                        height: MediaQuery.of(context).size.height * 0.04,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF6EBC44),
                        Color(0xFF000000),
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
                actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: MyAppBar()),
                  ]),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: mostrareditar == false
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Seguimiento de lesiones',
                          style: TextStyle(
                              color: Color(0xFF979797),
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      Text('Insidentes registrados durante los partidos.',
                          style: TextStyle(
                              color: Color(0xFF979797),
                              fontFamily: 'Roboto',
                              fontSize: 12)),
                      Card(
                        color: Color(0xFFE8FFDC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Color(0xff3C3C3B),
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Historial',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 2.0, right: 2.0),
                                  child: Divider(
                                    color: Color(0xFFC0BBBB),
                                    height: 20,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Mes actual:',
                                          style: TextStyle(
                                              color: Color(0xff979797),
                                              fontFamily: 'Roboto',
                                              fontSize: 10),
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          "${lista.length}",
                                          style: TextStyle(
                                              color: Color(0xff979797),
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: List.generate(
                                          totalDiasMesActual, (i) {
                                        int dia = i + 1;
                                        bool isInList =
                                            diaALesion.containsKey(dia);
                                        Color iconColor =
                                            Color(0xffD9D9D9); // Default color

                                        if (isInList) {
                                          // Check specific conditions
                                          if (diaALesion[dia] ==
                                              'Lesion grave') {
                                            iconColor = Color(
                                                0xffFF0000); // Red for "Lesión grave"
                                          } else {
                                            iconColor = Color(
                                                0xff6EBC44); // Green for other injuries
                                          }
                                        }
                                        return Icon(
                                          Icons.brightness_1,
                                          color: iconColor,
                                          size: 11.0,
                                        );
                                      }),
                                    ),
                                    SizedBox(height: 15),
                                    for (var i = 0; i < lista.length; i++)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              lista[i]['lesion'] ==
                                                      "Lesiones de rodilla"
                                                  ? Image.asset(
                                                      'assets/rodillacolor.png',
                                                      width: 35)
                                                  : lista[i]['lesion'] ==
                                                          "Lesiones de hombro"
                                                      ? Image.asset(
                                                          'assets/esgincecolor.png',
                                                          width: 35)
                                                      : lista[i]['lesion'] ==
                                                              "Desgarres musculares"
                                                          ? Image.asset(
                                                              'assets/espaldacolor.png',
                                                              width: 35)
                                                          : lista[i]['lesion'] ==
                                                                  "Lesion grave"
                                                              ? Image.asset(
                                                                  'assets/rodillavendadacolor.png',
                                                                  width: 35)
                                                              : lista[i]['lesion'] ==
                                                                      "Otro"
                                                                  ? Image.asset(
                                                                      'assets/otrocolor.png',
                                                                      width: 35)
                                                                  : lista[i]['lesion'] ==
                                                                          "Esguince de tobillo"
                                                                      ? Image.asset(
                                                                          'assets/codocolor.png',
                                                                          width:
                                                                              35)
                                                                      : Text(''),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("${lista[i]['lesion']}"),
                                                  Text(
                                                    "${lista[i]['fecha_evento']}",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xff979797)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                padding: EdgeInsets
                                                    .zero, // Eliminate padding
                                                constraints:
                                                    BoxConstraints(), // Eliminate constraints
                                                icon: Image.asset(
                                                  'assets/editargris.png',
                                                  width: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    mostrareditar = true;
                                                    _eventoController =
                                                        lista[i]['tipo_evento'];
                                                    _dateController.text =
                                                        lista[i]
                                                            ['fecha_evento'];
                                                    _descripcionController
                                                        .text = lista[i][
                                                            'descripcion_lesion'] ??
                                                        '';
                                                    _editar_id_seguimiento =
                                                        lista[i]
                                                            ['id_seguimiento'];
                                                    _lesion_registrada =
                                                        lista[i]['lesion'];
                                                    _onCheckboxChanged(
                                                        lista[i]['lesion']);
                                                    // _edita_lesion =  lista[i]['lesion'];
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                padding: EdgeInsets
                                                    .zero, // Eliminate padding
                                                constraints:
                                                    BoxConstraints(), // Eliminate constraints
                                                icon: Image.asset(
                                                    'assets/eliminarbote.png',
                                                    width: 20),
                                                onPressed: () =>
                                                    _showDeleteDialog(
                                                        lista[i]
                                                            ['id_seguimiento'],
                                                        lista[i]['lesion']),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  child: Divider(
                                    color: Color(0xFFC0BBBB),
                                    height: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text('Historial de lesiones',
                          style: TextStyle(
                              color: Color(0xFF979797),
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      Text('Historial gráfico de lesiones registradas por año.',
                          style: TextStyle(
                              color: Color(0xFF979797),
                              fontFamily: 'Roboto',
                              fontSize: 12)),
                      Card(
                        color: Color(0xFFE8FFDC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),

                              // Chart title
                              // title: ChartTitle(
                              //     text: 'Half yearly sales analysis'),
                              // Enable legend
                              legend: Legend(isVisible: true),
                              // Enable tooltip
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <ChartSeries<_SalesData, String>>[
                                ...anosList.map((element) {
                                  return LineSeries<_SalesData, String>(
                                      markerSettings: MarkerSettings(
                                          isVisible: true,
                                          shape: DataMarkerType.circle,
                                          color: Colors.black,
                                          borderColor: Colors.black),
                                      dataSource: element['data'],
                                      xValueMapper: (_SalesData sales, _) =>
                                          sales.semestre,
                                      yValueMapper: (_SalesData sales, _) =>
                                          sales.cantidad,
                                      name:
                                          'Año ${element['ano']}', // Uso del año para el nombre de la serie
                                      // Enable data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true));
                                }).toList()
                              ]),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Seguimiento de lesiones',
                            style: TextStyle(
                                color: Color(0xFF979797),
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Text('Insidentes registrados durante los partidos.',
                            style: TextStyle(
                                color: Color(0xFF979797),
                                fontFamily: 'Roboto',
                                fontSize: 12)),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 15.0, left: 10, right: 10),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Lesión Registrada:",
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${_lesion_registrada}",
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          "Editar Lesión",
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 12),
                                        )
                                      ],
                                    )
                                  ]),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: _dateController,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          color: Color(0xFF060606)),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFECECEE),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 12.0),
                                      labelText: 'Fecha',
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _dateController.text = pickedDate
                                              .toString()
                                              .substring(0, 10);
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese la fecha';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  Material(
                                    elevation: 7.0,
                                    color: Colors.transparent,
                                    shadowColor:
                                        Color.fromARGB(255, 193, 192, 192)
                                            .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                    child: DropdownButtonFormField<String>(
                                      value: _eventoController,
                                      items: [
                                        DropdownMenuItem(
                                          value: 'SELECCIONAR',
                                          child: Text('SELECCIONAR',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14)),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Partido',
                                          child: Text('Partido',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14)),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Entrenamiento',
                                          child: Text('Entrenamiento',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14)),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _eventoController = value!;
                                          // _divisionPorSexo(value!);
                                          // _sexo = value;
                                          // _errorMessage = (_sexo == 'SELECCIONAR')
                                          //     ? 'Selecciona una opción'
                                          //     : null;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Acontecido en:',
                                        // errorText: _errorMessage,
                                        labelStyle: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFFECECEE),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025, // Ajusta el espaciado vertical según el ancho del dispositivo
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03, // Ajusta el espaciado horizontal según el ancho del dispositivo
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          ImageCheckbox(
                                            checkedImage: 'assets/codon.png',
                                            uncheckedImage: 'assets/codo.png',
                                            value: selectedInjury ==
                                                'Esguince de tobillo',
                                            onChanged: (value) =>
                                                _onCheckboxChanged(
                                                    'Esguince de tobillo'),
                                          ),
                                          Text(
                                            'Esguince de',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF979797)),
                                          ),
                                          Text('tobillo',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797)))
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        children: [
                                          ImageCheckbox(
                                            checkedImage: 'assets/rodillan.png',
                                            uncheckedImage:
                                                'assets/rodilla.png',
                                            value: selectedInjury ==
                                                'Lesiones de rodilla',
                                            onChanged: (value) =>
                                                _onCheckboxChanged(
                                                    'Lesiones de rodilla'),
                                          ),
                                          Text('Lesiones de',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797))),
                                          Text('rodilla',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797)))
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        children: [
                                          ImageCheckbox(
                                            checkedImage: 'assets/esgincen.png',
                                            uncheckedImage:
                                                'assets/esgince.png',
                                            value: selectedInjury ==
                                                'Lesiones de hombro',
                                            onChanged: (value) =>
                                                _onCheckboxChanged(
                                                    'Lesiones de hombro'),
                                          ),
                                          Text('Lesiones de',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797))),
                                          Text('hombro',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797)))
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        children: [
                                          ImageCheckbox(
                                            checkedImage: 'assets/espaldan.png',
                                            uncheckedImage:
                                                'assets/espalda.png',
                                            value: selectedInjury ==
                                                'Desgarres musculares',
                                            onChanged: (value) =>
                                                _onCheckboxChanged(
                                                    'Desgarres musculares'),
                                          ),
                                          Text('Desgarres',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797))),
                                          Text('musculares',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797)))
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        children: [
                                          ImageCheckbox(
                                            checkedImage:
                                                'assets/rodillavendadan.png',
                                            uncheckedImage:
                                                'assets/rodillavendadared.png',
                                            value: selectedInjury ==
                                                'Lesion grave',
                                            onChanged: (value) =>
                                                _onCheckboxChanged(
                                                    'Lesion grave'),
                                          ),
                                          Text('Lesión grave',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797))),
                                          Text('',
                                              style: TextStyle(fontSize: 10))
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        children: [
                                          ImageCheckbox(
                                            checkedImage: 'assets/otron.png',
                                            uncheckedImage: 'assets/otro.png',
                                            value: selectedInjury == 'Otro',
                                            onChanged: (value) =>
                                                _onCheckboxChanged('Otro'),
                                          ),
                                          Text('Otro',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF979797))),
                                          Text('',
                                              style: TextStyle(fontSize: 10))
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  mostrar == true
                                      ? TextFormField(
                                          controller: _descripcionController,
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 14,
                                                color: Color(0xFF060606)),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFFECECEE),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 12.0),
                                            labelText: 'Fecha',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor ingresa la descripción de la lesión';
                                            }
                                            return null;
                                          },
                                        )
                                      : Text(''),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 10,
                                          backgroundColor: Color(
                                              0XFFFF0000), // Color del botón Cancelar
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0), // Ajusta el radio del borde según sea necesario
                                          ),
                                        ),
                                        onPressed: () {
                                          mostrareditar = false;
                                          setState(() {
                                            mostrareditar = false;
                                          });
                                        },
                                        child: Text('Cancelar'),
                                      ),
                                      SizedBox(width: 16),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 10,
                                          backgroundColor: Color(0XFF6EBC44),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0), // Ajusta el radio del borde según sea necesario
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // Acciones de actualización
                                            _editarLesion();
                                          }
                                        },
                                        child: Text('Actualizar'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }

  Future<void> _editarLesion() async {
    // Mostrar el indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el usuario pueda cerrar el diálogo
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Indicador de carga circular
        );
      },
    );

    final url = Uri.parse(
        'https://test-intranet.amfpro.mx/api/edita-lesion-afiliados'); // Reemplaza con la URL de tu API de Laravel
    Map<String, dynamic> data = {
      "id_seguimiento": _editar_id_seguimiento,
      "fecha_evento": _dateController.text,
      "tipo_evento": _eventoController,
      "lesion": _lesion_registrada,
      "descripcion_lesion": _descripcionController.text
    };

// String jsonData = jsonEncode(data);

    final response = await http.post(url, body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    });

    Navigator.of(context).pop(); // Cerrar la alerta al presionar el botón

    if (response.statusCode == 404 || response.statusCode == 200) {
      showDialog(
        context: context, // Usa el contexto del Builder
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF1AD598)),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Lesión editada correctamente',
                    style: TextStyle(color: Color(0xFF1AD598)),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo de éxito
                    Navigator.pushReplacementNamed(context, 'homeroutecuatro');
                  },
                  child: Icon(Icons.clear, color: Colors.black),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: [],
          );
        },
      );
    } else {
      showDialog(
        context: context, // Usa el contexto del Builder
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Error al editar la lesión',
                    style: TextStyle(color: Colors.red),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo de error
                  },
                  child: Icon(Icons.clear, color: Colors.black),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: [],
          );
        },
      );
    }
    setState(() {});
  }
}

// class _SalesData {
//   _SalesData(this.year, this.sales);

//   final String year;
//   final double sales;
// }

class _SalesData {
  final String semestre;
  final int cantidad;

  _SalesData(this.semestre, this.cantidad);
}
