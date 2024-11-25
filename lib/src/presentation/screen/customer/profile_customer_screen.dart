import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/presentation/screen/customer/edit_profile.dart';
import 'package:wisata_app/src/presentation/screen/page/login_page.dart';
import '../../../../core/app_asset.dart';
import '../../../business_logic/provider/providers/auth_provider.dart';
import '../../../../core/info_cart.dart';

class ProfileCustomerScreen extends StatelessWidget {
  const ProfileCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundImage: user?.photoUrl != null
                    ? NetworkImage(user!.photoUrl)
                    : const AssetImage(AppAsset.profileImage) as ImageProvider,
              ),
              const SizedBox(height: 15),
              Text(
                user?.name ?? "Guest",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                'Customer',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Bergabung sejak 2023',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
              const SizedBox(height: 30),

              InfoCard(
                icon: Icons.email,
                label: "Email",
                value: user?.email ?? "Email not available",
              ),
              const SizedBox(height: 10),
              InfoCard(
                icon: Icons.location_on,
                label: "Address",
                value: user?.address ?? "Address not provided",
              ),
              const SizedBox(height: 10),
              // InfoCard(
              //   icon: Icons.phone,
              //   label: "Phone Number",
              //   value: user?.phone ?? "Phone number not provided",
              // ),
              const SizedBox(height: 30),

              const Text(
                'Recent Activity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              // ActivityCard(
              //   activity: 'Pesanan #1234 - Status: Terkirim',
              //   date: '10 November 2024',
              // ),
              // const SizedBox(height: 10),
              // ActivityCard(
              //   activity: 'Pesanan #1233 - Status: Dibayar',
              //   date: '9 November 2024',
              // ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () {},
              //   child: const Text('Settings'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.greenAccent,
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  authProvider.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Log Out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
