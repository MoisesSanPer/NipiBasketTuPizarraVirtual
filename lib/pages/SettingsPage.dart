// ignore_for_file: deprecated_member_use

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
// ... (otros imports se mantienen igual)

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? imagenSeleccionada;
  String? urlFotoActual;
  bool isUpdatingFoto = false;

  @override
  void initState() {
    super.initState();
    cargarFotoPerfil();
  }

  // Cargar foto de perfil al iniciar la aplicación
  Future<void> cargarFotoPerfil() async {
    try {
      //Llama a Firestore para obtener la URL de la foto de perfil
      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      // Si el documento existe y tiene una URL de foto, la asigna a urlFotoActual
      if (userDoc.exists) {
        //Actualiza el estado con la URL de la foto la cual sacas del documento de Firestore
        setState(() => urlFotoActual = userDoc.data()!['photoURL']);
      }
    } catch (e) {
      // Si ocurre un error al cargar la foto, muestra un mensaje
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar foto: ${e.toString()}')),
        );
      }
    }
  }

  // Método para cambiar la foto de perfil
  // Este método solicita permisos, permite seleccionar una imagen y la sube a Firebase Storage
  Future<void> cambiarFotoPerfil() async {
    // Verifica si ya se está actualizando la foto para evitar múltiples solicitudes
    setState(() => isUpdatingFoto = true);
    try {
      // Solicita permisos para acceder a la galería de fotos
      final permission = await Permission.photos.request();
      // Si el permiso no es concedido, abre la configuración de ajustes
      if (!permission.isGranted) {
        await openAppSettings();
        return;
      }
      // Abre la galería para seleccionar una imagen
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // Actualiza el estado con la imagen seleccionada la cual es sacada de la galería
      setState(() => imagenSeleccionada = File(image!.path));
      // Subir imagen a Firebase Storage a una carpeta específica
      final storageRef = FirebaseStorage.instance.ref(
        'profile_pics/${FirebaseAuth.instance.currentUser!.uid}.jpg',
      );

      // Subir la imagen seleccionada al almacenamiento de Firebase
      await storageRef.putFile(imagenSeleccionada!);
      // Obtener la URL de descarga de la imagen subida con esta URL se actualizará la foto de perfil
      final downloadUrl = await storageRef.getDownloadURL();

      // Actualizar en Auth y Firestore para tener la foto de perfil actualizada
      await Future.wait([
        FirebaseAuth.instance.currentUser!.updatePhotoURL(downloadUrl),
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'photoURL': downloadUrl}),
      ]);
      // Actualizar el estado con la nueva URL de la foto
      // Esto actualizará la foto de perfil en la aplicación
      setState(() => urlFotoActual = downloadUrl);
      // Mostrar un mensaje de éxito si  esta montado la foto esto es importante para evitar errores si el widget ya no está en el árbol
      // de widgets
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto actualizada correctamente!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      // Independientemente de si la operación fue exitosa o no, actualiza el estado para indicar que ya no se está actualizando la foto
      if (mounted) {
        setState(() => isUpdatingFoto = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //Esta es una ternaria que segun el color del tema cambia el degradado
              colors:
                  Provider.of<ThemeProvider>(context).isDarkMode
                      ? [Colors.black]
                      : [Colors.deepPurple[900]!, Colors.purple[800]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Ajustes',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Tarjeta de perfil con foto y nombre de usuario
            FutureBuilder<Usuarios?>(
              future: getUser(),
              builder: (context, snapshot) {
                final userData = snapshot.data;
                final email =
                    FirebaseAuth.instance.currentUser!.email ?? 'Correo no disponible';
                return Card(
                  //Para que sobresalga un poco del fondo
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Avatar y botón de editar  visto en video de Youtube
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // Avatar de pefil el cual mostrara la foto de perfil o un icono por defecto
                            mostrarFotoPefil(),
                            // Botón editar la foto de perfil
                            FloatingActionButton.small(
                              onPressed: () => cambiarFotoPerfil(),
                              child: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userData?.username ?? 'Usuario',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(email, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Botón cambiar tema
            ElevatedButton.icon(
              // Icono que cambia según el tema actual
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              // Texto del botón que cambia según el tema actual
              label: Text(isDarkMode ? 'Modo claro' : 'Modo oscuro'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Al presionar el botón, se cambia el tema
              onPressed: () => themeProvider.toggleTheme(),
            ),
            const SizedBox(height: 24),
            // Botón cerrar sesión
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: Colors.red.withOpacity(0.4)),
              ),
              onPressed: () => cerrarSesionDialogo(context),
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar el avatar de perfil
  Widget mostrarFotoPefil() {
    // Si se está actualizando la foto, muestra un avatar con un indicador de carga para que parezca realista
    if (isUpdatingFoto) {
      return const CircleAvatar(radius: 60, child: CircularProgressIndicator());
    }
    // Si no se está actualizando la foto, muestra el avatar con la imagen seleccionada o la URL de la foto actual
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey[200],
      backgroundImage: getImagenPefil(),
      // Si no hay imagen seleccionada ni URL de foto , nos muestra un icono de contacto  para que qude mas bonito
      child:
          (imagenSeleccionada == null &&
                  (urlFotoActual == null || urlFotoActual!.isEmpty))
              ? const Icon(Icons.person, size: 50, color: Colors.grey)
              : null,
    );
  }

  // Método para obtener la imagen de perfil
  ImageProvider? getImagenPefil() {
    // Si hay una imagen seleccionada, devuelve esa imagen
    if (imagenSeleccionada != null) return FileImage(imagenSeleccionada!);
    // Si hay una URL de foto actual, devuelve esa imagen de red
    if (urlFotoActual != null && urlFotoActual!.isNotEmpty) {
      return NetworkImage(urlFotoActual!);
    }
    return null;
  }

  // Método para obtener el usuario actual desde Firestore
  Future<Usuarios?> getUser() async {
    try {
      // Obtiene el documento del usuario actual desde Firestore pasando el UID del usuario autenticado
      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
      // Si el documento existe, lo convierte a un objeto Usuarios sino devuelve null
      return userDoc.exists ? Usuarios.fromJson(userDoc.data()!) : null;
    } catch (e) {
      debugPrint('Error obteniendo perfil: $e');
      return null;
    }
  }

  // Método para mostrar un diálogo de confirmación al cerrar sesión
  void cerrarSesionDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text(
              '¿Estás seguro de que quieres salir de tu cuenta?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await AuthService().signout(context: context);
                },
                child: const Text('Salir', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
