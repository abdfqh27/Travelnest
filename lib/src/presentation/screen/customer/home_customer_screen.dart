import 'profile_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wisata_app/core/app_data.dart';
import 'package:wisata_app/src/presentation/screen/customer/cart_screen.dart';
import 'package:wisata_app/src/presentation/screen/customer/favorite_screen.dart';
import 'package:wisata_app/src/presentation/screen/customer/wisata_list_customer_screen.dart';
import 'package:wisata_app/src/presentation/animation/page_transition.dart';

class HomeCustomerScreen extends HookWidget {
  HomeCustomerScreen({super.key});

  final List<Widget> screen = [
    const WisataListCustomerScreen(),
    const CartScreen(),
    const FavoriteScreen(),
    const ProfileCustomerScreen()
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
