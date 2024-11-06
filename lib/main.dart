import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' show PointerDeviceKind;

import 'package:wisata_app/src/data/repository/repository.dart';
import 'package:wisata_app/src/presentation/screen/home_screen.dart';
import 'package:wisata_app/src/business_logic/provider/category/category_provider.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repository>(create: (context) => Repository()),
        ChangeNotifierProvider<WisataProvider>(
          create: (context) => WisataProvider(
            repository: context.read<Repository>(),
          ),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(
            repository: context.read<Repository>(),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
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
          home: HomeScreen(),
        ),
      ),
    );
  }
}
