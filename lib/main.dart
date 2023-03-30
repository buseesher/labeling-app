import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:googleapis_auth/auth_browser.dart' as auth;

import 'firebase_options.dart';
import 'home.dart';
import 'profile_page.dart';
import 'test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labeling App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // ignore: prefer_const_constructors
        '/': (context) => Home(),
        // ignore: prefer_const_constructors
        '/profile': (context) => ProfilePage(),
        '/test': (context) => TestPage(),
      },
    );
  }
}
