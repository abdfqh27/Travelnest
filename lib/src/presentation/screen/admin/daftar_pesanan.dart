import 'package:flutter/material.dart';
import 'package:wisata_app/src/business_logic/provider/pesanan/pesanan_provider.dart';

class DaftarPesananScreen extends StatelessWidget {
  const DaftarPesananScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pesananProvider = PesananProvider();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Pesanan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F1F30),
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
                  color: const Color(0xFF1F1F30),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaWisata,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow("Kode Pemesanan: $kodePemesanan", ""),
                        _buildDetailRow(namaPemesan, nik),
                        _buildDetailRow(nomorTelepon, ""),
                        _buildDetailRow(alamat, ""),
                        _buildDetailRow(tanggalKunjungan, hargaTiket),
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

  Widget _buildDetailRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              right,
              style: const TextStyle(
                color: Colors.white,
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
