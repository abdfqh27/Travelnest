import 'package:flutter/material.dart';
import 'package:wisata_app/core/app_asset.dart';

class ProfileAdminScreen extends StatelessWidget {
  const ProfileAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Image.asset(AppAsset.profileImage, width: 300),
          ),
          Text(
            "Hello Faqih Ini costumer!",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAsset.githubImage, width: 60),
              const SizedBox(width: 10),
              Text(
                "https://github.com/abdfqh27",
                style: Theme.of(context).textTheme.displaySmall,
              )
            ],
          )
        ],
      ),
    );
  }
}
