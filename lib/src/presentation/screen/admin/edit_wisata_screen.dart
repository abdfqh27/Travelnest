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
  late String location;
  late WisataType type;
  XFile? _mainImageFile;
  List<XFile> _carouselImages = [];

  @override
  void initState() {
    super.initState();
    name = widget.wisata.name;
    price = widget.wisata.price;
    description = widget.wisata.description;
    location = widget.wisata.location;
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
      appBar: AppBar(
          title: Text(
        "Edit Wisata",
        style: Theme.of(context).textTheme.displayMedium,
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            color: Colors.white.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit Wisata",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(
                        labelText: "Nama Wisata",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => name = value,
                      validator: (value) => value == null || value.isEmpty
                          ? "Nama wisata diperlukan"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: price.toString(),
                      decoration: const InputDecoration(
                        labelText: "Harga",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => price = double.tryParse(value) ?? 0,
                      validator: (value) => value == null || value.isEmpty
                          ? "Harga diperlukan"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: location, // Tampilkan lokasi awal
                      decoration: const InputDecoration(
                        labelText: "Lokasi",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => location = value, // Perbarui lokasi
                      validator: (value) => value == null || value.isEmpty
                          ? "Lokasi diperlukan"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: description,
                      decoration: const InputDecoration(
                        labelText: "Deskripsi",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => description = value,
                      validator: (value) => value == null || value.isEmpty
                          ? "Deskripsi diperlukan"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<WisataType>(
                      value: type,
                      decoration: const InputDecoration(
                        labelText: "Tipe",
                        border: OutlineInputBorder(),
                      ),
                      items: WisataType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) => type = value!,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Gambar Utama",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.blueAccent),
                        onPressed: _pickMainImage,
                        tooltip: 'Pilih Gambar Utama',
                      ),
                    ),
                    if (_mainImageFile != null)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.file(
                          File(_mainImageFile!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      "Gambar Carousel",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.collections,
                            size: 40, color: Colors.green),
                        onPressed: _pickCarouselImages,
                        tooltip: 'Pilih Gambar Carousel',
                      ),
                    ),
                    if (_carouselImages.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _carouselImages.map((image) {
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.file(
                              File(image.path),
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final updatedWisata = widget.wisata.copyWith(
                              name: name,
                              price: price,
                              description: description,
                              location: location,
                              type: type,
                            );
                            await wisataProvider.updateWisata(
                              context,
                              updatedWisata,
                              _mainImageFile,
                              _carouselImages,
                            );

                            // Kembali ke layar sebelumnya dan berikan nilai true
                            Navigator.pop(context, true);
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
        ),
      ),
    );
  }
}
