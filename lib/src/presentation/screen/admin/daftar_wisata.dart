import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_color.dart';
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
        title: const Text(
          "Daftar Wisata",
          style: TextStyle(color: LightThemeColor.accent),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahWisataScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: wisataProvider.wisataList.length,
        itemBuilder: (context, index) {
          final wisata = wisataProvider.wisataList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            color: Colors.white.withOpacity(0.8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  wisata.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                wisata.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "Rp ${wisata.price}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: LightThemeColor.yellow),
                    onPressed: () async {
                      // Menunggu hasil dari EditWisataScreen
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditWisataScreen(wisata: wisata),
                        ),
                      );

                      // Jika update berhasil, tampilkan notifikasi
                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Wisata berhasil diperbarui"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      wisataProvider.deleteWisata(context, wisata.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
