import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/presentation/screen/page/edit_profile.dart';
import 'package:wisata_app/src/presentation/screen/page/login_page.dart';
import '../../../../core/app_asset.dart';
import '../../../business_logic/provider/providers/auth_provider.dart';
import '../../../../core/info_cart.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

class MyProfileCustomerScreen extends StatelessWidget {
  const MyProfileCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Format tanggal dari createdAt
    String joinedDate = "Bergabung sejak tidak diketahui";
    if (user?.createdAt != null) {
      final DateFormat formatter =
          DateFormat('d MMMM yyyy'); // Format: "6 Desember 2024"
      joinedDate = "${formatter.format(user!.createdAt!)}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          " My Profile",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () => _showLogoutConfirmation(context),
        //   ),
        // ],
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
                    color: context.read<ThemeProvider>().isLightTheme
                        ? Colors.black
                        : Colors.white),
              ),
              const SizedBox(height: 5),
              Text(
                'Customer',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
              ),
              const SizedBox(height: 5),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Joined since', // Baris pertama
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                  ),
                  Text(
                    joinedDate, // Baris kedua
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InfoCard(
                icon: Icons.email,
                label: "Email",
                value: user?.email ?? "Email not available",
              ),
              const SizedBox(height: 10),
              InfoCard(
                icon: Icons.person_3_rounded,
                label: "Gender",
                value: user?.jeniskelamin ?? "Gender not available",
              ),
              const SizedBox(height: 10),
              InfoCard(
                icon: Icons.phone,
                label: "No Hp",
                value: user?.nohp ?? "No Hp not available",
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
        title: const Text("Are you sure you want to logout?"),
        content: const Text("Make sure all data is stored safely"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "No",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // ignore: use_build_context_synchronously
      authProvider.signOut(context);
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }
}
