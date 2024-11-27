import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/presentation/screen/page/login_page.dart';
import '../src/presentation/screen/admin/home_admin_screen.dart';
import '../src/presentation/screen/customer/home_customer_screen.dart';
import '../src/business_logic/provider/providers/auth_provider.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder(
      future: authProvider.cekLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (authProvider.isLoggedIn) {
          // Cek role user untuk menentukan halaman
          if (authProvider.user?.role == 'admin') {
            authProvider.fetchUserData(); // Fetch data untuk admin
            return HomeAdminScreen(); // Halaman Admin
          } else {
            authProvider.fetchUserData(); // Fetch data untuk customer
            return HomeCustomerScreen(); // Halaman Customer
          }
        }

        return const LoginPage(); // Jika belum login
      },
    );
  }
}
