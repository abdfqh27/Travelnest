import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';
import 'package:wisata_app/src/presentation/screen/customer/ticket_detail_screen.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ticket Screen",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: currentUser == null
          ? Center(
              child: Text(
                "User not found.",
                style: TextStyle(
                  color: context.read<ThemeProvider>().isLightTheme
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pesanan')
                  .where('userId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("There is no order data.",
                        style: TextStyle(
                          color: context.read<ThemeProvider>().isLightTheme
                              ? Colors.black
                              : Colors.white,
                        )),
                  );
                }

                final pesananList = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: pesananList.length,
                  itemBuilder: (context, index) {
                    final pesanan = pesananList[index];
                    final namaWisata = pesanan['namaWisata'] ?? '';
                    final hargaTiket = pesanan['hargaTiket'] ?? '';
                    final namaPemesan = pesanan['namaPemesan'] ?? '';
                    final nik = pesanan['nik'] ?? '';
                    final nomorTelepon = pesanan['nomorTelepon'] ?? '';
                    final alamat = pesanan['alamat'] ?? '';
                    final tanggalKunjungan = pesanan['tanggalKunjungan'] ?? '';
                    final documentId = pesanan.id; // Mengambil document ID
                    final kodePemesanan =
                        documentId.substring(0, 5); // 5 karakter pertama

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketDetailScreen(
                              namaWisata: namaWisata,
                              kodePemesanan: kodePemesanan,
                              namaPemesan: namaPemesan,
                              nik: nik,
                            ),
                          ),
                        );
                      },
                      child: Padding(
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
                                    color: context
                                            .read<ThemeProvider>()
                                            .isLightTheme
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                    context, "Order Code: $kodePemesanan", ""),
                                _buildDetailRow(context, "$namaPemesan", nik),
                                _buildDetailRow(context, nomorTelepon, ""),
                                _buildDetailRow(context, alamat, ""),
                                _buildDetailRow(context, tanggalKunjungan, hargaTiket),
                              ],
                            ),
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
                /* fontWeight: FontWeight.bold, */
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
