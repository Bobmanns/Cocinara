import 'package:flutter/material.dart';
import 'package:my_cocinara/Classes/recepten.dart';
import '../main.dart';

class BoodschappenlijstItem extends StatefulWidget {
  final Ingredient ingredient;


  const BoodschappenlijstItem(this.ingredient, {Key? key}) : super(key: key);

  @override
  BoodschappenlijstItemState createState() => BoodschappenlijstItemState();
}

class BoodschappenlijstItemState extends State<BoodschappenlijstItem> {
  bool afgevinkt = false;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: afgevinkt ? Colors.grey[200] : Colors.white,
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
              "${widget.ingredient.ingr.name} (${widget.ingredient.quantity})",
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
    List<List<Ingredient>> ingredienten = groepeer(hoofdpaginaState.boodschappenLijst);

  

    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          ingredienten.length, 
          (index) => ExpansionTile(
            title: Text(ingredienten[index][0].ingr.type),
            initiallyExpanded: true,
            children: List.generate(
              ingredienten[index].length, 
              (index2) => BoodschappenlijstItem(ingredienten[index][index2])
            ),
          ),
        )
      ),
    );
  }
}

List<List<Ingredient>> groepeer(List<Ingredient> bron) {
  Map<String, List<Ingredient>> gekendeTypes = {};
  for (Ingredient i in bron) {
    if (gekendeTypes.containsKey(i.ingr.type)) {
      gekendeTypes[i.ingr.type]!.add(i);
    } else {
      gekendeTypes[i.ingr.type] = [i];
    }
  }

  return gekendeTypes.values.toList();
}