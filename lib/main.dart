import 'package:flutter/material.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/random_meal_screen.dart';

void main() {
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
