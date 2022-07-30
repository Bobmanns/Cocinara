import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePaginaState();
}

class _HomePaginaState extends State<HomePage> {
  var db = FirebaseFirestore.instance; 

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
      body:  Center(
        child: FutureBuilder(future: db.collection('recipes').get(), builder: (context, snapshot){

          if (snapshot.hasData && snapshot.connectionState==ConnectionState.done){
            List l = [];
            QuerySnapshot q = snapshot.data! as QuerySnapshot;
            for (var doc in q.docs){
              l.add(doc.get("name") as String);
            }
            return Text(l.join(', '),);
          }
          else { return const CircularProgressIndicator(); }
        },),

      ),
    );
  }
}
