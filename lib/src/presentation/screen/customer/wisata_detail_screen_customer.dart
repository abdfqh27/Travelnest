import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';
import 'package:wisata_app/src/presentation/screen/customer/tambah_pesanan_screen.dart';

String formatRupiah(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}';
}

class WisataDetailScreenCustomer extends StatefulWidget {
  const WisataDetailScreenCustomer({
    super.key,
    required this.wisata,
  });

  final Wisata wisata;

  @override
  // ignore: library_private_types_in_public_api
  _WisataDetailScreenState createState() => _WisataDetailScreenState();
}

class _WisataDetailScreenState extends State<WisataDetailScreenCustomer> {
  late PageController _pageController;
  late int _currentIndex;
  late Wisata currentWisata;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentIndex = 0;
    currentWisata = widget.wisata;
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Wisata Detail",
        style: TextStyle(
          color: context.read<ThemeProvider>().isLightTheme
              ? Colors.black
              : Colors.white,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  void _nextPage() {
    if (_currentIndex < currentWisata.carouselImages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Jika sudah di gambar terakhir, kembali ke gambar pertama
      _pageController.jumpToPage(0);
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Jika sudah di gambar pertama, kembali ke gambar terakhir
      final lastIndex = currentWisata.carouselImages.length - 1;
      _pageController.jumpToPage(lastIndex);
      setState(() {
        _currentIndex = lastIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final WisataProvider wisataProvider = context.read<WisataProvider>();

    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Carousel Images
                SizedBox(
                  height: 250,
                  child: currentWisata.carouselImages.isNotEmpty
                      ? PageView.builder(
                          controller: _pageController,
                          itemCount: currentWisata.carouselImages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Center(
                              child: Image.network(
                                currentWisata.carouselImages[index],
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 100,
                          ),
                        ),
                ),
                // Carousel Arrows
                if (currentWisata.carouselImages.isNotEmpty) ...[
                  // Left Arrow
                  Positioned(
                    left: 10,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: _previousPage,
                    ),
                  ),
                  // Right Arrow
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      onPressed: _nextPage,
                    ),
                  ),
                ],
                // Carousel Page Indicator
                Positioned(
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      currentWisata.carouselImages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wisata Name and Favorite Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentWisata.name,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: LightThemeColor.accent)),
                      IconButton(
                        icon: Icon(
                          currentWisata.isFavorite
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: currentWisata.isFavorite
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () async {
                          wisataProvider.toggleFavorite(currentWisata);

                          // Perbarui state dengan data terbaru
                          setState(() {
                            currentWisata =
                                wisataProvider.wisataList.firstWhere(
                              (w) => w.id == currentWisata.id,
                              orElse: () => currentWisata,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Harga dengan Format Rupiah
                  Text(
                    formatRupiah(currentWisata.price),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: LightThemeColor.accent),
                  ),
                  const SizedBox(height: 15),
                  // Lokasi dengan Ikon Lokasi
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: LightThemeColor.accent, // Ikon lokasi dengan warna merah
                        size: 24,
                      ),
                      const SizedBox(
                          width: 8), // Spasi kecil antara ikon dan teks
                      Expanded(
                        child: Text(
                          currentWisata.location, // Lokasi wisata
                          style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: LightThemeColor.accent),
                          overflow: TextOverflow
                              .ellipsis, // Batasi teks jika terlalu panjang
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Deskripsi:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentWisata.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TambahPesananScreen(wisata: widget.wisata),
                          ),
                      ),
                      child: const Text("Pesan Wisata"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
