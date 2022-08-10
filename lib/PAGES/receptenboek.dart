import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Classes/recepten.dart';

// Staggered Gridview (zoals pinterest) met verschillende Recepten die mensen kunnen toevoegen aan hun kookboek.
// to do: Flter
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
        recipeIngredients.add(Ingredient(i["ingredient_name"], i["ingredient_quantity"]));
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
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.arrow_back_ios),
        // ),
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
            return Text("Er is een error: ${snapshot.error} met data ${snapshot.data}");
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
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => recipePage(context, r))
                        );
                      },
                      child: SizedBox(
                        height: 50, 
                        child: Center(
                          child: Text(r.name)
                        )
                      ),
                    ),
                  );
                })
              ),
            )
          );
        }
      ),
    );
  }
}

// Foto's van de recepten
Widget buildImageCard(int index) => Card(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0),
  ),
  child: Container(
      margin: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          'https://source.unsplash.com/random?sig=$index',
          fit: BoxFit.cover,
        ),
      )),
);

Widget recipePage(BuildContext context, Recipe r) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.amber,
            child: const AspectRatio(aspectRatio: 16.0/9.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text("Hoofdgerecht"),
              Icon(Icons.schedule),
              Text("20 minuten"),
              Icon(Icons.person),
              Text("4 personen")
            ],
          ),
          const TabBar(tabs: [
            Tab(text: "Ingrediënten",),
            Tab(text: "Bereiding",),
          ]),
          TabBarView(children: [
            Wrap(
              children: List.generate(r.ingredients.length, (index) {
                Ingredient i = r.ingredients[index];
                return Chip(label: Text("${i.ingredientQuantity} ${i.ingredientName}"),);
              }),
            ),
            Text(r.preparation.join("/"))
          ]),
          

        ],
      )
    )
  );
}