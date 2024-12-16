// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wisata_app/src/presentation/screen/page/login_page.dart';
import '../../../business_logic/provider/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController jeniskelaminController = TextEditingController();
  TextEditingController nohpController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  XFile? _image;
  bool _isLoading = false;
  DateTime? selectedBirthDate;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Batas awal tanggal
      lastDate: DateTime.now(), // Batas akhir tanggal
    );

    if (pickedDate != null) {
      setState(() {
        selectedBirthDate = pickedDate;
        birthDateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}"; // Format tanggal
      });
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = emailController.text;
      String password = passwordController.text;
      String name = nameController.text;
      String jeniskelamin = jeniskelaminController.text;
      String nohp = nohpController.text;
      String address = addressController.text;
      String photoUrl = '';
      DateTime? birthDate = selectedBirthDate;

      if (birthDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your birth date'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        if (_image != null) {
          String fileName =
              'user_photos/${DateTime.now().millisecondsSinceEpoch}.jpg';
          Reference storageRef =
              FirebaseStorage.instance.ref().child('profile_pics/$fileName');

          await storageRef.putFile(File(_image!.path));

          // url gambar
          photoUrl = await storageRef.getDownloadURL();
        }

        // ignore: use_build_context_synchronously
        await Provider.of<AuthProvider>(context, listen: false).signUp(email,
            password, name, jeniskelamin, nohp, address, photoUrl, birthDate);

        // Fetch user data after registration
        await Provider.of<AuthProvider>(context, listen: false).fetchUserData();
        final userModel =
            Provider.of<AuthProvider>(context, listen: false).user;

        if (userModel != null) {
          final registrationTime = userModel.createdAt;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registered on: $registrationTime'),
              backgroundColor: Colors.blue,
            ),
          );
        }

        setState(() {
          _isLoading = false;
        });

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:
            const Text('Create Account', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Create an account to continue',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _image != null ? FileImage(File(_image!.path)) : null,
                      child: _image == null
                          ? const Icon(Icons.add_a_photo,
                              size: 30, color: Colors.white70)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Color(0xFF5A189A),
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter an email'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Color(0xFF5A189A),
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a password'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Color(0xFF5A189A),
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: jeniskelaminController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Color(0xFF5A189A),
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your Gender'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: nohpController,
                  decoration: InputDecoration(
                    labelText: 'No Hp',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Color(0xFF5A189A),
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your No Hp'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: birthDateController,
                  readOnly: true,
                  onTap: _selectBirthDate,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Color(0xFF5A189A),
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    hintText: 'Select your birth date',
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.calendar_today, color: Colors.grey),
                      onPressed:
                          _selectBirthDate, // Panggil fungsi pemilih tanggal
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select your birth date'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Add border radius
                      borderSide: const BorderSide(
                        color: Color(0xFF5A189A),
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your address'
                      : null,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A189A),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
