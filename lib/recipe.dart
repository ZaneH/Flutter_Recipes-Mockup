class Recipe {
  final String name;
  final int likes;
  final String image;
  final String description;
  final List<dynamic> materials;

  static Recipe fromMap(Map<String, dynamic> data) {
    return Recipe(
      name: data['name'],
      likes: data['likes'],
      image: data['image'],
      description: data['description'],
      materials: data['materials'].map((mat) {
        return Map<String, String>()..addAll({
          "name": mat['name'],
          "amount": mat['amount'],
        });
      }).toList(),
    );
  }

  Recipe({
    this.name,
    this.likes,
    this.image,
    this.description,
    this.materials,
  });
}
