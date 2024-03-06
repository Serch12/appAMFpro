import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationCodeScreen extends StatefulWidget {
  final dynamic value;
  final int codigo;
  const VerificationCodeScreen(
      {super.key, required this.value, required this.codigo});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  @override
  Widget build(BuildContext context) {
    // final info = widget.value['data'];
    // final correo = info['mail'];
    final nombre = widget.value['data']['nombre'] +
        ' ' +
        widget.value['data']['apellido_paterno'];
    return Scaffold(
      body: contenido(nombre: nombre, codigo: widget.codigo),
    );
  }
}

class contenido extends StatefulWidget {
  final String nombre;
  final int codigo;
  contenido({
    Key? key,
    required this.nombre,
    required this.codigo,
  }) : super(key: key);

  @override
  State<contenido> createState() => _contenidoState();
}

class _contenidoState extends State<contenido> {
  late TextEditingController pinesController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    pinesController = TextEditingController();
  }

  @override
  void dispose() {
    _isDisposed = true;
    // pinesController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back.jpg'), // Ruta de la imagen
              fit: BoxFit.cover,
              alignment: Alignment(-1,
                  1.0), // Opcional: ajusta la imagen al tamaño del contenedor
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 30),
                  const Image(
                    image: AssetImage('assets/logoblanco.png'),
                    width: 73,
                    height: 93,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      child: Text('HOLA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.bold))),
                  SizedBox(
                      child: Text('${widget.nombre}',
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.bold,
                              color: Colors.green))),
                  const SizedBox(height: 30),
                  const SizedBox(
                      // width: MediaQuery.of(context).size.width,//le decimmos que ocupe todo el ancho
                      child: Text(
                    'PARA CONTINUAR INGRESA EL CÓDIGO ENVIADO A TU CORREO',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  const SizedBox(height: 30),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: PinCodeTextField(
                        keyboardType: TextInputType.number,
                        appContext: context,
                        controller: pinesController,
                        length: 6,
                        cursorHeight: 19,
                        enableActiveFill: true,
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          inactiveColor: const Color(
                              0xFF4FC028), //color del borde inactivo
                          selectedColor: const Color(
                              0xFF4FC028), //color de border de casilla seleccionada
                          activeFillColor:
                              Colors.transparent, // color de casilla llena
                          selectedFillColor: const Color(
                              0xFF4FC028), //color de casilla seleccionada
                          inactiveFillColor:
                              Colors.white, //color de casilla sin seleccionar

                          borderWidth: 1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onChanged: ((value) {
                          if (_isDisposed) return;
                          if (value.length == 6) {
                            if (int.tryParse(value) == widget.codigo) {
                              Navigator.pushReplacementNamed(context, 'login');
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // No permite cerrar la alerta al tocar fuera de ella
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.cancel,
                                              color: Colors
                                                  .red), // Icono a la izquierda del texto
                                          const SizedBox(
                                              width:
                                                  10.0), // Espacio entre el icono y el texto
                                          const Flexible(
                                            child: Text(
                                              'El código ingresado no es correcto.',
                                              style: TextStyle(
                                                  color: Color(0xFF1AD598)),
                                              overflow: TextOverflow.visible,
                                              softWrap:
                                                  false, // Permite que el texto se desborde
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Cerrar la alerta al presionar el botón
                                                pinesController.text = "";
                                              },
                                              child: const Icon(
                                                Icons.clear,
                                                color: Colors.black,
                                              )),
                                        ],
                                      ),

                                      contentPadding: const EdgeInsets.fromLTRB(
                                          15.0,
                                          10.0,
                                          0.0,
                                          0.0), // Ajustar el padding del contenido
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Ajustar el radio del borde
                                      ),
                                      actions: [],
                                    );
                                  });
                            }
                          }
                          setState(() {});
                        }),
                      )),
                  const SizedBox(height: 30),
                  Visibility(
                    visible: true,
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, 'verification_code_screen'),
                      child: Text(
                        'Validar código',
                        style: TextStyle(
                          color: Colors.white, // Color del texto del botón
                          fontSize:
                              18.0, // Tamaño de fuente del texto del botón
                        ),
                      ),
                      // child: const Text('Enviar código de verificacón.',
                      //     style: TextStyle(color: Colors.green, fontSize: 14)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.24,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ), // Espaciado interno del botón
                        backgroundColor:
                            Colors.green, // Color de fondo del botón
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Borde redondeado
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
