// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nipibasket_tupizarravirtual/models/ThemeProvider.dart';
import 'package:nipibasket_tupizarravirtual/models/Usuarios.dart';
import 'package:nipibasket_tupizarravirtual/services/auth_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final UserCredential userCredential;

  const SettingsPage({super.key, required this.userCredential});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _selectedImage;
  String? _currentPhotoUrl;
  @override
  void initState() {
    super.initState();
    cargarFotoPefil();
  }

  // Método para obtener el usuario completo de Firestore
  Future<Usuarios?> userProfile() async {
    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.userCredential.user?.uid)
              .get();

      if (userDoc.exists) {
        return Usuarios.fromJson(userDoc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error obteniendo datos de usuario: $e');
      return null;
    }
  }

  Future<void> cambiarFoto(BuildContext context) async {
    //Pedir permiso para acceder a la galería
    var permission = await Permission.photos.request();
    // Si el permiso es restringido, solicitarlo de nuevo
    if(permission.isRestricted)
    {
        permission= await Permission.photos.request();

    }

    // Verificar si el permiso fue concedido
    if (permission.isGranted) {
      // Si el permiso fue concedido, abrir la galería
      // y permitir al usuario seleccionar una imagen
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      // Si el usuario seleccionó una imagen, actualizar el estado
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        try {
          // Subir imagen a Firebase Storage en una carpeta ,  leido de la IA para tenerlo mas ordenador
          final storageRef = FirebaseStorage.instance.ref().child(
            'profile_pics/${widget.userCredential.user!.uid}.jpg',
          );
          // Subir la imagen al almacenamiento
          await storageRef.putFile(File(image.path));
          // Obtener la URL de descarga de la imagen para asi poder luego pasarselo a la coleccion
          final String url = await storageRef.getDownloadURL();

          // Actualizar la URL de la foto de perfil del usuario en Firebase Auth y Firestore , por si acaso aunque la saco de Firestore
          await widget.userCredential.user!.updatePhotoURL(url);
          // Actualizar la URL de la foto de perfil del usuario en Firestore
          // Esto es necesario para que la imagen se pueda mostrar en la aplicación
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.userCredential.user!.uid)
              .update({'photoURL': url});
          // Mostrar mensaje
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Foto actualizada!')));
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    } else if (permission.isDenied) {
      await openAppSettings();
    }
  }

  // Método para cargar la foto de perfil del usuario desde Firestore  por defecto
  Future<void> cargarFotoPefil() async {
    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.userCredential.user?.uid)
              .get();

      // Verificar si el documento existe y si tiene una URL de foto
      if (userDoc.exists && userDoc.data()?['photoURL'] != null) {
        setState(() {
          _currentPhotoUrl = userDoc.data()!['photoURL'];
        });
      }
    } catch (e) {
      debugPrint('Error cargando foto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajustes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(24.0),
                  child: FutureBuilder<Usuarios?>(
                    future: userProfile(),
                    builder: (context, snapshot) {
                      final userData = snapshot.data;
                      final firebaseUser = widget.userCredential.user;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                            // Si hay una imagen seleccionada, mostrarla
                                _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                  // Si no hay una imagen seleccionada, mostrar la imagen de Firestore
                                    // Si no hay una imagen de Firestore, mostrar la imagen por defecto
                                    : (_currentPhotoUrl != null &&
                                            _currentPhotoUrl!.isNotEmpty
                                        ? NetworkImage(_currentPhotoUrl!)
                                        : const AssetImage(
                                          'lib/assets/icon/icono.png',
                                        )),
                            backgroundColor: Colors.deepPurple[100],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await cambiarFoto(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cambiar imagen'),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            userData?.username ?? 'Usuario',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            firebaseUser?.email ?? 'Correo no disponible',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Cambia el tema de la aplicación
                  // al modo oscuro o claro según la configuración actual
                  // Se le pasa listener false para que no se vuelva a construir el widget
                  // y no se vuelva a llamar al build
                  Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Provider.of<ThemeProvider>(context).isDarkMode
                        ? Icon(Icons.light_mode, size: 20)
                        : Icon(Icons.dark_mode, size: 20),
                    const SizedBox(width: 12),
                    const Text('Cambiar tema', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    shadowColor: Colors.red.withOpacity(0.4),
                  ),
                  onPressed: () => dialogoCerrarSesion(context),
                  child: const Text(
                    'CERRAR SESIÓN',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Este método se encarga de mostrar un dialogo de confirmacion para cerrar sesion
  void dialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              '¿Estás seguro de que quieres salir de tu cuenta?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Aquí se llama al servicio de autenticación para cerrar sesión
                  final AuthService auth = AuthService();
                  Navigator.pop(context);
                  await auth.signout(context: context);
                },
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
