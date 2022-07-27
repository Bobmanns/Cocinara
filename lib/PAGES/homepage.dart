import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePaginaState();
}

class _HomePaginaState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              icon: const Icon(Icons.settings))
        ],
        title: const Text("Homepage"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Hoi Bob, wat wil je eten?'),
      ),
    );
  }
}
