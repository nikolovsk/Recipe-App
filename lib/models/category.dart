class Category {
  String id;
  String name;
  String thumbnail;
  String description;

  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  Category.fromJson(Map<String, dynamic> data)
      : id = data['idCategory'],
        name = data['strCategory'],
        thumbnail = data['strCategoryThumb'],
        description = data['strCategoryDescription'];

  Map<String, dynamic> toJson() => {
    'idCategory': id,
    'strCategory': name,
    'strCategoryThumb': thumbnail,
    'strCategoryDescription': description,
  };
}

