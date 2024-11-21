import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_style.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/presentation/screen/admin/wisata_detail_screen_admin.dart';
import 'package:wisata_app/src/presentation/screen/customer/wisata_detail_screen_customer.dart';
import 'package:wisata_app/src/presentation/widget/custom_page_route.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

String formatRupiah(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}';
}

class WisataListView extends StatelessWidget {
  const WisataListView({
    super.key,
    required this.wisatas,
    this.isReversedList = false,
    required this.isAdmin,
  });

  final List<Wisata> wisatas;
  final bool isReversedList;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    if (wisatas.isEmpty) {
      return Center(
        child: Text(
          'Data wisata tidak tersedia untuk kategori ini.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 20, left: 10),
        scrollDirection: Axis.horizontal,
        itemCount: isReversedList ? (wisatas.length < 3 ? wisatas.length : 3) : wisatas.length,
        itemBuilder: (_, index) {
          final wisata = isReversedList ? wisatas.reversed.toList()[index] : wisatas[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: isAdmin
                      ? WisataDetailScreenAdmin(wisata: wisata)
                      : WisataDetailScreenCustomer(wisata: wisata),
                ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Menggunakan Image.network untuk gambar dari Firebase Storage
                  SizedBox(
                    height: 100,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        wisata.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported, size: 50);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tampilkan harga dalam format Rupiah
                  Text(
                    formatRupiah(wisata.price),
                    style: h3Style.copyWith(color: LightThemeColor.accent),
                  ),
                  const SizedBox(height: 5),

                  // Tampilkan nama wisata
                  Expanded(
                    child: Text(
                      wisata.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 20),
      ),
    );
  }
}
