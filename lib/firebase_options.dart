// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBXFCPwRFzFMOEhCIY4D9CmA9Ujry68Ypo',
    appId: '1:759474534488:web:b5cb898afeb148e62f322d',
    messagingSenderId: '759474534488',
    projectId: 'sibulu-sispuas',
    authDomain: 'sibulu-sispuas.firebaseapp.com',
    storageBucket: 'sibulu-sispuas.appspot.com',
    measurementId: 'G-9VH5R3XV2K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkkhkEygFXamb87SfSBkeTpUiEJ-bmLtQ',
    appId: '1:759474534488:android:1406c5080ef911672f322d',
    messagingSenderId: '759474534488',
    projectId: 'sibulu-sispuas',
    storageBucket: 'sibulu-sispuas.appspot.com',
  );
}
