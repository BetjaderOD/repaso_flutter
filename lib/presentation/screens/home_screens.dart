import 'package:flutter/material.dart';
import 'package:respaso/models/home.dart';
import 'package:respaso/presentation/views/home_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final db = FirebaseFirestore.instance;
  List<Home> homes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    db.collection("casa").snapshots().listen((event) {
      homes = [];
      for (var doc in event.docs) {
        final home = Home(
          title: doc.data().containsKey('title') ? doc['title'] : 'Sin título',
          description: doc.data().containsKey('description')
              ? doc['description']
              : 'Sin descripción',
          image: doc.data().containsKey('image') ? doc['image'] : '',
          price: doc.data().containsKey('price') ? doc['price'] : 'Sin precio',
          location: doc.data().containsKey('location')
              ? doc['location']
              : 'Sin ubicación',
        );
        homes.add(home);
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casas'),
        backgroundColor: Colors.red,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: homes.length,
        itemBuilder: (BuildContext context, int index) {
          return HomeList(home: homes[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}
