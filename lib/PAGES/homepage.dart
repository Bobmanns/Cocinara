import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Classes/recepten.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage(this.user, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePaginaState();
}

class _HomePaginaState extends State<HomePage> {
  var db = FirebaseFirestore.instance;
  List<Recipe> recipes = [];

  int currentIndex = 0;
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.5,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: CircleAvatar(
                foregroundImage: NetworkImage(widget.user.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/cocinara-21548.appspot.com/o/default.jpg?alt=media&token=543de3e0-98aa-4826-a904-0ab5d4c7ec26"),
              )
          )
        ],
        title: Text(
          "Hey ${widget.user.displayName ?? "gast"}, welkom terug!",
          style:
              const TextStyle(color: Color.fromARGB(255, 29, 29, 29), fontSize: 16),
        ),
        centerTitle: false,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),

            // Deze Container bevat de verschillende kookboeken
            Container(
              width: double.infinity,
              height: 250,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromARGB(255, 225, 225, 225)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildCard(),
                    const SizedBox(width: 15),
                    buildCard(),
                    const SizedBox(width: 15),
                    buildCard(),
                    const SizedBox(width: 15),
                    buildCard(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 30,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromARGB(255, 225, 225, 225)),
              child: const Center(child: Text('This is a searchbar')),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 275,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromARGB(255, 225, 225, 225)),
              child: const Center(
                  child: Text(
                      'wat eten wij vandaag? maaltijdplanner placeholder ')),
            ),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }

// Placeholder widget for book or recipes (MVP)
  Widget buildCard() => Container(
        width: 150,
        height: 225,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.amber),
        child: Card(
          elevation: 0.0,
          color: Colors.amber,
          child: InkWell(
            onTap: () {},
            child: const Center(
              child: Text(
                'Kookboek, eigen recepten of populair deze week',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
}
