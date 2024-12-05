import 'package:flutter/material.dart';
import 'package:wisata_app/core/app_asset.dart';

class TicketDetailScreen extends StatelessWidget {
  final String namaWisata;
  final String kodePemesanan;
  final String namaPemesan;
  final String nik;
  final String barcodeImage;
  final String logoImage;

  const TicketDetailScreen({
    Key? key,
    required this.namaWisata,
    required this.kodePemesanan,
    required this.namaPemesan,
    required this.nik,
    this.barcodeImage = AppAsset.barcode,
    this.logoImage = AppAsset.travelnest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tiket",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F1F30),
      ),
      backgroundColor: const Color(0xFF1F1F30),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Row(
                    children: [
                      Image.asset(
                        logoImage,
                        height: 50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Nama Wisata
                  Text(
                    namaWisata,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F30),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Kode Pemesanan
                  Text(
                    "Kode Pemesanan: $kodePemesanan",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1F1F30),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  // Informasi Pemesan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        namaPemesan,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F1F30),
                        ),
                      ),
                      Text(
                        nik,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1F1F30),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  // Barcode
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Scan This Code",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F30),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Image.asset(
                          barcodeImage,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
