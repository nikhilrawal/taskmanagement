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
    apiKey: 'AIzaSyCNXt_4tYoXtRhtyCx9hzVi_8m40zFnKTk',
    appId: '1:380403665380:web:50331ff5f3620f248fdff1',
    messagingSenderId: '380403665380',
    projectId: 'snappywalls-99f8b',
    authDomain: 'snappywalls-99f8b.firebaseapp.com',
    storageBucket: 'snappywalls-99f8b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnQ_l1vgVf5_PNoSCg32Ow8GfiEovIZL8',
    appId: '1:380403665380:android:1eee4ad1c5ff830f8fdff1',
    messagingSenderId: '380403665380',
    projectId: 'snappywalls-99f8b',
    storageBucket: 'snappywalls-99f8b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAo3ppZ55E3uJ15wBBsZqhqhseBm6TKJtE',
    appId: '1:380403665380:ios:392fcc25bebcd9438fdff1',
    messagingSenderId: '380403665380',
    projectId: 'snappywalls-99f8b',
    storageBucket: 'snappywalls-99f8b.appspot.com',
    iosBundleId: 'com.example.taskmanager',
  );
}
