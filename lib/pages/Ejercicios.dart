// ignore_for_file: use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nipibasket_tupizarravirtual/models/Ejercicio.class.dart';
import 'package:nipibasket_tupizarravirtual/models/ThemeProvider.dart';
import 'package:nipibasket_tupizarravirtual/pages/VideoPlayer.dart';
import 'package:nipibasket_tupizarravirtual/services/EjerciciosServices.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Ejercicios extends StatefulWidget {
  final EjerciciosServices ejerciciosServices;

  const Ejercicios({super.key, required this.ejerciciosServices});

  @override
  State<Ejercicios> createState() => _EjerciciosState();
}

class _EjerciciosState extends State<Ejercicios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => agregarEjercicio(context),
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<Ejercicio>>(
        stream: widget.ejerciciosServices.obtenerEjerciciosComoStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos'));
          }
          final ejercicios = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: ejercicios.length,
            itemBuilder: (context, index) {
              final ejercicio = ejercicios[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Encabezado con número y título
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            Provider.of<ThemeProvider>(context).isDarkMode
                                ? Colors.black
                                : Colors.deepPurple[50],
                      ),
                      child: Row(
                        children: [
                          //Esto se refiere al número del ejercicio en este caso el orden no influye pero es importante para el usuario
                          // que sepa que ejercicio es el que tiene que hacer
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[700],
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            // Número del ejercicio el cual me he basado en el indice
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Título del ejercicio
                          Expanded(
                            child: Text(
                              ejercicio.nombre,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Provider.of<ThemeProvider>(
                                          context,
                                        ).isDarkMode
                                        ? Colors.white
                                        : Colors.deepPurple[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Este container es el que se encarga de mostrar la imagen del ejercicio
                    //Aqui se llamara al video del ejercicio
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: VideoPlayer(
                        videoURL: ejercicio.videoURL,
                        height: 200,
                      ),
                    ),
                    // Información del ejercicio
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tipo de ejercicio con chip morado
                          Chip(
                            backgroundColor:
                                Provider.of<ThemeProvider>(context).isDarkMode
                                    ? Colors.black
                                    : Colors.deepPurple[100],
                            label: Text(
                              ejercicio.tipo
                                  .toString()
                                  .split('.')
                                  .last
                                  .toUpperCase(),
                              style: TextStyle(
                                color:
                                    Provider.of<ThemeProvider>(
                                          context,
                                        ).isDarkMode
                                        ? Colors.white
                                        : Colors.deepPurple[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Descripción
                          Text(
                            ejercicio.descripcion,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 165, 163, 163),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Método para mostrar el diálogo de agregar ejercicio
  void agregarEjercicio(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    TipoEjercicio? tipoSeleccionado = TipoEjercicio.tiro;
    File? selectedImage;
    showDialog(
      context: context,
      builder: (context) {
        // Usar StatefulBuilder para manejar el estado del diálogo y que no se buguee con el de la aplicacion
        //Ayudado por IA ya que al usar el showDialog no se actualizaba el estado del dialogo y no encontraba solucion
        return StatefulBuilder(
          builder: (context, setState) {
            //Método para subir video desde la galería es sacado del cambiar imagne que tengo en Settings Page
            // y adaptado para subir videos
            Future<void> subirVideo() async {
              var permission = await Permission.photos.request();
              if (!permission.isGranted) {
                await openAppSettings();
                return;
              }
              if (permission.isGranted) {
                final ImagePicker picker = ImagePicker();
                // Usar ImagePicker para seleccionar un video de la galería en vez de imagen
                final XFile? video = await picker.pickVideo(
                  source: ImageSource.gallery,
                );
                if (video != null) {
                  setState(() {
                    selectedImage = File(video.path);
                  });
                }
              } else if (permission.isDenied ||
                  permission.isPermanentlyDenied) {
                await openAppSettings();
              }
            }

            return AlertDialog(
              title: Text(
                'Añadir Ejercicio',
                style: TextStyle(
                  color:
                      Provider.of<ThemeProvider>(context).isDarkMode
                          ? Colors.white
                          : Colors.deepPurple,
                  fontSize: 22,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                      maxLength: 20,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: 3,
                      style: const TextStyle(fontSize: 16),
                      maxLength: 40,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tipo de ejercicio:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Lista de tipos de ejercicios sacado de la documentacion cada uno de los tipos de ejercicio
                        // Si clickas en uno de los tipos de ejercicio se selecciona y se cambia el estado
                        RadioListTile<TipoEjercicio>(
                          value: TipoEjercicio.tiro,
                          groupValue: tipoSeleccionado,
                          onChanged: (TipoEjercicio? value) {
                            setState(() {
                              tipoSeleccionado = value;
                            });
                          },
                          title: const Text('Tiro'),
                        ),
                        RadioListTile<TipoEjercicio>(
                          value: TipoEjercicio.defensa,
                          groupValue: tipoSeleccionado,
                          onChanged: (TipoEjercicio? value) {
                            setState(() {
                              tipoSeleccionado = value;
                            });
                          },
                          title: const Text('Defensa'),
                        ),
                        RadioListTile<TipoEjercicio>(
                          value: TipoEjercicio.botar,
                          groupValue: tipoSeleccionado,
                          onChanged: (TipoEjercicio? value) {
                            setState(() {
                              tipoSeleccionado = value;
                            });
                          },
                          title: const Text('Botar'),
                        ),
                        RadioListTile<TipoEjercicio>(
                          value: TipoEjercicio.pase,
                          groupValue: tipoSeleccionado,
                          onChanged: (TipoEjercicio? value) {
                            setState(() {
                              tipoSeleccionado = value;
                            });
                          },
                          title: const Text('Pase'),
                        ),
                        RadioListTile<TipoEjercicio>(
                          value: TipoEjercicio.rebote,
                          groupValue: tipoSeleccionado,
                          onChanged: (TipoEjercicio? value) {
                            setState(() {
                              tipoSeleccionado = value;
                            });
                          },
                          title: const Text('Rebote'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Botón para subir el video
                    ElevatedButton(
                      onPressed: () async {
                        await subirVideo();
                      },
                      child: Text(
                        'Seleccionar ejercicio (video)',
                        style: TextStyle(
                          color:
                              Provider.of<ThemeProvider>(context).isDarkMode
                                  ? Colors.white
                                  : Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Vista previa del video seleccionado
                    // Si hay un video seleccionado, mostrarlo
                    if (selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: VideoPlayer(videoURL: selectedImage?.path),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color:
                          Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.white
                              : Color.fromARGB(255, 147, 15, 199),
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'El nombre es requerido',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: Colors.redAccent,
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14.0,
                      );
                      return;
                    }
                    Navigator.pop(context);
                    String url = "";
                    final nuevoId = Uuid().v4();
                    if (selectedImage != null) {
                      try {
                        // Subir video a Firebase Storage formato .mp4
                        final storageRef = FirebaseStorage.instance.ref().child(
                          '${nuevoId}${nameController.text}.mp4',
                        );
                        // Subir el archivo seleccionado a Firebase Storage
                        await storageRef.putFile(selectedImage!);
                        // Obtener la URL de descarga del video
                        url = await storageRef.getDownloadURL();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al subir imagen: $e')),
                        );
                        return;
                      }
                    }
                    final ejercicio = Ejercicio(
                      id: nuevoId,
                      nombre: nameController.text,
                      descripcion: descriptionController.text,
                      tipo: tipoSeleccionado ?? TipoEjercicio.tiro,
                      videoURL: url,
                      idUsuario: FirebaseAuth.instance.currentUser?.uid ?? '',
                    );
                    widget.ejerciciosServices.agrgarEjercicio(ejercicio);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Añadir Ejercicio',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
