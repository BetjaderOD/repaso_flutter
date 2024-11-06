import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCreate extends StatefulWidget {
  const HomeCreate({super.key});

  @override
  _HomeCreateState createState() => _HomeCreateState();
}

class _HomeCreateState extends State<HomeCreate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        // Guardar datos en Firestore
        await FirebaseFirestore.instance.collection('casa').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'image': _imageController.text,
          'price': _priceController.text,
          'location': _locationController.text,
        });

        // Mostrar mensaje de éxito y navegar a la pantalla anterior
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Casa guardada exitosamente')),
        );

        Navigator.pop(context); // Volver a la pantalla anterior
      } catch (e) {
        // Manejo de errores si falla la operación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar Casa'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Imagen URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la URL de la imagen';
                  }
                  final urlPattern = RegExp(
                    r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
                    caseSensitive: false,
                  );
                  if (!urlPattern.hasMatch(value)) {
                    return 'Ingrese una URL válida';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el precio';
                  }
                  final pricePattern = RegExp(r'^\d+(\.\d{1,2})?$');
                  if (!pricePattern.hasMatch(value)) {
                    return 'Ingrese un precio válido (ej: 200 o 200.00)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la ubicación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: isLoading
                    ? const CircularProgressIndicator() // Loader mientras se realiza la operación
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Guardar Casa'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
