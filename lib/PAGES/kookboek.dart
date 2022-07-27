import 'package:flutter/material.dart';

// Favoriete Receptenboek gebundeld in een 'boek'
// Een recept kan lokaal aangemaakt worden of gedeeld met anderen.
// Receptenboek van anderen kunnen lokaal gewijzigd worden (bijvoorbeeld een extra bouillonblokje toevoegen).

class Kookboek extends StatelessWidget {
  const Kookboek({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kookboek'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Homepage'),
        ),
      ),
    );
  }
}
