import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
//import 'package:wisata_app/src/presentation/screen/customer/home_customer_screen.dart';
import '.././src/presentation/screen/page/login_page.dart';

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
                child: LottieBuilder.asset(
                  'assets/images/lottie/AnimationSplash.json',
                  width: splashIconSize,
                  height: splashIconSize,
                ),
              ),
            ],
          ),
          nextScreen: const LoginPage(),
          splashIconSize: splashIconSize,
          backgroundColor: const Color(0xFF18172B),
        );
      },
    );
  }
}
