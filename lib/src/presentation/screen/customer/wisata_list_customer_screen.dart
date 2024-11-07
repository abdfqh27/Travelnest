// src/presentation/screen/customer/wisata_list_customer_screen.dart
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/data/model/wisata_category.dart';
import 'package:wisata_app/src/presentation/widget/wisata_list_view.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';
import 'package:wisata_app/src/business_logic/provider/category/category_provider.dart';

class WisataListCustomerScreen extends StatelessWidget {
  const WisataListCustomerScreen({super.key});

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.dice),
        onPressed: () => context.read<ThemeProvider>().switchTheme(),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on_outlined, color: LightThemeColor.accent),
          Text("Location", style: Theme.of(context).textTheme.bodyLarge)
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Badge(
            badgeStyle: const BadgeStyle(badgeColor: LightThemeColor.accent),
            badgeContent: const Text(
              "2",
              style: TextStyle(color: Colors.white),
            ),
            position: BadgePosition.topStart(start: -3),
            child: const Icon(Icons.notifications_none, size: 30),
          ),
        )
      ],
    );
  }

  Widget _searchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search wisata',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Wisata> wisataList = context.watch<WisataProvider>().state.wisataList;
    final List<WisataCategory> categories = context.watch<CategoryProvider>().categories;
    final List<Wisata> filteredWisata = context.watch<CategoryProvider>().filteredWisataList;

    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Morning, Faqih",
                style: Theme.of(context).textTheme.headlineSmall,
              ).fadeAnimation(0.2),
              Text(
                "Explore breathtaking \nlandscapes that await you \nat the summit!",
                style: Theme.of(context).textTheme.displayLarge,
              ).fadeAnimation(0.4),
              _searchBar(),
              Text(
                "Available for you",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (_, index) {
                      WisataCategory category = categories[index];
                      return GestureDetector(
                        onTap: () => context
                            .read<CategoryProvider>()
                            .filterItemByCategory(category),
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: category.isSelected
                                ? LightThemeColor.accent
                                : Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            category.type.name.toCapital,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const Padding(padding: EdgeInsets.only(right: 15));
                    },
                  ),
                ),
              ),
              WisataListView(
                wisatas: filteredWisata,
                isAdmin: false, // Set isAdmin sesuai konteks Customer
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Best wisata of the week",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "See all",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: LightThemeColor.accent),
                      ),
                    ),
                  ],
                ),
              ),
              WisataListView(
                wisatas: wisataList,
                isReversedList: true,
                isAdmin: false, // Set isAdmin sesuai konteks Customer
              ),
            ],
          ),
        ),
      ),
    );
  }
}
