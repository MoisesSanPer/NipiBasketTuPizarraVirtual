import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/ThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nipibasket_tupizarravirtual/services/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    // Provider para el tema
    // Esto permite que el tema se pueda cambiar en toda la aplicación
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const AppRoot(),
    ));
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const Wrapper(),
    );
    
  }
}

