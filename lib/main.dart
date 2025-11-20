// import 'package:flutter/material.dart';
// import 'app.dart';

// void main() {
//   runApp(const Swim360App());
// }



import 'package:flutter/material.dart';
import 'package:swim360/screens/home/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swim 360',
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}

