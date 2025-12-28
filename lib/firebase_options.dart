import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return web; // Use Web config for Windows for now
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAkfYigmxUuOGZYrTYGawB2xFTVgDRvk7o',
    appId: '1:1066317379834:android:74baf5c752f5a6838db143', 
    messagingSenderId: '1066317379834',
    projectId: 'sd-jewels',
    databaseURL: 'https://sd-jewels-default-rtdb.firebaseio.com/',
    storageBucket: 'sd-jewels.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkfYigmxUuOGZYrTYGawB2xFTVgDRvk7o',
    appId: '1:1066317379834:android:74baf5c752f5a6838db143',
    messagingSenderId: '1066317379834',
    projectId: 'sd-jewels',
    databaseURL: 'https://sd-jewels-default-rtdb.firebaseio.com/',
    storageBucket: 'sd-jewels.firebasestorage.app',
  );
}
