import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_cocinara/Classes/recepten.dart';
import '../main.dart';

class BoodschappenlijstItem extends StatefulWidget {
  final Ingredient ingredient;


  const BoodschappenlijstItem(this.ingredient);

  @override
  BoodschappenlijstItemState createState() => BoodschappenlijstItemState();
}

class BoodschappenlijstItemState extends State<BoodschappenlijstItem> {
  bool afgevinkt = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(value: afgevinkt, onChanged: (newValue) {
              setState(() {
                afgevinkt = newValue ?? false;
              });
            }),
            Text(
              "${widget.ingredient.ingredientName} (${widget.ingredient.ingredientQuantity})",
              style: afgevinkt ? 
                TextStyle(color: Colors.grey[700], decoration: TextDecoration.lineThrough) 
              : const TextStyle(inherit: true)
            ),
          ],
        ),
      ),
    );
  }
}

class Boodschappenlijst extends StatelessWidget {
  const Boodschappenlijst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    MainPageState hoofdpaginaState = context.findAncestorStateOfType()!;
    List<Ingredient> ingredienten = hoofdpaginaState.boodschappenLijst;

    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          ingredienten.length, 
          (index) => BoodschappenlijstItem(ingredienten[index])),
      ),
    );
  }
}