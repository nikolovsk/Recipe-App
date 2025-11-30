import 'package:flutter/material.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/random_meal_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Firestore test
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> testFirestore() async {
  final docRef = FirebaseFirestore.instance.collection('test').doc('check');
  await docRef.set({'message': 'Hello Firebase!'});
  final snapshot = await docRef.get();
  print("Firestore data: ${snapshot.data()}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await testFirestore();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meals App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const HomeScreen(),
          "/random": (context) => const RandomMealScreen(),
        }
    );
  }
}
