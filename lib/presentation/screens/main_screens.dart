import 'package:flutter/material.dart';
import 'package:respaso/presentation/screens/car_screens.dart';
import 'package:respaso/presentation/screens/home_screens.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreens(),
    CarScreens(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home_filled),
              label: 'Casas',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.car_crash_outlined),
              activeIcon: Icon(Icons.car_crash),
              label: 'Carros',
              backgroundColor: Colors.blue),
        ],
      ),
    );
  }
}
