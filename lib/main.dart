import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wisata_app/firebase_options.dart';
import 'package:wisata_app/src/business_logic/provider/providers/auth_provider.dart';
import 'dart:ui' show PointerDeviceKind;

import 'package:wisata_app/src/presentation/screen/admin/home_admin_screen.dart';
import 'package:wisata_app/src/presentation/screen/customer/home_customer_screen.dart';
import 'package:wisata_app/src/business_logic/provider/category/category_provider.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';
import 'package:wisata_app/core/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inisialisasi Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WisataProvider>(
           create: (context) {
            final provider = WisataProvider();
            provider.fetchFavoritesForCurrentUser(); // Panggil fetchFavorites saat provider dibuat
            return provider;
          },
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            },
          ),
          theme: themeProvider.state.theme,
          home: const SplashScreen(), // Sesuaikan untuk admin atau customer
        ),
      ),
    );
  }
}
