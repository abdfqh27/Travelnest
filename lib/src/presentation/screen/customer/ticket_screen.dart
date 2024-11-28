import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/core/app_style.dart';
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/presentation/widget/empty_widget.dart';
import 'package:wisata_app/src/presentation/widget/counter_button.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

// Fungsi untuk memformat harga menjadi format Rupiah
String formatRupiah(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}';
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Ticket Screen",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //state management
    final List<Wisata> cartWisata = context.watch<WisataProvider>().getCartList;
    final double totalPrice = context.read<WisataProvider>().getTotalPrice;

    Widget cartListView() {
      return ListView.separated(
        padding: const EdgeInsets.all(30),
        itemCount: cartWisata.length,
        itemBuilder: (_, index) {
          return Dismissible(
            onDismissed: (direction) {
              context.read<WisataProvider>().removeItem(cartWisata[index]);
            },
            key: Key(cartWisata[index].id),
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const FaIcon(FontAwesomeIcons.trash, color: Colors.white),
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: context.read<ThemeProvider>().isLightTheme
                    ? Colors.white
                    : DarkThemeColor.primaryLight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 20),
                  // Menggunakan Image.network untuk mengambil gambar dari URL Firebase
                  Image.network(
                    cartWisata[index].image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                    },
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartWisata[index].name,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatRupiah(cartWisata[index].price),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      CounterButton(
                        onIncrementSelected: () => context
                            .read<WisataProvider>()
                            .increaseQuantity(cartWisata[index]),
                        onDecrementSelected: () => context
                            .read<WisataProvider>()
                            .decreaseQuantity(cartWisata[index]),
                        size: const Size(24, 24),
                        padding: 0,
                        label: Text(
                          cartWisata[index].quantity.toString(),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      Text(
                        formatRupiah(context
                            .read<WisataProvider>()
                            .pricePerEachItem(cartWisata[index])),
                        style: h2Style.copyWith(color: LightThemeColor.accent),
                      ),
                    ],
                  ),
                ],
              ),
            ).fadeAnimation(index * 0.6),
          );
        },
        separatorBuilder: (_, __) {
          return const Padding(padding: EdgeInsets.all(10));
        },
      );
    }

    return Scaffold(
      appBar: _appBar(context),
      body: cartWisata.isEmpty
          ? EmptyWidget(
              title: "Ticket Kosong",
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum ada item di keranjang",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                      child: const Text("Tambah Item"),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: cartListView(),
                ),
                // Bagian Total Pesanan dan Tombol Pesan
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Teks "Total Pesanan"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Pesanan",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            formatRupiah(totalPrice),
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Tombol "Pesan"
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            // Logika pemesanan di sini
                          },
                          child: const Text("Pesan"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
