import 'package:flutter/material.dart';

//Clase para el provider del tema
class ThemeProvider with ChangeNotifier {
  // Inicializamos el tema por defecto en modo claro
  ThemeMode _themeMode = ThemeMode.light;

// Getter para verificar si el modo oscuro está activado y haces las ternarias despues 
  bool get isDarkMode => _themeMode == ThemeMode.dark;
 
// Método para alternar entre el modo claro y oscuro
// Este método cambia el tema y notifica a los oyentes
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}