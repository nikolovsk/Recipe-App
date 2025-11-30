class MealSummary {
  String id;
  String name;
  String thumbnail;
  bool isFavorite;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.isFavorite = false,
  });

  MealSummary.fromJson(Map<String, dynamic> data)
      : id = data['idMeal'],
        name = data['strMeal'],
        thumbnail = data['strMealThumb'],
        isFavorite = false;

  Map<String, dynamic> toJson() => {
    'idMeal': id,
    'strMeal': name,
    'strMealThumb': thumbnail,
    'isFavorite': isFavorite,
  };
}
