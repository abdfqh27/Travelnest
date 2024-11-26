import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/core/app_icon.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/presentation/widget/empty_widget.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil daftar wisata favorit dari WisataProvider
    final List<Wisata> favoriteWisatas =
        context.watch<WisataProvider>().getFavoriteList;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Screen",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: favoriteWisatas.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: favoriteWisatas.length,
              itemBuilder: (_, index) {
                Wisata wisata = favoriteWisatas[index];
                return Card(
                  color: context.read<ThemeProvider>().isLightTheme
                      ? Colors.white
                      : DarkThemeColor.primaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Text(
                      wisata.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        wisata.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported,
                                color: Colors.grey),
                      ),
                    ),
                    subtitle: Text(
                      wisata.description,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        wisata.isFavorite
                            ? AppIcon.heart
                            : AppIcon.outlinedHeart,
                        color:
                            wisata.isFavorite ? Colors.redAccent : Colors.grey,
                      ),
                      onPressed: () {
                        // Toggle favorite status dan perbarui Firebase
                        context.read<WisataProvider>().toggleFavorite(wisata);
                      },
                    ),
                  ),
                ).fadeAnimation(index * 0.6);
              },
              separatorBuilder: (_, __) =>
                  const Padding(padding: EdgeInsets.only(bottom: 15)),
            )
          : const EmptyWidget(
              type: EmptyWidgetType.favorite,
              title: "Empty Favorite",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Belum ada item favorit",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
