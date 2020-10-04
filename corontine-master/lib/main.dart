import 'dart:async';
import 'package:firebase_analytics/observer.dart';
import 'auth_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corontine Diary',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseManager.getAnalytics())
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: 'Montserrat',
        accentColor: ThemeConstants.primaryColor,
        primarySwatch: Colors.grey,
      ),
      home: LoginPage(),
    );
  }
}
