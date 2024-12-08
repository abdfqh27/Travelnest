import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';
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
    super.key,
    required this.namaWisata,
    required this.hargaTiket,
    required this.namaPemesan,
    required this.nik,
    required this.nomorTelepon,
    required this.alamat,
    required this.tanggalKunjungan,
  });

  @override
  Widget build(BuildContext context) {
    final pesananProvider = PesananProvider();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Order Details",
                style: TextStyle(
                color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Card untuk detail pesanan
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Border radius 12
              ),
              color: context.read<ThemeProvider>().isLightTheme
                          ? LightThemeColor.primaryDark
                          : DarkThemeColor.primaryLight, // Warna latar belakang card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem(context, "Tour Name", namaWisata),
                    _buildDetailItem(context,"Booker Name", namaPemesan),
                    _buildDetailItem(context,"NIK", nik),
                    _buildDetailItem(context,"No. Handphone", nomorTelepon),
                    _buildDetailItem(context,"Addres", alamat),
                    _buildDetailItem(context,"Date", tanggalKunjungan),
                    Divider(color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white, thickness: 1),
                    const SizedBox(height: 8),
                    Text(
                      "Payment Method",
                      style: TextStyle(
                        color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
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
                      title: Text(
                        "Dana",
                        style: TextStyle(
                          color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
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
                        Text(
                          "Total Payment",
                          style: TextStyle(
                            color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          hargaTiket, // Nilai dari variabel hargaTiket
                          style: TextStyle(
                            color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
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
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (_) => KonfirmasiPembayaranScreen(
                          totalPembayaran: hargaTiket,
                          tanggal: tanggal,
                        ),
                      ),
                    );
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to save order: $e"),
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
                  "Pay Now",
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

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
