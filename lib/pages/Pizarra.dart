import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/DibujoPuntos.dart';

class Pizarra extends StatefulWidget {
  final UserCredential userCredential;
  const Pizarra({super.key, required this.userCredential});

  @override
  State<Pizarra> createState() => _PizarraState();
}

class _PizarraState extends State<Pizarra> {
  // Lista para almacenar los puntos dibujados que luego seran los que usemos para dibujar en la pizarra
  List<DibujoPuntos> drawingPoints = [];
  //Tamaño brocha
  double strokeWidth = 3.0;
  //Color seleccionado
  Color selectedColor = Colors.black;
  // Lista de colores disponibles para el trazo
  List<Color> colors = [Colors.white, Colors.red, Colors.yellow, Colors.black];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pizarra Táctica',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 46, 127, 168),
        actions: [
          IconButton(
            // Botón para deshacer el último trazo
            icon: const Icon(Icons.undo, color: Colors.white),
            onPressed: () {
              setState(() {
                // Eliminar el último trazo dibujado si no esta vacio el array
                //Es lo equivalente a un undo
                if (drawingPoints.isNotEmpty) {
                  drawingPoints.removeLast();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              setState(() {
                // Limpiar todos los trazos dibujados de la pizarra 
                drawingPoints.clear();
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          // Cancha de baloncesto como fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/icon/cancha_baloncesto.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Área de dibujo
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              // Bloquea explícitamente los gestos horizontales pedido de IA ya que no sabia como hacer que se cambiara
              if (details.delta.dx.abs() > details.delta.dy.abs()) {
                return;
              }
            },
            //Inicias un nuevo trazo al tocar la pantalla funcion de GestureDetector
            onPanStart: (punto) {
              setState(() {
                // Añadir un nuevo punto de dibujo al inicio del trazo
                drawingPoints.add(
                  DibujoPuntos(
                    // Punto inicial del trazo
                    points: [punto.localPosition],
                    // Propiedades de pintura del trazo le asignas el color , el tamaño y el estilo y que este suavizado
                    paint:
                        Paint()
                          ..color = selectedColor
                          ..strokeWidth = strokeWidth
                          ..strokeCap = StrokeCap.round
                          ..isAntiAlias = true,
                  ),
                );
              });
            },
            // Actualizar el trazo mientras se mueve el dedo por la pantalla
            onPanUpdate: (details) {
              setState(() {
                // Añadir el punto actual al trazo en curso al array de puntos vas añadiendo los puntos mientras vas deslizando el dedo
                drawingPoints.last.points.add(details.localPosition);
              });
            },
            // Finalizar el trazo al levantar el dedo
            onPanEnd: (details) {
              setState(() {
                drawingPoints.last.points.add(null); // Marcador de fin de trazo
              });
            },
            // Pintar los trazos en la pantalla
            child: CustomPaint(
              // Usar el CustomPainter para dibujar los trazos
              painter: DrawingPainter(drawingPoints),
              // Tamaño infinito para ocupar todo el espacio disponible
              size: Size.infinite,
            ),
          ),
          // Herramientas flotantes
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Ajustes de color para actualizar el color del trazo
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    // Muestra los colores disponibles para seleccionar recorriendo el array de colores
                    children:
                        colors.map((color) {
                          // Crea un círculo para cada color
                          return GestureDetector(
                            // Al tocar un color, actualiza el color seleccionado actualizas la variable selectedColor
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            // Crea un contenedor circular con el color seleccionado segun el del array
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                // Añade un borde blanco si es el color seleccionado
                                // o transparente si no lo es
                                border: Border.all(
                                  color:
                                      selectedColor == color
                                          ? Colors.white
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                // Control de grosor del trazo
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        // Disminuir el grosor del trazo cuando clickas en el boton menos hasta un minimo de 1px
                        onPressed: () {
                          setState(() {
                            if (strokeWidth > 1) {
                              strokeWidth -= 1;
                            }
                          });
                        },
                      ),
                      // Mostrar el grosor actual del trazo el cual emepieza en 3px
                      Text(
                        '${strokeWidth.toInt()}px',
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Aumentar el grosor del trazo cuando clickas en el boton mas sumando de 1 en 1 hasta un maximo de 20px
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            if (strokeWidth < 20) {
                              strokeWidth += 1;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter para dibujar los trazos en la pantalla ayudado por IA para hacerlo ya que me resulto costoso
class DrawingPainter extends CustomPainter {
  // Lista de puntos de dibujo que contiene los trazos y sus propiedades
  final List<DibujoPuntos> drawingPoints;

  DrawingPainter(this.drawingPoints);

  // Sobreescribe el método paint para dibujar los trazos en el canvas
  @override
  void paint(Canvas canvas, Size size) {
    // Recorre cada trazo en la lista de puntos de dibujo
    for (var drawingPoint in drawingPoints) {
      // Obtiene los puntos y la pintura del trazo actual
      final points = drawingPoint.points;
      final paint = drawingPoint.paint;
      // Dibuja cada segmento del trazo
      for (int i = 0; i < points.length - 1; i++) {
        // Comprueba que los puntos no sean nulos antes de dibujar la línea
        // Esto es necesario porque al final de cada trazo se añade un punto nulo para indicar el final del trazo
        if (points[i] != null && points[i + 1] != null) {
          // Dibuja una línea entre los puntos actuales y el siguiente
          canvas.drawLine(points[i]!, points[i + 1]!, paint);
        }
      }
    }
  }
  // Sobreescribe el método shouldRepaint para indicar que el painter debe ser repintado
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
