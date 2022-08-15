import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:wakelock/wakelock.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
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
  var storage = FirebaseStorage.instance;

  List<Recipe> recipes = [];

  Future<List<Recipe>> _loadRecipes() async {
    var recipesSnapshot = await db.collection('recipes').get();
    return recipesSnapshot.docs.map((e) => Recipe.fromJSON(e.data())).toList();
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
                    return FutureBuilder(
                      future: storage
                          .ref()
                          .child("recipes/${r.imageUrl}")
                          .getData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.done &&
                            snapshot.hasData) {
                          Uint8List imgData = snapshot.data as Uint8List;

                          return Card(
                            child: InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            recipePage(context, r, imgData)));

                                //Wakelock.disable();
                              },
                              child: SizedBox(
                                height: 50,
                                child: Stack(children: [
                                  Hero(
                                    tag: imgData.hashCode,
                                    child: Image.memory(imgData),
                                  ),
                                  Center(child: Text(r.name)),
                                ]),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text(
                              "Astaghfirullah er is iets fout gegaan, ${snapshot.error}");
                        }

                        return const CircularProgressIndicator();
                      }
                    );
                  }
                )
              ),
            )
          );
        }
      ),
    );
  }
}

class IngredientTab extends StatefulWidget {
  final List<Ingredient> ingredients;

  const IngredientTab(this.ingredients, {Key? key}) : super(key: key);

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
                      "${widget.ingredients[index].ingredientName} (${widget.ingredients[index].ingredientQuantity})"),
                  onChanged: (newVal) {
                    setState(() {
                      checked[index] = newVal ?? false;
                    });
                  }))),
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

// add back button
Widget recipePage(BuildContext context, Recipe r, Uint8List imgData) {
  return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: imgData.hashCode,
            child: Image.memory(
              imgData,
              height: 240,
              fit: BoxFit.cover,
            ),
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
              IngredientTab(r.ingredients),
              PreparationTab(r.preparation)
            ]),
          ),
        ],
      )
    )
  );
}
