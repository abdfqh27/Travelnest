// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/provider/providers/auth_provider.dart';
import 'package:lottie/lottie.dart';
import '../customer/home_customer_screen.dart';
import '../admin/home_admin_screen.dart';
import './signup_page.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  final _formKey = GlobalKey<FormState>(); // GlobalKey untuk form validation
  bool _isEmailError = false;
  bool _isPasswordError = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      setState(() {
        _isEmailError = false;
        _isPasswordError = false;
      });

      // Validasi input
      if (_emailController.text.trim().isEmpty ||
          !_emailController.text.contains('@')) {
        setState(() => _isEmailError = true);
        return;
      }

      if (_passwordController.text.trim().isEmpty) {
        setState(() => _isPasswordError = true);
        return;
      }

      try {
        await authProvider.signIn(
          context,
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (authProvider.user != null &&
            authProvider.user?.email != null &&
            authProvider.user?.role != null) {
          if (authProvider.user?.role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeAdminScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeCustomerScreen()),
            );
          }
        } else {
          if (authProvider.user == null) {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text(
                  'Login Failed',
                  style: TextStyle(color: Colors.black),
                ),
                content: Text('Email or password is incorrect.'),
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
            return;
          }
        }
      } catch (e) {
        print('Login failed: $e');
        setState(() {
          _isEmailError = true;
          _isPasswordError = true;
        });
      }
    }
  }

  // Fungsi untuk menampilkan dialog kesalahan
  // void _showErrorDialog(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Login Failed'),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Lottie.asset(
                    'assets/images/lottie/walk.json',
                    height: screenHeight * 0.2,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome !',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5A189A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Please sign in to continue',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: const Color(0xFF5A189A),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Form untuk validasi
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Enter Your Email',
                            labelStyle: const TextStyle(color: Color(0xFF5A189A)),
                            prefixIcon: const Icon(Icons.email,
                                color: Color(0xFF5A189A)),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF5A189A), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF5A189A), width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          style: const TextStyle(color: Color(0xFF5A189A)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // Tambahkan validasi email dengan RegExp (optional)
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Color(0xFF5A189A)),
                            prefixIcon: const Icon(Icons.lock,
                                color: Color(0xFF5A189A)),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF5A189A), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF5A189A), width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          style: const TextStyle(color: Color(0xFF5A189A)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A189A),
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.2, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF5A189A)),
                    ),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Create a new account',
                      style: TextStyle(color: Color(0xFF5A189A)),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
