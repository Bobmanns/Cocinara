import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  // ingredient name
  final MetaIngredient ingr;
  // ingredient quantity
  final String? quantity;

  const Ingredient(this.ingr, this.quantity);

  static Future<Ingredient> fromJSON(Map<String, dynamic> json) async {
    MetaIngredient ingr = MetaIngredient.fromJSON((await FirebaseFirestore.instance.doc(json["ref"]).get()).data()!);
    return Ingredient(ingr, json["quantity"]);
  }
}

class MetaIngredient {
  final String name;
  final String type;

  const MetaIngredient(this.name, this.type);

  static MetaIngredient fromJSON(Map<String, dynamic> json) {
    return MetaIngredient(json["name"], json["type"]);
  }
}

class Recipe {
  final List<Ingredient> ingredients;
  final String name;
  final List<String> preparation;
  final String imageUrl;

  const Recipe(this.ingredients, this.name, this.preparation, this.imageUrl);

  static Future<Recipe> fromJSON(Map<String, dynamic> json) async {
    String recipeName = json["name"];

    var recipePreparationRaw = json["preparation"];
    List<String> recipePreparation = [];

    for (var i in recipePreparationRaw) {
      recipePreparation.add(i as String);
    }

    List<dynamic> recipeIngredientsRaw = json["ingredients"];
    List<Ingredient> recipeIngredients = [];

    for (Map<String, dynamic> i in recipeIngredientsRaw) {
      recipeIngredients.add(await Ingredient.fromJSON(i));
    }

    String recipeImageUrl = json["image_url"] ?? "";
    return Recipe(
        recipeIngredients, recipeName, recipePreparation, recipeImageUrl);
  }
}