import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
    apiKey: 'AIzaSyCd7Cw8qrG6dWt4qGKeOu5m3li9BJDnmHw',
    appId: '1:283193005219:web:a95c8107f5f3aac8a09b16',
    messagingSenderId: '283193005219',
    projectId: 'spot-training',
    authDomain: 'spot-training.firebaseapp.com',
    storageBucket: 'spot-training.firebasestorage.app',
    measurementId: 'G-WZV7D48GEE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTR8wXfImqNH5h6b3VmyvAPnZLWrzHwGE',
    appId: '1:283193005219:android:6ca97f831e2e15f7a09b16',
    messagingSenderId: '283193005219',
    projectId: 'spot-training',
    storageBucket: 'spot-training.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDyjjvKfNDm4YR8qrHVF7h-L1LMVemSGo',
    appId: '1:283193005219:ios:09c558b24f36de34a09b16',
    messagingSenderId: '283193005219',
    projectId: 'spot-training',
    storageBucket: 'spot-training.firebasestorage.app',
    iosBundleId: 'com.aisports.aiSportsTraining',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDyjjvKfNDm4YR8qrHVF7h-L1LMVemSGo',
    appId: '1:283193005219:ios:09c558b24f36de34a09b16',
    messagingSenderId: '283193005219',
    projectId: 'spot-training',
    storageBucket: 'spot-training.firebasestorage.app',
    iosBundleId: 'com.aisports.aiSportsTraining',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCd7Cw8qrG6dWt4qGKeOu5m3li9BJDnmHw',
    appId: '1:283193005219:web:4e2beeeda374ed10a09b16',
    messagingSenderId: '283193005219',
    projectId: 'spot-training',
    authDomain: 'spot-training.firebaseapp.com',
    storageBucket: 'spot-training.firebasestorage.app',
    measurementId: 'G-RJS19LCT13',
  );
}
