import 'package:flutter/material.dart';
import 'detail_pesanan_screen.dart';

class KebijakanScreen extends StatelessWidget {
  final String namaWisata;
  final String hargaTiket;
  final String namaPemesan;
  final String nik;
  final String nomorTelepon;
  final String alamat;
  final String tanggalKunjungan;

  const KebijakanScreen({
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ketentuan dan Kebijakan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F30),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: const [
                    Text(
                      "1. Tiket hanya dapat dibeli melalui aplikasi ini. Pastikan semua data yang diisi saat pemesanan benar dan sesuai dengan identitas asli.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "2. Harga tiket sudah termasuk pajak dan biaya layanan.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "3. Tiket yang sudah dibeli tidak dapat dibatalkan dengan alasan apapun.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "4. Pengembalian dana (refund) tidak berlaku untuk semua jenis tiket.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "5. Tiket yang sudah dibeli tidak dapat diubah jadwalnya. Pemesanan baru harus dilakukan jika ingin mengganti tanggal atau waktu kunjungan.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "6. Tiket hanya berlaku pada tanggal dan waktu yang tercantum pada tiket. Tiket tidak dapat digunakan di luar jadwal tersebut.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "7. Tiket hanya berlaku untuk satu kali penggunaan.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "8. Tiket yang diterima berbentuk tiket elektronik (e-ticket) yang dapat diakses melalui daftar tiket pada aplikasi.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "9. Pengguna wajib menunjukkan e-ticket beserta identitas diri yang sah saat masuk ke lokasi wisata.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "10. Pemalsuan tiket akan dikenakan tindakan hukum sesuai peraturan yang berlaku.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke TambahPesananLanjutanScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPesananScreen(
                        namaWisata: namaWisata,
                        hargaTiket: hargaTiket,
                        namaPemesan: namaPemesan,
                        nik: nik,
                        nomorTelepon: nomorTelepon,
                        alamat: alamat,
                        tanggalKunjungan: tanggalKunjungan,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFF5A189A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Lanjutkan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
