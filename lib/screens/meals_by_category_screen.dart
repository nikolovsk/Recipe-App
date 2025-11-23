import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_details_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService apiService = ApiService();

  List<MealSummary> meals = [];
  List<MealSummary> filteredMeals = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final data = await apiService.loadMealsByCategory(widget.category);
    setState(() {
      meals = data;
      filteredMeals = data;
      loading = false;
    });
  }

  void filterMeals(String keyword) {
    setState(() {
      filteredMeals = meals.where((m) {
        return m.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
          children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: filterMeals,
                  decoration: const InputDecoration(
                    hintText: "Search meals...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            Expanded(
              child: filteredMeals.isEmpty
                  ? const Center(
                child: Text(
                  "No meals found",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredMeals.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MealCard(
                      meal: filteredMeals[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealDetailsScreen(
                              mealId: filteredMeals[index].id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
      ),
    );
  }
}
