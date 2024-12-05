import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisata_app/src/presentation/screen/customer/ticket_detail_screen.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ticket Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: currentUser == null
          ? const Center(
              child: Text(
                "User tidak ditemukan.",
                style: TextStyle(color: Colors.white),
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
                  return const Center(
                    child: Text(
                      "Tidak ada data pesanan.",
                      style: TextStyle(color: Colors.white),
                    ),
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
                    final kodePemesanan = documentId.substring(0, 5); // 5 karakter pertama

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
                                _buildDetailRow("$namaPemesan", nik),
                                _buildDetailRow(nomorTelepon, ""),
                                _buildDetailRow(alamat, ""),
                                _buildDetailRow(tanggalKunjungan, hargaTiket),
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
