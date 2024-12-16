import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_asset.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About TravelNest',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Section
            Center(
              child: Column(
                children: [
                  Image.asset(
                    AppAsset.travelnest, // Replace with your logo asset
                    height: 120,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'TravelNest',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Description Section
            Text(
              'About TravelNest',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: LightThemeColor.accent),
            ),
            const SizedBox(height: 10),
            Text(
              'TravelNest is a modern travel app designed to make it easier for users to find and plan the best travel trips. '
              'With an intuitive interface and rich features, TravelNest is a complete solution for travelers who want to explore interesting destinations, add favorites, and book tours easily.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: context.read<ThemeProvider>().isLightTheme
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Developer Section
            Text(
              'Meet the Developers',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: LightThemeColor.accent),
            ),
            const SizedBox(height: 10),
            const Column(
              children: [
                DeveloperCard(
                  name: 'Abdullah Faqih',
                  role: 'IOS & Android Development',
                  imagePath: AppAsset.faqih,
                ),
                DeveloperCard(
                  name: 'M Abdurahman Almujahid',
                  role: 'IOS & Android Development',
                  imagePath: AppAsset.mujahid,
                ),
                DeveloperCard(
                  name: 'Aufa Tri Hapsari',
                  role: 'IOS & Android Development',
                  imagePath: AppAsset.aufa,
                ),
                DeveloperCard(
                  name: 'M. Fahmi Jazuli',
                  role: 'IOS & Android Development',
                  imagePath: AppAsset.fahmi,
                ),
                DeveloperCard(
                  name: 'A. Rahma Ramadhanti M.N ',
                  role: 'IOS & Android Development',
                  imagePath: AppAsset.rahma,
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Footer Section
            const Center(
              child: Text(
                '© 2024 TravelNest. All Rights Reserved.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;

  const DeveloperCard({
    super.key,
    required this.name,
    required this.role,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      color: context.read<ThemeProvider>().isLightTheme
          ? LightThemeColor.primaryDark
          : DarkThemeColor.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage:
              AssetImage(imagePath), // Replace with developer's photo
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.read<ThemeProvider>().isLightTheme
                ? Colors.black
                : Colors.white,
          ),
        ),
        subtitle: Text(
          role,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
