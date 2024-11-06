import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:respaso/models/home.dart';

class HomeEdit extends StatefulWidget {
  const HomeEdit({super.key, required this.home});
  final Home home;

  @override
  State<HomeEdit> createState() => _HomeEditState();
}

class _HomeEditState extends State<HomeEdit> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.home.title);
    _descriptionController =
        TextEditingController(text: widget.home.description);
    _priceController = TextEditingController(text: widget.home.price);
    _locationController = TextEditingController(text: widget.home.location);
  }

  Future<void> _updateHome() async {
    try {
      // Buscar el documento por título
      final snapshot = await FirebaseFirestore.instance
          .collection('casa')
          .where('title', isEqualTo: widget.home.title)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;

        // Actualizar los campos del documento
        await FirebaseFirestore.instance.collection('casa').doc(docId).update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'price': _priceController.text,
          'location': _locationController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Casa actualizada exitosamente')),
        );
        Navigator.pop(context); // Regresa a la pantalla anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se encontró la casa para actualizar')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Casa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Ubicación'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateHome,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
