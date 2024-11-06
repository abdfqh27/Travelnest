import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_style.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/presentation/screen/wisata_detail_screen.dart';
import 'package:wisata_app/src/presentation/widget/custom_page_route.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

// Fungsi untuk memformat harga menjadi format Rupiah
String formatRupiah(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}';
}

class WisataListView extends StatelessWidget {
  const WisataListView({
    super.key,
    required this.wisatas,
    this.isReversedList = false,
  });

  final List<Wisata> wisatas;
  final bool isReversedList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // Tinggi disesuaikan agar cukup
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 20, left: 10),
        scrollDirection: Axis.horizontal,
        itemCount: isReversedList ? 3 : wisatas.length,
        itemBuilder: (_, index) {
          Wisata wisata =
              isReversedList ? wisatas.reversed.toList()[index] : wisatas[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(child: WisataDetailScreen(wisata: wisata)),
              );
            },
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.read<ThemeProvider>().isLightTheme
                    ? Colors.white
                    : DarkThemeColor.primaryLight,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Ubah ke `start`
                children: [
                  // Membungkus gambar dengan Container
                  SizedBox(
                    height: 100,
                    width: 120, // Berikan tinggi spesifik pada gambar
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        wisata.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Menambahkan jarak antara gambar dan teks
                  
                  // Ubah tampilan harga menjadi format Rupiah
                  Text(
                    formatRupiah(wisata.price),
                    style: h3Style.copyWith(color: LightThemeColor.accent),
                  ),
                  const SizedBox(height: 5), // Menambahkan jarak antar elemen
                  
                  // Tampilkan nama makanan
                  Expanded( // Menambahkan `Expanded` agar teks tidak overflow
                    child: Text(
                      wisata.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Mengatasi overflow teks
                      maxLines: 1, // Batasi jumlah baris
                      textAlign: TextAlign.center, // Posisikan di tengah
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) {
          return const Padding(padding: EdgeInsets.only(right: 50));
        },
      ),
    );
  }
}
