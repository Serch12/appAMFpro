import 'package:flutter/material.dart';
import 'package:splash_animated/providers/login_form_provider.dart';
import 'package:splash_animated/services/services.dart';
import 'package:splash_animated/ui/input_decoration.dart';
import 'package:splash_animated/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 270,
            ),
            CardContainer(
                child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 134,
                ),
                Text('Registrate',
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(), child: _LoginForm())
              ],
            )),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.green.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())),
              child: const Text(
                '¿Ya tienes una cuenta? Iniciar Sesión.',
                style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
          key: loginForm.keyFormLogin,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'example@gmail.com',
                    labelText: 'Correo electrónico',
                    prefixIcon: Icons.email_outlined),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no luce como un correo.';
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '******',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline_rounded),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  if (value != null && value.length >= 6) return null;
                  return 'La contraseña debe ser mayor o igual a 6 caracteres.';
                },
              ),
              SizedBox(height: 30),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.green,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Generando usuario ...' : 'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  //si loginform no ejecuta arroja null de lo contrario entra a la ejecucion
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          // ocultar el teclado
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          if (!loginForm.isValidForm()) return;
                          loginForm.isLoading = true;
                          //validar si el login es correcto
                          final String? mensajeError = await authService
                              .createUser(loginForm.email, loginForm.password);
                          if (mensajeError == null) {
                            Navigator.pushReplacementNamed(
                                context, 'homeroute');
                          } else {
                            if (mensajeError == 'EMAIL_EXISTS') {
                              NotificationsService.showSnackBar(
                                  '¡Correo electrónico previamente!');
                            }
                            print(mensajeError);
                            loginForm.isLoading = false;
                          }
                        })
            ],
          )),
    );
  }
}
