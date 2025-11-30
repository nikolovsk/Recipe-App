import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class ApiService {
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  Future<List<Category>> loadCategories() async {
    final response = await http.get(Uri.parse("${baseUrl}categories.php"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List categoriesJson = data["categories"];
      return categoriesJson.map((c) => Category.fromJson(c)).toList();
    }

    return [];
  }

  Future<List<MealSummary>> loadMeals() async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s='));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'] as List;
      return data.map((json) => MealSummary.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<MealSummary>> loadMealsByCategory(String category) async {
    final encodedCategory = Uri.encodeComponent(category);
    final response = await http.get(Uri.parse("${baseUrl}filter.php?c=$encodedCategory"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List mealsJson = data["meals"];
      return mealsJson.map((m) => MealSummary.fromJson(m)).toList();
    }

    return [];
  }

  Future<List<MealSummary>> searchMeals(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse("${baseUrl}search.php?s=$query"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["meals"] == null) return [];

        final List mealsJson = data["meals"];
        return mealsJson.map((m) => MealSummary.fromJson(m)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<MealDetail?> loadMealDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}lookup.php?i=$id"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["meals"] == null) return null;

        return MealDetail.fromJson(data["meals"][0]);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  Future<MealDetail?> loadRandomMeal() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}random.php"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["meals"] == null) return null;

        return MealDetail.fromJson(data["meals"][0]);
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
