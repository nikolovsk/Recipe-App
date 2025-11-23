import 'package:flutter/material.dart';
import '../models/meal_detail.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RandomMealScreen extends StatefulWidget {
  const RandomMealScreen({super.key});

  @override
  State<RandomMealScreen> createState() => _RandomMealScreenState();
}

class _RandomMealScreenState extends State<RandomMealScreen> {
  final ApiService apiService = ApiService();
  MealDetail? meal;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRandomMeal();
  }

  Future<void> loadRandomMeal() async {
    final data = await apiService.loadRandomMeal();
    setState(() {
      meal = data;
      loading = false;
    });
  }

  Future<void> openYoutube() async {
    if (meal == null || meal!.youtubeUrl.isEmpty) return;

    final url = Uri.parse(meal!.youtubeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Random Meal of the Day",
          style: TextStyle(
            fontWeight: FontWeight.w900
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(meal!.thumbnail),
            ),

            const SizedBox(height: 16),

            Text(
              meal!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Category: ${meal!.category}\nArea: ${meal!.area}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown.shade600,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: meal!.ingredients
                  .map((i) => Text("• $i",
                  style: const TextStyle(fontSize: 16)))
                  .toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              "Instructions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              meal!.instructions,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            if (meal!.youtubeUrl.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => openYoutube,
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text("Watch on YouTube"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
