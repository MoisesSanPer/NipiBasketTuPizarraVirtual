// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/ThemeProvider.dart';
import 'package:nipibasket_tupizarravirtual/pages/Calendar.dart';
import 'package:nipibasket_tupizarravirtual/pages/Ejercicios.dart';
import 'package:nipibasket_tupizarravirtual/pages/Entrenamiento.dart';
import 'package:nipibasket_tupizarravirtual/pages/Jugadas.dart';
import 'package:nipibasket_tupizarravirtual/pages/SettingsPage.dart';
import 'package:nipibasket_tupizarravirtual/pages/pizarra.dart';
import 'package:nipibasket_tupizarravirtual/services/EjerciciosServices.dart';
import 'package:nipibasket_tupizarravirtual/services/EntrenamietoService.dart';
import 'package:nipibasket_tupizarravirtual/services/JugadasServices.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final EntrenamientoService entrenamientoService;
  final EjerciciosServices ejerciciosServices;
  final JugadasServices jugadasServices;

  const Home({
    super.key,
    required this.entrenamientoService,
    required this.ejerciciosServices,
    required this.jugadasServices,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 @override
Widget build(BuildContext context) {
  // Cuando se clicke el boton de retroceso, se redirige a la pantalla de inicio de sesión
  return WillPopScope(
    onWillPop: () async {
      // Redirige a la pantalla de inicio de sesión y elimina todas las rutas anteriores
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Wrap()), 
        (Route<dynamic> route) => false,
      );
      return false; 
    },
    child: DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: _appbar,
        body: _body,
        bottomNavigationBar: _tabBar,
      ),
    ),
  );
}

  AppBar get _appbar => AppBar(
    //El appbar tiene un color que cambia dependiendo del modo oscuro
    // El color del appbar es un degradado que cambia dependiendo del modo oscuro
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          //Esta es una ternaria que segun el color del tema cambia el degradado
          colors:
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? [Colors.black, Colors.grey[900]!]
                  : [Colors.deepPurple[900]!, Colors.purple[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    title: const Text(
      "ÑipiBasket",
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    centerTitle: true,

    //Propiedades estas dos que hay que tener activas para que no se muestre el icono de retroceso en la pagina de inicio
    leading: null,
    automaticallyImplyLeading: false,
    actions: [
      IconButton(
        icon: const Icon(Icons.help_outline, color: Colors.white),
        tooltip: 'Ayuda',
        onPressed: () => helpDialog(context),
      ),
      IconButton(
        icon: const Icon(Icons.settings, color: Colors.white),
        tooltip: 'Configuración',
        onPressed:
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            },
      ),
    ],
  );
  void helpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              Provider.of<ThemeProvider>(context).isDarkMode
                                  ? const Color.fromARGB(
                                    255,
                                    184,
                                    198,
                                    209,
                                  ).withOpacity(0.2)
                                  : Colors.blue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.help,
                          color:
                              Provider.of<ThemeProvider>(context).isDarkMode
                                  ? const Color.fromARGB(255, 150, 162, 172)
                                  : const Color.fromARGB(255, 25, 62, 92),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Ayuda",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Contenido
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Información de la aplicación lo hago en metodo auxiliar para que se mas limpio el codigo refactorizando
                        titleInfo("Versión", "Beta v-1.3.0"),
                        const SizedBox(height: 16),
                        Text(
                          "Aplicación para la gestión de entrenamientos de baloncesto.",
                          style: TextStyle(
                            color:
                                Provider.of<ThemeProvider>(context).isDarkMode
                                    ? Color.fromARGB(255, 255, 253, 253)
                                    : Color.fromARGB(255, 70, 70, 70),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "FUNCIONALIDADES",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        functionalitiesItem(" •  Creación de entrenamiento"),
                        functionalitiesItem(" •  Gestión de ejercicios"),
                        functionalitiesItem(" •  Gestión de jugadas"),
                        const SizedBox(height: 24),
                        buttonSendEmail(context),
                      ],
                    ),
                  ),

                  // Footer con botón
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cerrar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  //Extraido  metodo auxiliar para construir los items de información
  titleInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color:
                Provider.of<ThemeProvider>(context).isDarkMode
                    ? Colors.blue
                    : Color.fromARGB(255, 119, 119, 119),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  // Widget auxiliar para las funcionalidades
  functionalitiesItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 4),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  // Widget para el botón de contacto el cual enviara el correo electronico al pulsarlo
  buttonSendEmail(BuildContext context) {
    return InkWell(
      onTap: () => launchEmail(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.email,
              color: Color.fromARGB(255, 25, 142, 238),
              size: 24,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Soporte técnico",
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Provider.of<ThemeProvider>(context).isDarkMode
                            ? Color.fromARGB(255, 255, 253, 253)
                            : Color.fromARGB(255, 94, 93, 93),
                  ),
                ),
                Text(
                  "moisessanper5@gmail.com",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 25, 142, 238),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Funcion que lanza el correo electronico el cual se lanza al pulsar el icono de ayuda
  /// Tiene un esquema  que es de envio y se enviara al correo electronico
  void launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      //El email que se va a enviar
      path: 'moisessanper5@gmail.com',
      queryParameters: {'subject': 'Soporte ÑipiBasket'},
    );
    // Verifica si se puede lanzar la URL
    // Si se puede lanzar, lanza la URL
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Mostrar un Toast o SnackBar si no hay app de correo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró una aplicación de correo.'),
        ),
      );
    }
  }

  TabBar get _tabBar => TabBar(
    labelStyle: TextStyle(fontSize: 12),
    tabs: [
      Tab(text: "Calendar", icon: Icon(Icons.calendar_month)),
      Tab(text: "Ejercicios", icon: Icon(Icons.sports_basketball)),
      Tab(text: "Entrenamiento", icon: Icon(Icons.fitness_center)),
      Tab(text: "Jugadas", icon: Icon(Icons.scoreboard)),
      Tab(text: "Pizarra", icon: Icon(Icons.edit_road)),
    ],
  );

  Widget get _body => TabBarView(
    physics: NeverScrollableScrollPhysics(),
    children: [
      CalendarScreen(),
      Ejercicios(ejerciciosServices: widget.ejerciciosServices),
      Entrenamiento(entrenamientoService: widget.entrenamientoService),
      Jugadas(jugadasServices: widget.jugadasServices),
      Pizarra(),
    ],
  );
}
