import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:wisata_app/core/app_asset.dart';
import 'package:wisata_app/core/root_screen.dart';
//import 'package:wisata_app/src/presentation/screen/page/login_page.dart';
//import './root_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double splashIconSize = constraints.maxWidth * 0.8;

        return AnimatedSplashScreen(
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  AppAsset.travelnest,
                  width: splashIconSize,
                  height: splashIconSize,
                ),
              ),
            ],
          ),
          nextScreen: const RootScreen(),
          splashIconSize: splashIconSize,
          backgroundColor: const Color(0xFF18172B),
        );
      },
    );
  }
}
