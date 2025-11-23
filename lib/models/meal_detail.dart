class MealDetail {
  String id;
  String name;
  String category;
  String area;
  String instructions;
  String thumbnail;
  String youtubeUrl;
  List<String> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.ingredients,
    required this.youtubeUrl,
  });

  MealDetail.fromJson(Map<String, dynamic> data)
      : id = data['idMeal'],
        name = data['strMeal'],
        category = data['strCategory'],
        area = data['strArea'],
        instructions = data['strInstructions'],
        thumbnail = data['strMealThumb'],
        youtubeUrl = data['strYoutube'],
        ingredients = List.generate(
          20,
              (i) => data['strIngredient${i + 1}'],
        )
            .where((value) => value != null && value.toString().trim().isNotEmpty)
            .map((value) => value.toString())
            .toList();

  Map<String, dynamic> toJson() => {
    'idMeal': id,
    'strMeal': name,
    'strCategory': category,
    'strArea': area,
    'strInstructions': instructions,
    'strMealThumb': thumbnail,
    'strYoutube': youtubeUrl,
    'ingredients': ingredients,
  };
}
