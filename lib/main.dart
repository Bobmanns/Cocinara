import 'package:flutter/material.dart';
import 'package:my_cocinara/PAGES/boodschappenlijst.dart';
import 'package:my_cocinara/PAGES/homepage.dart';
import 'package:my_cocinara/PAGES/kookboek.dart';
import 'package:my_cocinara/PAGES/receptenboek.dart';
import 'package:my_cocinara/PAGES/settings.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/gestures.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'Classes/recepten.dart';
import 'Classes/notification.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Cocinara',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 254, 254, 255))),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Column(
                children: [
                  const Text("Welkom bij Cocinara", style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 60.0,),
                  ElevatedButton.icon(
                    onPressed: () {}, 
                    icon: Icon(Icons.email), 
                    label: Text("Login met e-mail")
                  ),
                  const SizedBox(height: 8.0,),
                  ElevatedButton.icon(
                    onPressed: () {
                      FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
                    }, 
                    icon: Icon(Icons.face), 
                    label: Text("Login met Google")
                  ),
                  const SizedBox(height: 8.0,),
                  ElevatedButton.icon(
                    onPressed: () {
                      FirebaseAuth.instance.signInAnonymously();
                    }, 
                    icon: Icon(Icons.person),
                    label: Text("Gebruik als gast")
                  )
                ],
              ),
            );
          } else {
            return MainPage(snapshot.data!);
          }
         
        }
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final User user;

  const MainPage(this.user, {super.key});

  @override
  State<MainPage> createState() => MainPageState();
}


class MainPageState extends State<MainPage> {
  late User gebruiker = widget.user;

  List<Ingredient> boodschappenLijst = [
    const Ingredient(MetaIngredient("Linzen", "Peulvruchten"), "180 gram"),
    const Ingredient(MetaIngredient("Appelsap", "Dranken"), "1 liter")
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomePage(gebruiker),
      Kookboek(),
      Boodschappenlijst()
    ];
    
    return Scaffold(
        body: NotificationListener<BoodschappenNotification>(
          onNotification: ((notification) {
            setState(() {
              boodschappenLijst.addAll(notification.nieuweBoodschappen);
            });

            return true;
          }),
          child: screens[currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 5,
            showUnselectedLabels: false,
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Recipes',
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_rounded),
                label: 'Groceries',
                backgroundColor: Colors.blue,
              ),
            ]),
      );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
