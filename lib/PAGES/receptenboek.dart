import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Classes/recepten.dart';

// Staggered Gridview (zoals pinterest) met verschillende Recepten die mensen kunnen toevoegen aan hun kookboek.
// to do: Filter
class Receptenboek extends StatefulWidget {
  const Receptenboek({super.key});

  @override
  State<Receptenboek> createState() => _ReceptenboekState();
}

class _ReceptenboekState extends State<Receptenboek> {
  var db = FirebaseFirestore.instance;

  List<Recipe> recipes = [];

  Future<List<Recipe>> _loadRecipes() async {
    var recipesSnapshot = await db.collection('recipes').get();
    var workingList = recipesSnapshot.docs.map((e) {
      Map<String, dynamic> data = e.data();
      String recipeName = data["name"];

      var recipePreparationRaw = data["preparation"];
      List<String> recipePreparation = [];

      for (var i in recipePreparationRaw) {
        recipePreparation.add(i as String);
      }

      List<dynamic> recipeIngredientsRaw = data["ingredients"];
      List<Ingredient> recipeIngredients = [];

      for (Map<String, dynamic> i in recipeIngredientsRaw) {
        recipeIngredients
            .add(Ingredient(i["ingredient_name"], i["ingredient_quantity"]));
      }

      // print(recipeIngredients);
      // print(recipeName);
      // print(recipePreparation);

      return Recipe(recipeIngredients, recipeName, recipePreparation);
    });

    return workingList.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Receptenboek'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _loadRecipes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text(
                  "Er is een error: ${snapshot.error} met data ${snapshot.data}");
            }

            // return MasonryGridView.count(
            //   crossAxisCount: 2,
            //   mainAxisSpacing: 0,
            //   crossAxisSpacing: 0,
            //   itemBuilder: (context, index) {
            //     return buildImageCard(index);
            //   },

            // );
            List<Recipe> recipes = snapshot.data! as List<Recipe>;
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(recipes.length, (index) {
                    Recipe r = recipes[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => recipePage(context, r)));
                        },
                        child: SizedBox(
                            height: 50, child: Center(child: Text(r.name))),
                      ),
                    );
                  })),
            ));
          }),
    );
  }
}

class IngredientTab extends StatefulWidget {
  final List<Ingredient> ingredients;

  const IngredientTab(this.ingredients, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() =>
      IngredientTabState(List.filled(ingredients.length, true));
}

class IngredientTabState extends State<IngredientTab> {
  List<bool> checked = [];

  IngredientTabState(this.checked);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: List.generate(
              widget.ingredients.length,
              (index) => CheckboxListTile(
                  value: checked[index],
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(widget.ingredients[index].ingredientName),
                  onChanged: (newVal) {
                    setState(() {
                      checked[index] = newVal ?? false;
                    });
                  }))),
    );
  }
}

// add back button
Widget recipePage(BuildContext context, Recipe r) {
  return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 120, child: Container(color: Colors.amber[900])),
          Text(
            r.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("Hoofdgerecht"),
                Icon(Icons.schedule),
                Text("20 minuten"),
                Icon(Icons.person),
                Text("4 personen")
              ],
            ),
          ),
          TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2.0)),
              labelColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(
                  text: "Ingrediënten",
                ),
                Tab(
                  text: "Bereiding",
                ),
              ]),
          Flexible(
            child: TabBarView(children: [
              IngredientTab(r.ingredients),
              Text(r.preparation.join("/"))
            ]),
          ),
        ],
      )));
}
