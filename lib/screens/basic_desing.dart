import 'package:splash_animated/widgets/login_form.dart';
import 'package:flutter/material.dart';
// import '../widgets/widgets.dart';

class BasicDesingScreen extends StatelessWidget {
  const BasicDesingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      //permite dar un efecto al llegar abajo para android
      physics: BouncingScrollPhysics(),
      //permite dar scroll para abajo
      scrollDirection: Axis.vertical,
      children: const [InputsScreen()],
    ));
  }
}

class InputsScreen extends StatelessWidget {
  const InputsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> FormularioLoginKey = GlobalKey<FormState>();

    final Map<String, String> formValues = {
      // 'first_name': 'Emmanuel',
      // 'last_name': 'Damian',
      'email': 'edp12011995@gmail.com',
      'password': '123456789'
      // 'role' : 'Admin'
    };
    return Scaffold(
        appBar: AppBar(
          // title: const Text('Formularios'),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/logo.png'),
                width: 214,
                height: 134,
              ),
              SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, //le decimmos que ocupe todo el ancho
                  child: const Text('Acceder',
                      style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.bold))),
              SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, //le decimmos que ocupe todo el ancho
                  child: const Text(
                    'Ingresa tus datos correctamente',
                    style: TextStyle(fontSize: 14),
                  )),
              Form(
                key: FormularioLoginKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    CustomInputField(
                        labelText: 'Correo',
                        hintText: 'Correo del usuario',
                        keyboardType: TextInputType.emailAddress,
                        formProperty: 'email',
                        formValues: formValues,
                        suffixIcon: Icons.mail),
                    const SizedBox(height: 30),
                    CustomInputField(
                        labelText: 'Contraseña',
                        hintText: 'Contraseña del usuario',
                        isPassword: true,
                        formProperty: 'password',
                        formValues: formValues,
                        suffixIcon: Icons.key),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Recordar mis datos',
                            style: TextStyle(fontSize: 14)),
                        Text(
                          'Olvidaste contraseña?',
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (!FormularioLoginKey.currentState!.validate()) {
                            print('Formulario no valido');
                            return;
                          }
                          print(formValues);
                        },
                        child: const SizedBox(
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              'Entrar',
                              style: TextStyle(fontSize: 16),
                            )))),
                    const SizedBox(height: 50),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text(
                        '¿No tienes cuenta?',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextButton(
                        // onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
                        onPressed: () {
                          print('arroja a el registro');
                        },
                        child: const Text(
                          'Registrate',
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.indigo.withOpacity(0.1)),
                            shape: MaterialStateProperty.all(
                                const StadiumBorder())),
                      )
                    ])
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
