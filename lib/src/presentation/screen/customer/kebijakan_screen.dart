import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Policies",
          style: Theme.of(context).textTheme.displayMedium,
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
                  color: context.read<ThemeProvider>().isLightTheme
                          ? LightThemeColor.primaryDark
                          : DarkThemeColor.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: const [
                    Text(
                      "1. Tickets can only be purchased through this application. Make sure all data filled in when ordering is correct and matches the original identity.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "2. Ticket prices include taxes and service charges.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "3. Tickets that have been purchased cannot be cancelled for any reason.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "4. Refunds do not apply to all types of tickets.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "5. Tickets that have been purchased cannot be rescheduled. A new booking must be made if you wish to change the date or time of your visit.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "6. Tickets are only valid on the date and time stated on the ticket. Tickets cannot be used outside of these schedules.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "7. Tickets are valid for one time use only.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "8. The tickets received are in the form of electronic tickets (e-tickets) which can be accessed via the ticket list in the application.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "9. Users are required to show an e-ticket along with valid identification when entering the tourist location.",
                      style: TextStyle(color: Color(0xFF7B7B7B)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "10. Ticket counterfeiting will be subject to legal action in accordance with applicable regulations.",
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
                  "Continue",
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
