class Ingredient {
  // ingredient name
  final String ingredientName;
  // ingredient quantity
  final String? ingredientQuantity;

  const Ingredient(this.ingredientName, this.ingredientQuantity);

  static Ingredient fromJSON(Map<String, dynamic> json) {
    return Ingredient(json["ingredient_name"], json["ingredient_quantity"]);
  }
}

class Recipe {
  final List<Ingredient> ingredients;
  final String name;
  final List<String> preparation;
  final String imageUrl;

  const Recipe(this.ingredients, this.name, this.preparation, this.imageUrl);

  static Recipe fromJSON(Map<String, dynamic> json) {
    String recipeName = json["name"];

    var recipePreparationRaw = json["preparation"];
    List<String> recipePreparation = [];

    for (var i in recipePreparationRaw) {
      recipePreparation.add(i as String);
    }

    List<dynamic> recipeIngredientsRaw = json["ingredients"];
    List<Ingredient> recipeIngredients = [];

    for (Map<String, dynamic> i in recipeIngredientsRaw) {
      recipeIngredients.add(Ingredient.fromJSON(i));
    }

    String recipeImageUrl = json["image_url"] ?? "";
    return Recipe(
        recipeIngredients, recipeName, recipePreparation, recipeImageUrl);
  }
}
