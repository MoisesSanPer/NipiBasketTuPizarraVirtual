// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/ThemeProvider.dart';
import 'package:nipibasket_tupizarravirtual/pages/signUp.dart';
import 'package:nipibasket_tupizarravirtual/services/auth_services.dart';
import 'package:nipibasket_tupizarravirtual/services/forgot_password.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool isLoading = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    //Ajusta el tamaño de la pantalla para evitar el desbordamiento ya que me daba problemas con  overflow de pixeles
    final heightScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.width;
    return GestureDetector(
      //Ocultar el teclado cuando el usuario toca fuera de este
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //Ajusta el tamaño de la pantalla para evitar el desbordamiento
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  Provider.of<ThemeProvider>(context).isDarkMode
                      ? [Colors.black, Colors.black]
                      : [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widthScreen * 0.11,
                vertical: heightScreen * 0.15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: heightScreen * 0.056,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Iniciar sesión para continuar',
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
                        'lib/assets/icon/icono.png',
                        height: 140,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color:
                          Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email, color: Colors.indigo),
                      counterStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor:
                          Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.black
                              : Colors.white,
                    ),
                    maxLength: 35,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: obscurePassword,
                    style: TextStyle(
                      color:
                          Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
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
                      fillColor:
                          Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        '¿Ha olvidado su contraseña?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                AuthService().signin(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  context: context,
                                );
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
                                'INICIAR SESIÓN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '¿Prefieres algo más rápido?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      AuthService().signInWithGoogle(context: context);
                    },
                    icon: Image.asset(
                      "lib/assets/icon/google_logo.webp",
                      height: 24,
                      width: 24,
                    ),
                    label: Text(
                      'Iniciar sesión con Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿No tiene cuenta?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 184, 183, 183),
                          fontSize: widthScreen * 0.04,
                        ),
                      ),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widthScreen * 0.04,
                          ),
                        ),
                        child: Text(
                          'Regístrate',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
