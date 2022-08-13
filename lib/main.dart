import 'package:flutter/material.dart';
import 'package:my_cocinara/PAGES/homepage.dart';
import 'package:my_cocinara/PAGES/receptenboek.dart';
import 'package:my_cocinara/PAGES/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/gestures.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = [
    const HomePage(),
    const Receptenboek(),
    const Center(child: Text('Groceries', style: TextStyle(fontSize: 60))),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[currentIndex],
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

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
