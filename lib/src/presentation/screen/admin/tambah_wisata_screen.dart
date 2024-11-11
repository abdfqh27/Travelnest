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
                      "Tambah Wisata Baru",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Nama Wisata",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Border kotak tanpa radius
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                      ),
                      onChanged: (value) => name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama wisata diperlukan";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Harga",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Border kotak tanpa radius
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => price = double.tryParse(value) ?? 0,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Harga diperlukan";
                        }
                        if (double.tryParse(value) == null) {
                          return "Harga tidak valid";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Deskripsi",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Border kotak tanpa radius
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                      ),
                      onChanged: (value) => description = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Deskripsi diperlukan";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<WisataType>(
                      decoration: const InputDecoration(
                        labelText: "Tipe",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Border kotak tanpa radius
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                      ),
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
                    const SizedBox(height: 20),
                    const Text(
                      "Gambar Utama",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // IconButton untuk memilih gambar utama
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo, size: 40, color: Colors.blueAccent),
                        onPressed: _pickMainImage,
                        tooltip: 'Pilih Gambar Utama', // Tooltip untuk aksesibilitas
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
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      "Gambar Carousel",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // IconButton untuk memilih gambar carousel
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.collections, size: 40, color: Colors.green),
                        onPressed: _pickCarouselImages,
                        tooltip: 'Pilih Gambar Carousel', // Tooltip untuk aksesibilitas
                      ),
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.file(
                              File(_carouselImages[index].path),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final wisata = Wisata(
                              id: '',
                              image: '',
                              carouselImages: [],
                              name: name,
                              price: price,
                              description: description,
                              score: 0,
                              type: type,
                              voter: 0,
                            );

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
