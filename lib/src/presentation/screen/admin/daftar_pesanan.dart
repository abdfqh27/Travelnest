// src/presentation/screen/admin/daftar_pesanan_screen.dart
import 'package:flutter/material.dart';

class DaftarPesananScreen extends StatelessWidget {
  const DaftarPesananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Pesanan")),
      body: const Center(child: Text("List of orders will be displayed here")),
    );
  }
}
