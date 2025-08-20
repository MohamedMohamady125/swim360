import 'package:flutter/material.dart';
import './screens/auth/signup_screen.dart';  // Your existing login screen
import './screens/auth/login_screen.dart';  // Your existing create account screen

class Swim360App extends StatelessWidget {
  const Swim360App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swim 360',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}