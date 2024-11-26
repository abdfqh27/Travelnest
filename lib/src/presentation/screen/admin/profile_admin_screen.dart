import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/presentation/screen/customer/edit_profile.dart';
import 'package:wisata_app/src/presentation/screen/page/login_page.dart';
import '../../../../core/app_asset.dart';
import '../../../business_logic/provider/providers/auth_provider.dart';
import '../../../../core/info_cart.dart';

class ProfileAdminScreen extends StatelessWidget {
  const ProfileAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 45),
              CircleAvatar(
                radius: 55,
                child: ClipOval(
                  child: user?.photoUrl != null
                      ? Image.network(
                          user!.photoUrl,
                          fit: BoxFit.cover,
                          width: 110,
                          height: 110,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.error,
                            size: 55,
                          ),
                        )
                      : const Image(
                          image: AssetImage(AppAsset.profileImage),
                          fit: BoxFit.cover,
                          width: 110,
                          height: 110,
                        ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                user?.name ?? "Guest",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                'Admin',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
              ),
              const SizedBox(height: 5),
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
              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A189A),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final shouldLogout = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Apakah Anda yakin ingin keluar?"),
        content: const Text("Pastikan semua data sudah aman tersimpan"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Tidak",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Ya",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      authProvider.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }
}
