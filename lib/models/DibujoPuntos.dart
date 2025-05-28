import 'dart:ui';

//Clase que representa un dibujo de puntos
class DibujoPuntos {
  // Lista de puntos que componen el dibujo  que se dibujara en la pizarra
  List<Offset?> points;
  /// Propiedades de pintura del trazo, como el color, el ancho y el estilo que nos servira
  Paint paint;

  DibujoPuntos({required this.points, required this.paint});
}