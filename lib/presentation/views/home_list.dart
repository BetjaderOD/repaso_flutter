import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:respaso/models/home.dart';
import 'package:respaso/presentation/screens/home_details.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:respaso/presentation/screens/home_edit.dart';

class HomeList extends StatefulWidget {
  const HomeList({super.key, required this.home});
  final Home home;

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  Future<void> _deleteHome(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Casa'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta casa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      try {
        // Buscar documento por título
        final snapshot = await FirebaseFirestore.instance
            .collection('casa')
            .where('title', isEqualTo: widget.home.title)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Obtener el ID del documento y eliminarlo
          final docId = snapshot.docs.first.id;
          await FirebaseFirestore.instance
              .collection('casa')
              .doc(docId)
              .delete();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Casa eliminada exitosamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se encontró la casa')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDetails(home: widget.home),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.home.image.isNotEmpty
              ? Image.network(
                  widget.home.image,
                  width: 70,
                  height: 70,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                )
              : const Icon(Icons.image_not_supported),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StarRating(
                rating: 3,
                starCount: 5,
                size: 12,
                color: Colors.amber,
                borderColor: Colors.grey,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteHome(context),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeEdit(home: widget.home), // Pasa el objeto Home
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
