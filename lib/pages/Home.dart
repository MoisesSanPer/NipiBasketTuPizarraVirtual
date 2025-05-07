import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/pages/Calendar.dart';
import 'package:nipibasket_tupizarravirtual/pages/Ejercicios.dart';
import 'package:nipibasket_tupizarravirtual/pages/Entrenamiento.dart';
import 'package:nipibasket_tupizarravirtual/pages/SettingsPage.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _appbar,
        body: _body,
        bottomNavigationBar: _tabBar,
      ),
    );
  }

  AppBar get _appbar => AppBar(
    backgroundColor: Colors.deepPurple[900],
    title: const Text(
      "ÑipiBasket",
      style: TextStyle(
        color: Colors.white,
        fontSize: 20, // Un poco más grande para mejor visibilidad
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.help_outline, color: Colors.white),
        tooltip: 'Ayuda',
        onPressed:
            () => {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Ayuda"),
                      content: SingleChildScrollView(
                        child: Column(
                          //Hace que el alertbox se ajuste al contenido
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Versión: Beta v-1.0.0",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            const Text(
                              "Aplicación para la gestión completa de equipos de baloncesto.",
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Funciones principales:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            //Detecta  al tocar el email y se ejecuta el metodo de lanzar el email
                            //En este caso seria como un boton pero con texto lo he visto ya que me parece mejor que un boton en este caso
                            GestureDetector(
                              onTap: () => (_launchEmail()),
                              child: const Text(
                                "Contacto: moisessanper5@gmail.com",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Te muestra el icono abajo a al derecha y con el se cierra
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
              ),
            },
      ),
      IconButton(
        icon: const Icon(Icons.settings, color: Colors.white),
        tooltip: 'Configuración',
        onPressed: () => {
           Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  SettingsPage()),
    )
        },
      ),
    ],
  );
  /// Funcion que lanza el correo electronico el cual se lanza al pulsar el icono de ayuda
  /// Tiene un esquema  que es de envio y se enviara al correo electronico
void _launchEmail() async {
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
  }
}


  TabBar get _tabBar =>
      TabBar(tabs: [Tab(text: "Calendar", icon: Icon(Icons.calendar_month)),
      Tab(text: "Ejercicios", icon: Icon(Icons.sports_basketball)),
       Tab(text: "Entrenamiento", icon: Icon(Icons.bookmark_add_rounded)),
      ]);

  Widget get _body => TabBarView(children: [CalendarScreen(),Ejercicios(),Entrenamiento()]);
}
