import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/presentation/widget/counter_button.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

// Fungsi untuk memformat harga menjadi format Rupiah
String formatRupiah(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}';
}

class WisataDetailScreenAdmin extends StatefulWidget {
  const WisataDetailScreenAdmin({
    super.key,
    required this.wisata,
  });

  final Wisata wisata;

  @override
  _WisataDetailScreenState createState() => _WisataDetailScreenState();
}

class _WisataDetailScreenState extends State<WisataDetailScreenAdmin> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentIndex = 0;
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Wisata Detail Screen",
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
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  void _nextPage() {
    if (_currentIndex < widget.wisata.carouselImages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final List<Wisata> wisataList = context.watch<WisataProvider>().state.wisataList;

    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Carousel for images from Firebase Storage URLs
                SizedBox(
                  height: 250,
                  child: widget.wisata.carouselImages.isNotEmpty
                      ? PageView.builder(
                          controller: _pageController,
                          itemCount: widget.wisata.carouselImages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Center(
                              child: Image.network(
                                widget.wisata.carouselImages[index], // Load image from URL
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
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
                // Left Arrow
                if (widget.wisata.carouselImages.isNotEmpty)
                  Positioned(
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        if (_currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _pageController.jumpToPage(widget.wisata.carouselImages.length - 1);
                        }
                      },
                    ),
                  ),
                // Right Arrow
                if (widget.wisata.carouselImages.isNotEmpty)
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onPressed: _nextPage,
                    ),
                  ),
                // Page Indicator
                if (widget.wisata.carouselImages.isNotEmpty)
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.wisata.carouselImages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index ? Colors.white : Colors.grey,
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
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and Review Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RatingBar.builder(
                            itemPadding: EdgeInsets.zero,
                            itemSize: 20,
                            initialRating: widget.wisata.score,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            glow: false,
                            ignoreGestures: true,
                            itemBuilder: (_, __) => const FaIcon(
                              FontAwesomeIcons.solidStar,
                              color: LightThemeColor.yellow,
                            ),
                            onRatingUpdate: (_) {},
                          ),
                          const SizedBox(width: 15),
                          Text(
                            widget.wisata.score.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "(${widget.wisata.voter})",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ).fadeAnimation(0.4),
                  const SizedBox(height: 15),
                  // Price and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatRupiah(widget.wisata.price),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: LightThemeColor.accent),
                      ),
                      CounterButton(
                        onIncrementSelected: () => context
                            .read<WisataProvider>()
                            .increaseQuantity(widget.wisata),
                        onDecrementSelected: () => context
                            .read<WisataProvider>()
                            .decreaseQuantity(widget.wisata),
                        label: Text(
                          wisataList.firstWhere((w) => w.id == widget.wisata.id).quantity.toString(),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ],
                  ).fadeAnimation(0.6),
                  const SizedBox(height: 15),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.displayMedium,
                  ).fadeAnimation(0.8),
                  const SizedBox(height: 15),
                  Text(
                    widget.wisata.description,
                    style: Theme.of(context).textTheme.titleMedium,
                  ).fadeAnimation(0.8),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: ElevatedButton(
                        onPressed: () =>
                            context.read<WisataProvider>().addToCart(widget.wisata),
                        child: const Text("Add to cart"),
                      ),
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
