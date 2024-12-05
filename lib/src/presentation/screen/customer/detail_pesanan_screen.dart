import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wisata_app/src/presentation/screen/customer/kebijakan_screen.dart';
import 'package:wisata_app/src/business_logic/provider/pesanan/pesanan_provider.dart';
import 'package:wisata_app/src/presentation/screen/customer/pembayaran_berhasil_screen.dart';
import 'package:wisata_app/core/app_asset.dart';

class DetailPesananScreen extends StatelessWidget {
  final String namaWisata;
  final String hargaTiket;
  final String namaPemesan;
  final String nik;
  final String nomorTelepon;
  final String alamat;
  final String tanggalKunjungan;

  const DetailPesananScreen({
    Key? key,
    required this.namaWisata,
    required this.hargaTiket,
    required this.namaPemesan,
    required this.nik,
    required this.nomorTelepon,
    required this.alamat,
    required this.tanggalKunjungan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pesananProvider = PesananProvider();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Detail Pemesanan",
                style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Card untuk detail pesanan
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Border radius 12
              ),
              color: const Color(0xFF1F1F30), // Warna latar belakang card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem("Nama Wisata", namaWisata),
                    _buildDetailItem("Nama Pemesan", namaPemesan),
                    _buildDetailItem("NIK", nik),
                    _buildDetailItem("No. Handphone", nomorTelepon),
                    _buildDetailItem("Alamat", alamat),
                    _buildDetailItem("Tanggal", tanggalKunjungan),
                    const Divider(color: Color(0xFF9159C1), thickness: 1),
                    const SizedBox(height: 8),
                    const Text(
                      "Metode Pembayaran",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(
                        AppAsset.dana, // Logo Dana
                        width: 40,
                        height: 40,
                      ),
                      title: const Text(
                        "Dana",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                   /*  const Divider(color: Color(0xFF9159C1), thickness: 1), */
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Pembayaran",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          hargaTiket, // Nilai dari variabel hargaTiket
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Tombol bayar sekarang
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final tanggal = DateFormat('dd MMM yyyy').format(now);

                  // Data yang akan disimpan di Firebase
                  final dataPesanan = {
                    'namaWisata': namaWisata,
                    'hargaTiket': hargaTiket,
                    'namaPemesan': namaPemesan,
                    'nik': nik,
                    'nomorTelepon': nomorTelepon,
                    'alamat': alamat,
                    'tanggalKunjungan': tanggalKunjungan,
                    'tanggalPemesanan': tanggal,
                  };

                  try {
                    await pesananProvider.tambahPesanan(dataPesanan);

                    // Navigasi ke halaman konfirmasi pembayaran
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KonfirmasiPembayaranScreen(
                          totalPembayaran: hargaTiket,
                          tanggal: tanggal,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Gagal menyimpan pesanan: $e"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius 8
                  ),
                  backgroundColor: const Color(0xFF5A189A), // Warna tombol
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Bayar Sekarang",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
