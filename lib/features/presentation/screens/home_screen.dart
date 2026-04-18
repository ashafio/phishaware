import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../app/router.dart';
import '../../experiment/services/analytics_service.dart';
import '../../experiment/services/experiment_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController urlController = TextEditingController();
  late ApiClient apiClient;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    apiClient = ApiClient(ApiConstants.BASE_URL);
    final group = ExperimentService.getGroup();

    AnalyticsService.logEvent("experiment_assigned", params: {
      "group": group,
    });
  }

  Future<void> analyzeUrl() async {
    final url = urlController.text.trim();

    if (url.isEmpty || !url.startsWith("http")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid URL")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 🔥 LOG EVENT
      await AnalyticsService.logUrlSubmitted(url);

      final result = await apiClient.post("/predicturl", {
        "url": url,
      });

      final isWarningEnabled = ExperimentService.isWarningEnabled();

      if (!mounted) return;

      if (isWarningEnabled) {
        Navigator.pushNamed(
          context,
          AppRouter.warning,
          arguments: result,
        );
      } else {
        Navigator.pushNamed(
          context,
          AppRouter.result,
          arguments: result,
        );
      }

      Navigator.pushNamed(
        context,
        AppRouter.warning,
        arguments: result,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PhishAware"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Text(
              "Phishing Detection System",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              "Enter a URL to analyze its safety",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            TextField(
              controller: urlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                hintText: "https://example.com",
                prefixIcon: Icon(Icons.link),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : analyzeUrl,
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text("Analyze URL"),
              ),
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue.withOpacity(0.1),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "This system uses Machine Learning to detect phishing websites.",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}