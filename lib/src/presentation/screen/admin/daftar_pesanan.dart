import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/business_logic/provider/pesanan/pesanan_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

class DaftarPesananScreen extends StatelessWidget {
  const DaftarPesananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pesananProvider = PesananProvider();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Pesanan",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: pesananProvider.getSemuaPesanan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada tiket yang dipesan."));
          }

          final dataPesanan = snapshot.data!;
          return ListView.builder(
            itemCount: dataPesanan.length,
            itemBuilder: (context, index) {
              final pesanan = dataPesanan[index];
              final documentId = pesanan['id'] ?? ''; // ID dokumen
              final kodePemesanan = documentId.length >= 5 
                  ? documentId.substring(0, 5) 
                  : 'XXXXX'; // Ambil 5 karakter pertama atau placeholder
              final namaWisata = pesanan['namaWisata'] ?? '';
              final hargaTiket = pesanan['hargaTiket'] ?? '';
              final namaPemesan = pesanan['namaPemesan'] ?? '';
              final nik = pesanan['nik'] ?? '';
              final nomorTelepon = pesanan['nomorTelepon'] ?? '';
              final alamat = pesanan['alamat'] ?? '';
              final tanggalKunjungan = pesanan['tanggalKunjungan'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: context.read<ThemeProvider>().isLightTheme
                              ? LightThemeColor.primaryDark
                              : DarkThemeColor.primaryLight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaWisata,
                          style: TextStyle(
                            color: context.read<ThemeProvider>().isLightTheme
                              ? Colors.black
                              : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(context, "Kode Pemesanan: $kodePemesanan", ""),
                        _buildDetailRow(context, namaPemesan, nik),
                        _buildDetailRow(context, nomorTelepon, ""),
                        _buildDetailRow(context, alamat, ""),
                        _buildDetailRow(context, tanggalKunjungan, hargaTiket),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              left,
              style: TextStyle(
                color: context.read<ThemeProvider>().isLightTheme
                              ? Colors.black
                              : Colors.white,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              right,
              style: TextStyle(
                color: context.read<ThemeProvider>().isLightTheme
                              ? Colors.black
                              : Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
