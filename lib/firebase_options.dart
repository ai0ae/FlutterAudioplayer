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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC3FgR6pc6pDshLaCn_JaEfMdz5bUVCsfM',
    appId: '1:481488591575:android:223d27afb34a6de5fcae92',
    messagingSenderId: '481488591575',
    projectId: 'flutter-assignment-2837f',
    storageBucket: 'flutter-assignment-2837f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-fD102H64h2GxJpkJgvZ09c0hfUaMz_E',
    appId: '1:481488591575:ios:83c44fe8d4e0506dfcae92',
    messagingSenderId: '481488591575',
    projectId: 'flutter-assignment-2837f',
    storageBucket: 'flutter-assignment-2837f.appspot.com',
    androidClientId: '481488591575-e4rmnib8argd9dv603ljjha3jkvh4ock.apps.googleusercontent.com',
    iosClientId: '481488591575-jtus59sihm8jgvg0jp6vfvbit21ft288.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplicationAudioplayer',
  );
}
