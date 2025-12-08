// lib/screens/prediction_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/prediction_viewmodel.dart';

late PredictionViewModel _vm;

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  File? _image;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm = Provider.of<PredictionViewModel>(context, listen: false);
      _vm.clear();
    });
  }

  @override
  void dispose() {
    _vm.clear();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });

      // Limpia el resultado si se selecciona una imagen nueva
      Provider.of<PredictionViewModel>(context, listen: false).clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PredictionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Predicción de Cáncer"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD DE LA IMAGEN
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _image != null
                    ? Image.file(
                  _image!,
                  height: 240,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 240,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Text(
                      "Sin imagen seleccionada",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN SELECCIONAR IMAGEN
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("Seleccionar Imagen"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // BOTÓN PROCESAR
            ElevatedButton.icon(
              onPressed: vm.isLoading || _image == null
                  ? null
                  : () => vm.predict(_image!, context),
              icon: const Icon(Icons.search),
              label: vm.isLoading
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text("Procesar Imagen"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),

            // MENSAJE DE ERROR
            if (vm.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                vm.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],

            // RESULTADOS
            if (vm.prediction != null || vm.confidence != null) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (vm.prediction != null)
                        Text(
                          "Resultado: ${vm.prediction!}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (vm.confidence != null)
                        Text(
                          "Confianza: ${vm.confidence!.toStringAsFixed(2)}%",
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
