import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'screens/splash_screen.dart';
import 'screens/error_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 1. Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // 2. Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 3. Setup FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  


  // 3. Custom Error Widget (Replace Red Screen)
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // Determine if we should show the custom screen or default (in debug)
    bool inDebug = kDebugMode;
    if (inDebug) {
       return ErrorWidget(details.exception);
    }
    return CustomErrorScreen(errorDetails: details);
  };

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer? _backgroundTimer;
  static const _backgroundTimeout = Duration(seconds: 30); // Changed to 30 seconds for testing

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _backgroundTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App went to background - start timer
      _backgroundTimer?.cancel();
      _backgroundTimer = Timer(_backgroundTimeout, () {
        // Close the app after 5 minutes
        debugPrint("App has been in background for 5 minutes. Closing...");
        SystemNavigator.pop(); // Close app on Android
      });
    } else if (state == AppLifecycleState.resumed) {
      // App came back to foreground - cancel timer
      _backgroundTimer?.cancel();
      debugPrint("App resumed, background timer cancelled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S.D. JEWELS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Start with Splash
    );
  }
}
