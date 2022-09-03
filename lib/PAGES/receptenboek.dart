import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_cocinara/Classes/notification.dart';
//import 'package:wakelock/wakelock.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import '../Classes/recepten.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Staggered Gridview (zoals pinterest) met verschillende Recepten die mensen kunnen toevoegen aan hun kookboek.
// to do: Filter
class Receptenboek extends StatefulWidget {
  const Receptenboek({super.key});

  @override
  State<Receptenboek> createState() => _ReceptenboekState();
}

class _ReceptenboekState extends State<Receptenboek> {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  List<Recipe> recipes = [];

  Future<List<Recipe>> _loadRecipes() async {
    var recipesSnapshot = await db.collection('recipes').get();
    
    List<Recipe> recipes = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> d in recipesSnapshot.docs) {
      Recipe r = await Recipe.fromJSON(d.data());
      recipes.add(r);
    }

    return recipes;
  }

  @override
  Widget build(BuildContext bronContext) {
    return FutureBuilder(
          future: _loadRecipes(),
          builder: (bronContext, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text(
                  "Er is een error: ${snapshot.error} met data ${snapshot.data}");
            }

            List<Recipe> recipes = snapshot.data! as List<Recipe>;
            return MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              itemBuilder: (context, index) {
                Recipe r = recipes[index % recipes.length];
                return FutureBuilder(
                    future:
                        storage.ref().child("recipes/${r.imageUrl}").getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        Uint8List imgData = snapshot.data as Uint8List;

                        return Card(
                          elevation: 0.0,
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      recipePage(context, r, imgData, bronContext)));

                              //Wakelock.disable();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  child: Hero(
                                    tag: imgData.hashCode,
                                    child: Image.memory(imgData),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text(r.name)),
                                ),
                              ]
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Text(
                            "Astaghfirullah er is iets fout gegaan, ${snapshot.error}");
                      }

                      return const Card(
                        elevation: 0.0,
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: SizedBox(
                              height: 30, 
                              width: 30,
                              child: CircularProgressIndicator())
                          ),
                        ),
                      );
                    });
              },
            );
          });
  }
}

class IngredientTab extends StatefulWidget {
  final List<Ingredient> ingredients;
  final BuildContext notificatieContext;

  const IngredientTab(this.ingredients, this.notificatieContext, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
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
                title: Text(
                    "${widget.ingredients[index].ingr.name} (${widget.ingredients[index].quantity})"),
                onChanged: (newVal) {
                  setState(() {
                    checked[index] = newVal ?? false;
                  });
                })
              )..add(
                ElevatedButton.icon(
                  onPressed: () {
                    List<Ingredient> toeTeVoegenIngredienten = [];
                    for (int i = 0; i < checked.length; i++ ) {
                      if (checked[i]) {
                        toeTeVoegenIngredienten.add(widget.ingredients[i]);
                      }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ingrediënten toegevoegd"),)
                    );

                    var notificatie = BoodschappenNotification(toeTeVoegenIngredienten);
                    notificatie.dispatch(widget.notificatieContext);
                  },
                  icon: const Icon(Icons.add_shopping_cart), 
                  label: const Text("Voeg ingrediënten toe"))
              )
            ),
    );
  }
}

class PreparationTab extends StatefulWidget {
  final List<String> preparation;

  const PreparationTab(this.preparation, {Key? key}) : super(key: key);

  @override
  State<PreparationTab> createState() => PreparationTabState();
}

class PreparationTabState extends State<PreparationTab> {
  final ValueNotifier<int> currentIndex = ValueNotifier(0);
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: PageView.builder(
              itemBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(widget.preparation[index])),
                ),
              ),
              controller: pageController,
              itemCount: widget.preparation.length,
              onPageChanged: (value) {
                currentIndex.value = value;
              },
            ),
          ),
          const SizedBox(height: 16.0),
          CirclePageIndicator(
              currentPageNotifier: currentIndex,
              itemCount: widget.preparation.length)
        ],
      ),
    );
  }
}

Widget recipePage(BuildContext context, Recipe r, Uint8List imgData, BuildContext notificatieContext) {
  return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              Hero(
                tag: imgData.hashCode,
                child: Image.memory(
                  imgData,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                )
            ]
          ),
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
              IngredientTab(r.ingredients, notificatieContext),
              PreparationTab(r.preparation)
            ]),
          ),
        ],
      )
    )
  );
}
