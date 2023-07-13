import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class VerificationCodePasswordScreen extends StatefulWidget {
  final int codigo;
  final String correo;
  const VerificationCodePasswordScreen(
      {super.key, required this.codigo, required this.correo});

  @override
  State<VerificationCodePasswordScreen> createState() =>
      _VerificationCodePasswordScreenState();
}

class _VerificationCodePasswordScreenState
    extends State<VerificationCodePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: contenido2(codigo: widget.codigo, correo: widget.correo),
    );
  }
}

class contenido2 extends StatefulWidget {
  final int codigo;
  final String correo;
  contenido2({
    Key? key,
    required this.codigo,
    required this.correo,
  }) : super(key: key);

  @override
  State<contenido2> createState() => _contenidoState2();
}

class _contenidoState2 extends State<contenido2> {
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
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          toolbarHeight: 80.0,
          centerTitle: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Olvidaste tu contraseña?',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16.0, color: Colors.white, height: 6),
              ),
            ],
          ),
          backgroundColor: Color(0xFF211A46),
          // shape: ContinuousRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(80.0),
          //     bottomRight: Radius.circular(80.0),
          //   ),
          // ),
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
              Container(
                child: ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: 40,
                    width: 430,
                    color: Color(0xFF211A46),
                    child: Center(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                    size: 80.0,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 320,
                child: Center(
                  child: Text(
                      'Ingresa código de recuperación que se envio a ${widget.correo}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: 14, color: Color(0xFF060606))),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      inactiveColor:
                          const Color(0xFF211A46), //color del borde inactivo
                      selectedColor: const Color(
                          0xFF211A46), //color de border de casilla seleccionada
                      activeFillColor:
                          const Color(0xFF211A46), // color de casilla llena
                      selectedFillColor: const Color(
                          0xFF211A46), //color de casilla seleccionada
                      inactiveFillColor:
                          Colors.white, //color de casilla sin seleccionar
                      activeColor: Color(0xFF211A46),
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onChanged: ((value) {
                      if (_isDisposed) return;
                      if (value.length == 6) {
                        if (int.tryParse(value) == widget.codigo) {
                          Navigator.pushReplacementNamed(
                              context, 'new_password');
                        } else {
                          // pinesController.text = "";
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
              SizedBox(height: 310),
              Container(
                width: 320,
                child: Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, 'login'),
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.green.withOpacity(0.1)),
                        shape: MaterialStateProperty.all(StadiumBorder())),
                    child: Text('Regresa al inicio',
                        style: GoogleFonts.roboto(
                            fontSize: 16, color: Color(0xFF060606))),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
