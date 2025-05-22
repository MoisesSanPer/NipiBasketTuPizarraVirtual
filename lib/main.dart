import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/ThemeProvider.dart';
import 'package:nipibasket_tupizarravirtual/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
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
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: const LoginScreen(),
    );
    
  }
}

