// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/business_logic/provider/providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  Future<void> _validateOldPassword() async {
    setState(() {
      _oldPasswordError = null; // Reset error
    });

    try {
      final email = context.read<AuthProvider>().user?.email;

      if (email == null) {
        throw Exception("Unable to retrieve user email.");
      }

      final isValid = await context
          .read<AuthProvider>()
          .validateOldPassword(email, _oldPasswordController.text);

      if (!isValid) {
        setState(() {
          _oldPasswordError = "Old password is incorrect.";
        });
      }
    } catch (e) {
      setState(() {
        _oldPasswordError = "An error occurred while validating old password.";
      });
    }
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _oldPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    try {
      final email = context.read<AuthProvider>().user?.email;

      if (email == null) {
        throw Exception("Unable to retrieve user email.");
      }

      // Validasi password lama
      final isValid = await context
          .read<AuthProvider>()
          .validateOldPassword(email, _oldPasswordController.text);

      if (!isValid) {
        setState(() {
          _oldPasswordError = "Old password is incorrect.";
        });
        return;
      }

      // Jika password lama valid, lanjutkan mengganti password
      await context.read<AuthProvider>().changePassword(
            _oldPasswordController.text,
            _newPasswordController.text,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _oldPasswordError = "An error occurred while changing password.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // OLD PASSWORD FIELD
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  errorText: _oldPasswordError,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: BorderSide(
                      color: _oldPasswordError != null
                          ? Colors.red
                          : const Color(0xFF5A189A),
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "The old password cannot be empty.";
                  }
                  return null;
                },
                onChanged: (_) {
                  if (_oldPasswordError != null) {
                    setState(() {
                      _oldPasswordError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // NEW PASSWORD FIELD
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  errorText: _newPasswordError,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: BorderSide(
                      color: _newPasswordError != null
                          ? Colors.red
                          : const Color(0xFF5A189A),
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
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
                onChanged: (_) {
                  if (_newPasswordError != null) {
                    setState(() {
                      _newPasswordError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // CONFIRM PASSWORD FIELD
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  errorText: _confirmPasswordError,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Colors.red
                          : const Color(0xFF5A189A),
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
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
                onChanged: (_) {
                  if (_confirmPasswordError != null) {
                    setState(() {
                      _confirmPasswordError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              // SUBMIT BUTTON
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
