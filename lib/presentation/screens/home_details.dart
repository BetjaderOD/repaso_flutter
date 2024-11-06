import 'package:flutter/material.dart';
import 'package:respaso/models/home.dart';

class HomeDetails extends StatefulWidget {
  const HomeDetails({super.key, required this.home});
  final Home home;

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.home.title),
        backgroundColor: Colors.red,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      body: Column(
        children: [
          Image.network(
            widget.home.image,
            width: double.infinity,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.home.title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(widget.home.description),
          Text(widget.home.price),
          Text(widget.home.location),
        ],
      ),
    );
  }
}
