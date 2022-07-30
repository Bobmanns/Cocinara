import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Staggered Gridview (zoals pinterest) met verschillende Recepten die mensen kunnen toevoegen aan hun kookboek.
// to do: Flter
class Receptenboek extends StatefulWidget {
  const Receptenboek({super.key});

  @override
  State<Receptenboek> createState() => _ReceptenboekState();
}

class _ReceptenboekState extends State<Receptenboek> {
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
      body: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        itemBuilder: (context, index) {
          return buildImageCard(index);
        },
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
