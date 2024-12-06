import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

// Definisi kSpacingUnit
const double kSpacingUnit = 10.0;

// Definisi kTitleTextStyle
final TextStyle kTitleTextStyle = TextStyle(
  fontSize: 16.0, // Ganti sp dengan ukuran tetap
  color: Colors.white, // Sesuaikan dengan tema
);

class ProfileListItem extends StatelessWidget {
  final IconData icon; // Ikon
  final String text; // Teks
  final VoidCallback? onTap; // Aksi saat item ditekan

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });
  

  @override
  Widget build(BuildContext context) {
    final isLightTheme = context.read<ThemeProvider>().isLightTheme;

    final textColor = isLightTheme ? Colors.black : Colors.white;
    final iconColor = isLightTheme ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: onTap, // Respon jika onTap tidak null
      child: Container(
        height: 55.0, // Ukuran tetap untuk tinggi
        margin: const EdgeInsets.symmetric(
          horizontal: kSpacingUnit * 2,
        ).copyWith(
          bottom: kSpacingUnit,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: kSpacingUnit * 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSpacingUnit * 2),
          color: isLightTheme
              ? LightThemeColor.primaryDark
              : DarkThemeColor.primaryLight,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 24.0, // Ukuran tetap untuk ikon
              color: const Color(0xFF5A189A),
            ),
            const SizedBox(width: kSpacingUnit * 1.5),
            Text(
              text,
              style: kTitleTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const Spacer(),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16, // Ukuran tetap untuk panah navigasi
                color: iconColor, // Warna sesuai tema
              ),
          ],
        ),
      ),
    );
  }
}
