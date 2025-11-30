import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_card.dart';
import 'meal_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<MealSummary> favoriteMeals;
  final void Function(List<MealSummary> updatedFavorites) onFavoritesChanged;

  const FavoritesScreen({
    super.key,
    required this.favoriteMeals,
    required this.onFavoritesChanged,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<MealSummary> localFavorites;

  @override
  void initState() {
    super.initState();
    localFavorites = List.from(widget.favoriteMeals);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite recipes'),
      ),
      body: localFavorites.isEmpty
          ? const Center(
        child: Text('No favorite recipes yet', style: TextStyle(fontSize: 16)),
      )
          : ListView.builder(
        itemCount: localFavorites.length,
        itemBuilder: (context, index) {
          return MealCard(
            meal: localFavorites[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealDetailsScreen(
                    mealId: localFavorites[index].id,
                  ),
                ),
              );
            },
            onFavoriteToggle: () {
              setState(() {
                localFavorites[index].isFavorite =
                !localFavorites[index].isFavorite;

                if (!localFavorites[index].isFavorite) {
                  localFavorites.removeAt(index);
                }

                widget.onFavoritesChanged(localFavorites);
              });
            },
          );
        },
      ),
    );
  }
}

