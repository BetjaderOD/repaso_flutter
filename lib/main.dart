import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:respaso/firebase_options.dart';
import 'package:respaso/presentation/screens/home_create.dart';
import 'package:respaso/presentation/screens/home_edit.dart';
import 'package:respaso/presentation/screens/home_screens.dart';
import 'package:respaso/presentation/screens/main_screens.dart';
import 'presentation/screens/car_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura la inicialización
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp()); // Llama a runApp después de inicializar Firebase
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/home': (context) => const HomeScreens(),
        '/car': (context) => const CarScreens(),
        '/create': (context) => const HomeCreate(),
      },
    );
  }
}
