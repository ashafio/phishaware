
import 'package:flutter/material.dart';

import '../../experiment/services/analytics_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool logged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!logged) {
      final result =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      AnalyticsService.logResultViewed(result["prediction"]);
      logged = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final result =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final isPhishing = result["prediction"] == 1;
    final confidence = (result["confidence"] * 100).toStringAsFixed(2);

    final color = isPhishing ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isPhishing ? "Phishing Detected" : "Safe Website",
              style: TextStyle(fontSize: 24, color: color),
            ),
            const SizedBox(height: 10),
            Text("Confidence: $confidence%"),
          ],
        ),
      ),
    );
  }
}