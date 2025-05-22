import 'package:flutter/material.dart';

//Clase para el provider del tema
class ThemeProvider with ChangeNotifier {
  // Inicializamos el tema por defecto en modo claro
  ThemeMode _themeMode = ThemeMode.light;

  // Getter para obtener el tema actual
  ThemeMode get themeMode => _themeMode;

// Getter para verificar si el modo oscuro está activado
  bool get isDarkMode => _themeMode == ThemeMode.dark;

// Método para alternar entre el modo claro y oscuro
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}