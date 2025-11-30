import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'favorites_screen.dart';
import 'meals_by_category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Category> categories = [];
  List<Category> filtered = [];
  bool loading = true;
  List<MealSummary> _meals = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final data = await apiService.loadMeals();
    setState(() {
      _meals = data;
    });
  }

  Future<void> loadCategories() async {
    final data = await apiService.loadCategories();
    setState(() {
      categories = data;
      filtered = data;
      loading = false;
    });
  }

  void filterCategories(String query) {
    setState(() {
      filtered = categories
          .where((c) =>
          c.name.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meal Categories",
          style: TextStyle(
              fontWeight: FontWeight.w900
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/random");
            },
            icon: const Icon(Icons.shuffle, color: Colors.white,),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteMeals: _meals.where((meal) => meal.isFavorite).toList(),
                    onFavoritesChanged: (updatedFavorites) {
                      for (var meal in _meals) {
                        meal.isFavorite = updatedFavorites.any((fav) => fav.id == meal.id);
                      }
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search categories...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: filterCategories,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return CategoryCard(
                  category: filtered[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealsByCategoryScreen(
                          category: filtered[index].name,
                          favoriteMeals: _meals,
                          onFavoriteChanged: (meal) {
                            final existingIndex = _meals.indexWhere((m) => m.id == meal.id);
                            if (existingIndex != -1) {
                              _meals[existingIndex].isFavorite = meal.isFavorite;
                            } else {
                              _meals.add(meal);
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
