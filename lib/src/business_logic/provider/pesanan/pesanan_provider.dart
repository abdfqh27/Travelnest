import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PesananProvider {
  final CollectionReference pesananCollection =
      FirebaseFirestore.instance.collection('pesanan');

  // Tambahkan Pesanan ke Firebase
  Future<void> tambahPesanan(Map<String, dynamic> data) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("User tidak ditemukan. Harap login kembali.");
      }

      // Tambahkan userId ke data sebelum disimpan
      data['userId'] = currentUser.uid;

      await pesananCollection.add(data);
    } catch (e) {
      throw Exception("Gagal menyimpan pesanan: $e");
    }
  }

  // Ambil semua pesanan (khusus untuk admin)
  Future<List<Map<String, dynamic>>> getSemuaPesanan() async {
    try {
      final snapshot = await pesananCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Tambahkan ID dokumen ke dalam data
        return data;
      }).toList();
    } catch (e) {
      throw Exception("Gagal mengambil semua pesanan: $e");
    }
  }

  // Ambil pesanan berdasarkan userId (untuk user biasa)
  Future<List<Map<String, dynamic>>> getPesananByUserId(String userId) async {
    try {
      final snapshot = await pesananCollection.where('userId', isEqualTo: userId).get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception("Gagal mengambil pesanan untuk user: $e");
    }
  }
}
