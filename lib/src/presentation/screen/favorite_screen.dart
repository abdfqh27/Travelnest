import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_icon.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/presentation/widget/empty_widget.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Wisata> favoriteWisatas =
        context.watch<WisataProvider>().getFavoriteList;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite screen",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: EmptyWidget(
        type: EmptyWidgetType.favorite,
        title: "Empty favorite",
        condition: favoriteWisatas.isNotEmpty,
        child: ListView.separated(
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
                leading: Image.asset(wisata.image),
                subtitle: Text(
                  wisata.description,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                trailing: const Icon(AppIcon.heart, color: Colors.redAccent),
              ),
            ).fadeAnimation(index * 0.6);
          },
          separatorBuilder: (_,__) {
            return const Padding(padding: EdgeInsets.only(bottom: 15));
          },
        ),
      ),
    );
  }
}
