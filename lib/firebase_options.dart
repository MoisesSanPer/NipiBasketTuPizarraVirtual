// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDOG_GeG1SIX2JqjLgdJDnjXVBofCHWl48',
    appId: '1:266143210976:web:8922f6afa005f6d7a89f85',
    messagingSenderId: '266143210976',
    projectId: 'nipibasketpizarravirtual',
    authDomain: 'nipibasketpizarravirtual.firebaseapp.com',
    storageBucket: 'nipibasketpizarravirtual.firebasestorage.app',
    measurementId: 'G-P4494W7GD8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCT2cQTaKoMu2hE5CTonqnbaQpaW0Vo0Hw',
    appId: '1:266143210976:android:fa3bb9ba9e29d945a89f85',
    messagingSenderId: '266143210976',
    projectId: 'nipibasketpizarravirtual',
    storageBucket: 'nipibasketpizarravirtual.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAA1w-0wXxM7hqtKe2ZrufI-kdEBqWuFKk',
    appId: '1:266143210976:ios:fdbd12ca0d18aab0a89f85',
    messagingSenderId: '266143210976',
    projectId: 'nipibasketpizarravirtual',
    storageBucket: 'nipibasketpizarravirtual.firebasestorage.app',
    iosBundleId: 'com.example.nipibasketTupizarravirtual',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAA1w-0wXxM7hqtKe2ZrufI-kdEBqWuFKk',
    appId: '1:266143210976:ios:fdbd12ca0d18aab0a89f85',
    messagingSenderId: '266143210976',
    projectId: 'nipibasketpizarravirtual',
    storageBucket: 'nipibasketpizarravirtual.firebasestorage.app',
    iosBundleId: 'com.example.nipibasketTupizarravirtual',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDOG_GeG1SIX2JqjLgdJDnjXVBofCHWl48',
    appId: '1:266143210976:web:a34c95f0efbe2370a89f85',
    messagingSenderId: '266143210976',
    projectId: 'nipibasketpizarravirtual',
    authDomain: 'nipibasketpizarravirtual.firebaseapp.com',
    storageBucket: 'nipibasketpizarravirtual.firebasestorage.app',
    measurementId: 'G-3XKL6FV5X0',
  );

}