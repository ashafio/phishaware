import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../services/analytics_service.dart';
import '../../services/experiment_service.dart';


class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen>
    with SingleTickerProviderStateMixin {
  int countdown = 5;
  DateTime? startTime;

  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  late String style;
  late String title;
  late String message;
  late Color color;
  late IconData icon;

  @override
  void initState() {
    super.initState();

    startTime = DateTime.now();

    // 🎯 Get experiment style
    style = ExperimentService.getWarningStyle();

    _setupStyle();

    // 🔥 Log warning shown
    AnalyticsService.logEvent("warning_shown", params: {
      "style": style,
    });

    // 🎨 Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    startTimer();
  }

  void _setupStyle() {
    switch (style) {
      case "scary":
        title = "⚠️ Dangerous Website!";
        message =
        "This site may steal your passwords, banking details, or personal data.";
        color = Colors.red;
        icon = Icons.dangerous;
        break;

      case "educational":
        title = "Think Before You Continue";
        message =
        "Phishing sites mimic trusted services. Always verify the URL carefully.";
        color = Colors.blue;
        icon = Icons.school;
        break;

      default:
        title = "Security Warning";
        message = "This link may be unsafe. Proceed with caution.";
        color = Colors.orange;
        icon = Icons.warning_amber_rounded;
    }
  }

  void startTimer() async {
    while (countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => countdown--);
    }
  }

  int getDecisionTime() {
    return DateTime.now().difference(startTime!).inSeconds;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: color.withOpacity(0.05),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔥 Animated Icon
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15),
                  ),
                  child: Icon(icon, size: 80, color: color),
                ),
              ),

              const SizedBox(height: 30),

              // 🔥 TITLE
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),

              const SizedBox(height: 15),

              // 🔥 MESSAGE
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),

              const SizedBox(height: 30),

              // ⏳ COUNTDOWN
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  countdown > 0
                      ? "Wait $countdown seconds before continuing..."
                      : "You may proceed now",
                  key: ValueKey(countdown),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: countdown > 0 ? Colors.grey : color,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🔘 CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: countdown > 0
                      ? null
                      : () async {
                    final time = getDecisionTime();

                    await AnalyticsService.logEvent(
                      "continued_after_warning",
                      params: {
                        "decision_time_sec": time,
                        "style": style,
                      },
                    );

                    Navigator.pushReplacementNamed(
                      context,
                      AppRouter.result,
                      arguments: result,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔘 CANCEL BUTTON
              TextButton(
                onPressed: () async {
                  final time = getDecisionTime();

                  await AnalyticsService.logEvent(
                    "cancelled_after_warning",
                    params: {
                      "decision_time_sec": time,
                      "style": style,
                    },
                  );

                  Navigator.pop(context);
                },
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}