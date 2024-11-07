import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wisata_app/core/app_data.dart';
import 'package:wisata_app/src/presentation/screen/admin/daftar_pesanan.dart';
import 'package:wisata_app/src/presentation/screen/admin/daftar_wisata.dart';
import 'package:wisata_app/src/presentation/screen/admin/wisata_list_admin_screen.dart';
import 'package:wisata_app/src/presentation/animation/page_transition.dart';
import 'package:wisata_app/src/presentation/screen/admin/profile_admin_screen.dart';

class HomeAdminScreen extends HookWidget {
  HomeAdminScreen({super.key});

  final List<Widget> screen = [
    const WisataListAdminScreen(),
    const DaftarPesananScreen(),
    const DaftarWisataScreen(),
    const ProfileAdminScreen()
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
        items: AppData.bottomNavigationItemsadmin.map(
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
