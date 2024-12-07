import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/business_logic/provider/providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await context
          .read<AuthProvider>()
          .changePassword(
            _oldPasswordController.text,
            _newPasswordController.text,
          )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw Exception("Proses terlalu lama. Coba lagi nanti.");
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password berhasil diubah!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengganti password: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      // Bersihkan input setelah selesai
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Lama",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password lama tidak boleh kosong.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Baru",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password baru tidak boleh kosong.";
                  }
                  if (value.length < 6) {
                    return "Password baru harus minimal 6 karakter.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Konfirmasi password tidak boleh kosong.";
                  }
                  if (value != _newPasswordController.text) {
                    return "Password baru dan konfirmasi tidak cocok.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleChangePassword,
                      child: const Text("Ganti Password"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
