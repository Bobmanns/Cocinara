class Ingredient {
  // ingredient name
  final String ingredientName;
  // ingredient quantity
  final String? ingredientQuantity;

  const Ingredient(this.ingredientName, this.ingredientQuantity);

// hoe krijg ik de ingredienten uit de database?
}

class Recipe {
  final List<Ingredient> ingredients;
  final String name;
  final List<String> preparation;

  const Recipe(this.ingredients, this.name, this.preparation);
}
