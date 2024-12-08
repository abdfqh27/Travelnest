import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/category/category_provider.dart';
import 'package:wisata_app/src/data/model/wisata.dart';

class TambahWisataScreen extends StatefulWidget {
  const TambahWisataScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TambahWisataScreenState createState() => _TambahWisataScreenState();
}

class _TambahWisataScreenState extends State<TambahWisataScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0;
  String description = '';
  String location = '';
  WisataType type = WisataType.gunung; // Default tipe wisata
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
    final wisataProvider = Provider.of<WisataProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Add Tour",
        style: Theme.of(context).textTheme.displayMedium,
      )),
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
                      "Add New Tour",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Tourist Name",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      onChanged: (value) => name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Tourist name required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Price",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => price = double.tryParse(value) ?? 0,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Price required";
                        }
                        if (double.tryParse(value) == null) {
                          return "Price is invalid";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Location",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      onChanged: (value) => location = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Location required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      onChanged: (value) => description = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Description required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<WisataType>(
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                      "Main Image",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.blueAccent),
                        onPressed: _pickMainImage,
                        tooltip: 'Select Main Image',
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
                      "Carousel Image",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.collections,
                            size: 40, color: Colors.green),
                        onPressed: _pickCarouselImages,
                        tooltip: 'Select Carousel Image',
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final wisata = Wisata(
                              id: '',
                              image: '',
                              carouselImages: [],
                              name: name,
                              price: price,
                              description: description,
                              location: location,
                              timestamp: Timestamp.now(),
                              score: 0,
                              type: type,
                              voter: 0,
                            );

                            // Tambahkan wisata ke Firestore dan Provider
                            await wisataProvider.addWisata(
                              wisata,
                              _mainImageFile,
                              _carouselImages,
                              context,
                            );

                            // Navigasi kembali setelah sukses
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Add Tour"),
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
