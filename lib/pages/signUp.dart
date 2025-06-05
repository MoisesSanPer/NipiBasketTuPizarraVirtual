// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nipibasket_tupizarravirtual/pages/login.dart';
import 'package:nipibasket_tupizarravirtual/services/auth_services.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{4,20}$');
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
  );
  bool isLoading = false;
  bool obscurePassword = true;
  //Metodo para mostrar los Toast
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }


  @override
  Widget build(BuildContext context) {
    //Ajusta el tamaño de la pantalla para evitar el desbordamiento ya que me daba problemas con  overflow de pixeles
    final heightScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //Ajusta el tamaño de la pantalla para evitar el desbordamiento
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widthScreen * 0.10,
                vertical: heightScreen * 0.15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Crear cuenta',
                    style: TextStyle(
                      fontSize: heightScreen * 0.048,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Regístrate, por favor',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/assets/icon/canasta.png',
                        height: 140,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.person, color: Colors.indigo),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      //Para que cuando suba el texto no se vea el label y no se bugue
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email, color: Colors.indigo),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Colors.indigo),
                      suffixIcon: IconButton(
                        //Ternaria para ir comprobando el icono de la contraseña que depende de si se ve o no
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '¿Ya tiene una cuenta?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 189, 187, 187),
                              fontSize: widthScreen * 0.04,
                            ),
                          ),
                          Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: widthScreen * 0.045,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () async {
                                // Validación de los campos mismo formato que en el login
                                final username =
                                    _usernameController.text.trim();
                                final email = _emailController.text.trim();
                                final password = _passwordController.text;
                                if (!usernameRegExp.hasMatch(username)) {
                                  showToast(
                                    'Nombre de usuario inválido. Usa letras, números o guiones bajos (4-20 caracteres).',
                                  );
                                  return;
                                }
                                if (!emailRegExp.hasMatch(email)) {
                                  showToast('Correo electrónico inválido.');
                                  return;
                                }
                                if (!passwordRegExp.hasMatch(password)) {
                                  showToast(
                                    'La contraseña debe tener al menos 6 caracteres, incluyendo letras y números.',
                                  );
                                  return;
                                }
                                setState(() => isLoading = true);
                                await AuthService().signup(
                                  username: username,
                                  email: email,
                                  password: password,
                                  context: context,
                                );

                                setState(() => isLoading = false);
                              },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      child:
                          isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                'REGÍSTRATE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
