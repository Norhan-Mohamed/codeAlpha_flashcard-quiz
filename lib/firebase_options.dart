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
    apiKey: 'AIzaSyCSAKRKp1ZREqujC3rJtpjnzfeCNsdXk04',
    appId: '1:152001766682:web:e4663580a3c02179bd78a3',
    messagingSenderId: '152001766682',
    projectId: 'flashcard-quiz-f67c2',
    authDomain: 'flashcard-quiz-f67c2.firebaseapp.com',
    storageBucket: 'flashcard-quiz-f67c2.appspot.com',
    measurementId: 'G-4Q2L4EZ015',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvCSsxzvpBqnvtv_bbh_iLIuj8wjGo9UQ',
    appId: '1:152001766682:android:6ae38ce030d136c9bd78a3',
    messagingSenderId: '152001766682',
    projectId: 'flashcard-quiz-f67c2',
    storageBucket: 'flashcard-quiz-f67c2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPFx8NW7_geXBqXjLH1hmOxQWrYWvb_48',
    appId: '1:152001766682:ios:62af37776f601043bd78a3',
    messagingSenderId: '152001766682',
    projectId: 'flashcard-quiz-f67c2',
    storageBucket: 'flashcard-quiz-f67c2.appspot.com',
    iosBundleId: 'com.example.flashcardquizapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPFx8NW7_geXBqXjLH1hmOxQWrYWvb_48',
    appId: '1:152001766682:ios:62af37776f601043bd78a3',
    messagingSenderId: '152001766682',
    projectId: 'flashcard-quiz-f67c2',
    storageBucket: 'flashcard-quiz-f67c2.appspot.com',
    iosBundleId: 'com.example.flashcardquizapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCSAKRKp1ZREqujC3rJtpjnzfeCNsdXk04',
    appId: '1:152001766682:web:c882468120dd61f7bd78a3',
    messagingSenderId: '152001766682',
    projectId: 'flashcard-quiz-f67c2',
    authDomain: 'flashcard-quiz-f67c2.firebaseapp.com',
    storageBucket: 'flashcard-quiz-f67c2.appspot.com',
    measurementId: 'G-C3B7TKTGMB',
  );
}
