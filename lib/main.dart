import 'package:flutter/material.dart';
import 'package:my_cocinara/PAGES/boodschappenlijst.dart';
import 'package:my_cocinara/PAGES/homepage.dart';
import 'package:my_cocinara/PAGES/kookboek.dart';

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

class EmailPasswordData {
  final String email;
  final String password;

  const EmailPasswordData(this.email, this.password);
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Welkom bij Cocinara", style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 60.0,),
                  ElevatedButton.icon(
                    onPressed: () async {
                      EmailPasswordData? loginGegevens = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EmailPasswordAuthPage()
                        )
                      );

                      if (loginGegevens != null) {
                        try {
                          FirebaseAuth.instance.createUserWithEmailAndPassword(email: loginGegevens.email, password: loginGegevens.password);
                        } on FirebaseAuthException catch (e) {
                          print(e);
                        }
                      }
                    }, 
                    icon:  const Icon(Icons.email), 
                    label: const Text("Login met e-mail")
                  ),
                  const SizedBox(height: 8.0,),
                  ElevatedButton.icon(
                    onPressed: () {
                      FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
                    }, 
                    icon:  const Icon(Icons.face), 
                    label: const Text("Login met Google")
                  ),
                  const SizedBox(height: 8.0,),
                  ElevatedButton.icon(
                    onPressed: () {
                      FirebaseAuth.instance.signInAnonymously();
                    }, 
                    icon:  const Icon(Icons.person),
                    label: const Text("Gebruik als gast")
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

class EmailPasswordAuthPage extends StatefulWidget {
  const EmailPasswordAuthPage({Key? key}) : super(key: key);

  @override
  State<EmailPasswordAuthPage> createState() => _EmailPasswordAuthPageState();
}

class _EmailPasswordAuthPageState extends State<EmailPasswordAuthPage> {
  GlobalKey formKey = GlobalKey();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "E-mailadres"
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    if (!RegExp(r"/^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/gm").hasMatch(value ?? "")) {
                      return "Voer een geldig e-mailadres in";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Wachtwoord",
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    if ((value ?? "").length < 8) {
                      return "Het wachtwoord moet minstens acht karakters lang zijn.";
                    } else {
                      return null;
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      EmailPasswordData(email, password)
                    );
                  },
                  child: Text("Registreer / login"),
                )
              ],
            )
          ),
        ),
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
      const Kookboek(),
      const Boodschappenlijst()
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
