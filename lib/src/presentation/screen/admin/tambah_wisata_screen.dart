import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/data/model/wisata.dart';

class TambahWisataScreen extends StatefulWidget {
  const TambahWisataScreen({super.key});

  @override
  _TambahWisataScreenState createState() => _TambahWisataScreenState();
}

class _TambahWisataScreenState extends State<TambahWisataScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0;
  String description = '';
  WisataType type = WisataType.tertinggi;
  XFile? _mainImageFile;
  List<XFile> _carouselImages = []; // List untuk menyimpan gambar carousel

  // Fungsi untuk memilih gambar utama
  Future<void> _pickMainImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _mainImageFile = image;
    });
  }

  // Fungsi untuk memilih gambar carousel
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
      appBar: AppBar(title: const Text("Tambah Wisata")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tambah Wisata Baru",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Nama Wisata"),
                      onChanged: (value) => name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Nama wisata diperlukan";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Harga"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => price = double.tryParse(value) ?? 0,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Harga diperlukan";
                        if (double.tryParse(value) == null)
                          return "Harga tidak valid";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Deskripsi"),
                      onChanged: (value) => description = value,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Deskripsi diperlukan";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<WisataType>(
                      decoration: const InputDecoration(labelText: "Tipe"),
                      value: type,
                      items: WisataType.values.map((WisataType type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          type = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Gambar Utama",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: _pickMainImage,
                      child: const Text("Pilih Gambar Utama"),
                    ),
                    if (_mainImageFile != null)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(
                          File(_mainImageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text("Gambar Carousel",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: _pickCarouselImages,
                      child: const Text("Pilih Gambar Carousel"),
                    ),
                    if (_carouselImages.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: _carouselImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.file(
                              File(_carouselImages[index].path),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final wisata = Wisata(
                              id: '',
                              image:
                                  '', // Akan diperbarui dengan URL dari Storage
                              carouselImages: [], // Akan diperbarui dengan URL dari Storage
                              name: name,
                              price: price,
                              description: description,
                              score: 0,
                              type: type,
                              voter: 0,
                            );

                            // Panggil `addWisata` dengan gambar utama dan gambar carousel
                            wisataProvider.addWisata(
                                wisata, _mainImageFile, _carouselImages);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Tambah Wisata"),
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
