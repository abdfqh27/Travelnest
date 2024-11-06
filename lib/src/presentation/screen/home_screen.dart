import 'profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wisata_app/core/app_data.dart';
import 'package:wisata_app/src/presentation/screen/cart_screen.dart';
import 'package:wisata_app/src/presentation/screen/favorite_screen.dart';
import 'package:wisata_app/src/presentation/screen/wisata_list_screen.dart';
import 'package:wisata_app/src/presentation/animation/page_transition.dart';

class HomeScreen extends HookWidget {
  HomeScreen({super.key});

  final List<Widget> screen = [
    const WisataListScreen(),
    const CartScreen(),
    const FavoriteScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    return Scaffold(
      body: PageTransition(child: screen[selectedIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex.value,
        onTap: (int index) => selectedIndex.value = index,
        selectedFontSize: 0,
        items: AppData.bottomNavigationItems.map(
          (element) {
            return BottomNavigationBarItem(
              icon: element.disableIcon,
              label: element.label,
              activeIcon: element.enableIcon,
            );
          },
        ).toList(),
      ),
    );
  }
}
