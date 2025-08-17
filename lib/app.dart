import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

class Swim360App extends StatelessWidget {
  const Swim360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Swim360',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}