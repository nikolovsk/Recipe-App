import 'package:flutter/material.dart';
import '../models/meal_summary.dart';

class MealCard extends StatefulWidget {
  final MealSummary meal;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        elevation: 6,
        color: Colors.orange.shade50,
        shadowColor: Colors.orangeAccent.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                widget.meal.thumbnail,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.meal.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade500,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      "View details",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      widget.meal.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.meal.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: widget.onFavoriteToggle,
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