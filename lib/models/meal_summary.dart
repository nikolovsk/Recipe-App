class MealSummary {
  String id;
  String name;
  String thumbnail;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  MealSummary.fromJson(Map<String, dynamic> data)
      : id = data['idMeal'],
        name = data['strMeal'],
        thumbnail = data['strMealThumb'];

  Map<String, dynamic> toJson() => {
    'idMeal': id,
    'strMeal': name,
    'strMealThumb': thumbnail,
  };
}
