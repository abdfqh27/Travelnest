// src/presentation/screen/admin/edit_wisata_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/data/model/wisata.dart';

class EditWisataScreen extends StatefulWidget {
  final Wisata wisata;

  const EditWisataScreen({super.key, required this.wisata});

  @override
  _EditWisataScreenState createState() => _EditWisataScreenState();
}

class _EditWisataScreenState extends State<EditWisataScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late double price;
  late String description;
  late WisataType type;
  XFile? _mainImageFile;
  List<XFile> _carouselImages = [];

  @override
  void initState() {
    super.initState();
    name = widget.wisata.name;
    price = widget.wisata.price;
    description = widget.wisata.description;
    type = widget.wisata.type;
  }

  Future<void> _pickMainImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _mainImageFile = image;
    });
  }

  Future<void> _pickCarouselImages() async {
    final images = await ImagePicker().pickMultiImage();
    if (images != null) {
      setState(() {
        _carouselImages = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wisataProvider = Provider.of<WisataProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Wisata")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: "Nama Wisata"),
                  onChanged: (value) => name = value,
                  validator: (value) => value == null || value.isEmpty ? "Nama wisata diperlukan" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: price.toString(),
                  decoration: const InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => price = double.tryParse(value) ?? 0,
                  validator: (value) => value == null || value.isEmpty ? "Harga diperlukan" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: description,
                  decoration: const InputDecoration(labelText: "Deskripsi"),
                  onChanged: (value) => description = value,
                  validator: (value) => value == null || value.isEmpty ? "Deskripsi diperlukan" : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<WisataType>(
                  value: type,
                  decoration: const InputDecoration(labelText: "Tipe"),
                  items: WisataType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) => type = value!,
                ),
                const SizedBox(height: 16),
                const Text("Gambar Utama"),
                ElevatedButton(onPressed: _pickMainImage, child: const Text("Pilih Gambar Utama")),
                if (_mainImageFile != null)
                  Image.file(File(_mainImageFile!.path), height: 150, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 16),
                const Text("Gambar Carousel"),
                ElevatedButton(onPressed: _pickCarouselImages, child: const Text("Pilih Gambar Carousel")),
                if (_carouselImages.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _carouselImages.map((image) {
                      return Image.file(File(image.path), width: 100, height: 100, fit: BoxFit.cover);
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedWisata = widget.wisata.copyWith(
                          name: name,
                          price: price,
                          description: description,
                          type: type,
                        );
                        wisataProvider.updateWisata(updatedWisata, _mainImageFile, _carouselImages);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Simpan Perubahan"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
