import 'package:flutter/material.dart';
import '../features/experiment/presentation/widgets/warning_popup.dart';
import '../features/presentation/screens/home_screen.dart';
import '../features/presentation/screens/result_screen.dart';

class AppRouter {
  static const String home = "/";
  static const String result = "/result";
  static const String warning = "/warning";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case warning:
        return MaterialPageRoute(
          builder: (_) => const WarningScreen(),
          settings: settings,
        );

      case result:
        final args = settings.arguments;

        // ✅ SAFE NULL CHECK
        if (args == null || args is! Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text("No result data received")),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => const ResultScreen(),
          settings: RouteSettings(arguments: args), // ✅ pass correctly
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }
}