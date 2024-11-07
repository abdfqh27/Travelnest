// src/presentation/screen/admin/daftar_wisata_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/presentation/screen/admin/tambah_wisata_screen.dart';
import 'package:wisata_app/src/presentation/screen/admin/edit_wisata_screen.dart';

class DaftarWisataScreen extends StatelessWidget {
  const DaftarWisataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wisataProvider = context.watch<WisataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Wisata"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahWisataScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: wisataProvider.wisataList.length,
        itemBuilder: (context, index) {
          final wisata = wisataProvider.wisataList[index];
          return ListTile(
            title: Text(wisata.name),
            subtitle: Text("Rp ${wisata.price}"),
            leading: Image.network(wisata.image),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditWisataScreen(wisata: wisata),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    wisataProvider.deleteWisata(wisata.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
