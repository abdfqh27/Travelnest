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
        throw Exception("Process is taking too long. Please try again later.");
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to change password: $e")),
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
      appBar: AppBar(
          title: Text(
        "Change Password",
        style: Theme.of(context).textTheme.displayMedium,
      )),
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
                  labelText: "Old Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "The old password cannot be empty.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "The new password cannot be empty.";
                  }
                  if (value.length < 6) {
                    return "New password must be at least 6 characters.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm New Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirmation password cannot be empty.";
                  }
                  if (value != _newPasswordController.text) {
                    return "New password and confirmation do not match.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleChangePassword,
                      child: const Text("Change Password"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
