import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayer extends StatefulWidget {
  final String? videoURL;
  final double height;
  final bool autoPlay; // Opción para autoplay
  final bool looping; // Opción para looping

  //Constructor de la clase VideoPlayer le pasamos el videoURL por parametro
  // y le asignamos un valor por defecto a height, autoPlay y looping
  const VideoPlayer({
    super.key,
    required this.videoURL,
    this.height = 200,
    this.autoPlay = false,
    this.looping = false,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  //Incializamos el controlador de video y el controlador de chewie
  //Chewie es una librería que nos permite personalizar el reproductor de video
  late VideoPlayerController? controladorVideo;
  ChewieController? controladorChewie;
  // Variables para manejar el estado de inicialización y errores
  bool iniciado = false;
  bool hayError = false;

  //  Uso de mounted para evitar llamadas setState después de dispose
  @override
  void initState() {
    super.initState();
    // Verificamos si el videoURL no es nulo o vacío antes de inicializar
    // el controlador de video
    if (widget.videoURL != null && widget.videoURL!.isNotEmpty) {
      iniciadorDeVideo();
    } else {
      // Si no hay URL, mostramos un error
      if (mounted) setState(() => hayError = true);
    }
  }

  //  Inicialización asíncrona  del video 
  Future<void> iniciadorDeVideo() async {
    // Inicializamos el controlador de video con la URL proporcionada
    // y añadimos un listener para manejar errores
    controladorVideo = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoURL!),
    )..addListener(videoListener);

    await controladorVideo!.initialize();
    if (!mounted) return;

    controladorChewie = ChewieController(
      videoPlayerController: controladorVideo!,
      //Autoplay es falso por defecto y looping es false por defecto
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      //Tamaño eprsonalizado por el controlador de video
      aspectRatio: controladorVideo!.value.aspectRatio,
      //Propiedad que nos muestra los controles del video
      showControlsOnInitialize: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blueAccent,
        handleColor: Colors.blue,
        backgroundColor: const Color.fromARGB(255, 61, 60, 60),
        bufferedColor: const Color.fromARGB(255, 134, 134, 134),
      ),
      //Propiedad que nos muestra el icono de play en el video mientras esta caragando
      placeholder: Container(
        color: Colors.black12,
        child: const Center(
          child: Icon(Icons.play_circle_fill, size: 50, color: Colors.white70),
        ),
      ),
      //Controlador de error para mostrar un mensaje de error si no se puede cargar el video
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              Text('Error al cargar el video'),
            ],
          ),
        );
      },
    );
    // Esperamos a que el controlador de Chewie se inicialice
    if (mounted) setState(() => iniciado = true);
  }

  //Listener para cambios en el video
  void videoListener() {
    if (controladorVideo?.value.hasError ?? false) {
      //Si esta montado el componente actualizados el estado para mostrar un error
      if (mounted) setState(() => hayError = true);
    }
  }

  // Limpieza adecuada de recursos para que  se mas optimo el videoplayer
  //Pedido  a la IA ya que no entendia el proque me tardaba tanto en cargar el video
  @override
  void dispose() {
    controladorVideo?.removeListener(videoListener);
    controladorVideo?.pause();
    controladorVideo?.dispose();
    controladorChewie?.dispose();
    super.dispose();
  }

  //Metodo que se encarga de la base del reproductor de video
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(31, 5, 5, 5),
      ),
      height: widget.height,
      child: videoContent(),
    );
  }

  //  Método separado para construir el contenido según estado
  Widget videoContent() {
    // Si hay un error o la URL es nula o vacía, mostramos un widget de error
    if (hayError || widget.videoURL == null || widget.videoURL!.isEmpty) {
      return videoContentError();
    }
    // Si el video no ha sido inicializado mediante la booleana del principio, mostramos un widget de carga
    if (!iniciado) {
      return videoContentCargando();
    }

    // Si el controlador de Chewie está inicializado y el video está listo para reproducirse, mostramos el video
    if (controladorChewie != null &&
        controladorChewie!.videoPlayerController.value.isInitialized) {
      // Usamos ClipRRect para redondear las esquinas del video
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: FittedBox(
            fit: BoxFit.contain, // Cubre todo el espacio disponible
            child: SizedBox(
              width: controladorVideo!.value.aspectRatio * widget.height,
              height: widget.height,
              child: Chewie(controller: controladorChewie!),
            ),
          ),
        ),
      );
    }

    return videoContentCargando();
  }

  // Nuevo: Widget de carga personalizado
  Widget videoContentCargando() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(strokeWidth: 3),
          const SizedBox(height: 8),
          Text('Cargando video...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Widget de error personalizado basico que mostrar un icono de error y un mensaje
  Widget videoContentError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),
          const SizedBox(height: 10),
          Text('Video no disponible', style: TextStyle(color: Colors.white)),
          if (widget.videoURL == null || widget.videoURL!.isEmpty)
            Text(
              'URL no proporcionada o vacia ',
              style: TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
