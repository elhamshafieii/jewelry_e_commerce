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
    apiKey: 'AIzaSyBUfIAifaghDqu7ZUO5RC83tDMHplIzo7g',
    appId: '1:336376050891:web:41a02f392ecdacfd0e574e',
    messagingSenderId: '336376050891',
    projectId: 'jewelry-e-commerce-6377b',
    authDomain: 'jewelry-e-commerce-6377b.firebaseapp.com',
    storageBucket: 'jewelry-e-commerce-6377b.appspot.com',
    measurementId: 'G-0BZR99R0TH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9jW0SFK0ppb3Y9lWcqgx9lH6A3X6k6vI',
    appId: '1:336376050891:android:9d9ed69490538cc50e574e',
    messagingSenderId: '336376050891',
    projectId: 'jewelry-e-commerce-6377b',
    storageBucket: 'jewelry-e-commerce-6377b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDG6ggOY91xiCS3oPdiFiUc-x4x4qouQpQ',
    appId: '1:336376050891:ios:350ffe8ec3664dd00e574e',
    messagingSenderId: '336376050891',
    projectId: 'jewelry-e-commerce-6377b',
    storageBucket: 'jewelry-e-commerce-6377b.appspot.com',
    iosClientId: '336376050891-q031im1rd7r4pbbog5lbl6poub6n0eed.apps.googleusercontent.com',
    iosBundleId: 'com.example.jewelryECommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDG6ggOY91xiCS3oPdiFiUc-x4x4qouQpQ',
    appId: '1:336376050891:ios:350ffe8ec3664dd00e574e',
    messagingSenderId: '336376050891',
    projectId: 'jewelry-e-commerce-6377b',
    storageBucket: 'jewelry-e-commerce-6377b.appspot.com',
    iosClientId: '336376050891-q031im1rd7r4pbbog5lbl6poub6n0eed.apps.googleusercontent.com',
    iosBundleId: 'com.example.jewelryECommerce',
  );
}