import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';
import '../services/api_service.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealId;

  const MealDetailsScreen({super.key, required this.mealId});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  final ApiService apiService = ApiService();

  MealDetail? meal;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  Future<void> loadMeal() async {
    final data = await apiService.loadMealDetail(widget.mealId);
    setState(() {
      meal = data;
      loading = false;
    });
  }

  Future<void> openYoutube(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text(
            "Meal Details",
            style: TextStyle(
                fontWeight: FontWeight.w900
            )
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : meal == null
          ? const Center(child: Text("Meal not found"))
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
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Category: ${meal!.category}\nArea: ${meal!.area}",
              style: TextStyle(
                fontSize: 16,
                  color: Colors.brown.shade600
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Ingredients",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...meal!.ingredients.map(
                  (ing) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("• $ing",
                    style: const TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Instructions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              meal!.instructions,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 20),

            if (meal!.youtubeUrl.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
                onPressed: () => openYoutube(meal!.youtubeUrl),
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
