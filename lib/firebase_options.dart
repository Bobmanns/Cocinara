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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyBHxoDAtVTKLcvCr2ygj1bykhVg1T8cJ-s',
    appId: '1:1016996388674:web:610bf3d4e6808e842072db',
    messagingSenderId: '1016996388674',
    projectId: 'cocinara-21548',
    authDomain: 'cocinara-21548.firebaseapp.com',
    storageBucket: 'cocinara-21548.appspot.com',
    measurementId: 'G-8N89BFJE31',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCo769YbrKOL0_3A8J4Mgz2-LNX7mwGUls',
    appId: '1:1016996388674:android:b65612aa3a18eace2072db',
    messagingSenderId: '1016996388674',
    projectId: 'cocinara-21548',
    storageBucket: 'cocinara-21548.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMKJ_L3xHOAR-31RPl4nMJRplKQIyE-wQ',
    appId: '1:1016996388674:ios:e0e94d980c5574432072db',
    messagingSenderId: '1016996388674',
    projectId: 'cocinara-21548',
    storageBucket: 'cocinara-21548.appspot.com',
    iosClientId:
        '1016996388674-lthijplhnmvvvo57pgm4cgo5ikufbrlf.apps.googleusercontent.com',
    iosBundleId: 'com.example.myCocinara',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMKJ_L3xHOAR-31RPl4nMJRplKQIyE-wQ',
    appId: '1:1016996388674:ios:e0e94d980c5574432072db',
    messagingSenderId: '1016996388674',
    projectId: 'cocinara-21548',
    storageBucket: 'cocinara-21548.appspot.com',
    iosClientId:
        '1016996388674-lthijplhnmvvvo57pgm4cgo5ikufbrlf.apps.googleusercontent.com',
    iosBundleId: 'com.example.myCocinara',
  );
}
