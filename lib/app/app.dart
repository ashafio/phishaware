import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class PhishAwareApp extends StatelessWidget {
  const PhishAwareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhishAware',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.home,
    );
  }
}