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
    // Provider untuk Wisata
    final wisataProvider = context.read<WisataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Screen",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: FutureBuilder<void>(
        future: wisataProvider.fetchFavoritesForCurrentUser(),
        builder: (context, snapshot) {
          // Tampilkan loading indicator saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tampilkan error jika ada masalah saat pengambilan data
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan saat memuat data favorit.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          // Ambil daftar wisata favorit
          final favoriteWisatas = wisataProvider.getFavoriteList;

          // Tampilkan UI sesuai dengan data favorit
          return favoriteWisatas.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.all(15),
                  itemCount: favoriteWisatas.length,
                  itemBuilder: (_, index) {
                    final wisata = favoriteWisatas[index];
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
                            AppIcon.heart,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            // Toggle status favorit
                            await wisataProvider.toggleFavorite(wisata);
                            // Refresh data favorit setelah perubahan
                            await wisataProvider.fetchFavoritesForCurrentUser();
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
                );
        },
      ),
    );
  }
}
