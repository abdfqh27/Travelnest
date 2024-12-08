import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/provider/providers/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _jeniskelaminController;
  late TextEditingController _nohpController;
  late TextEditingController _addressController;
  DateTime? _selectedBirthDate;
  File? _newPhoto;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    _nameController = TextEditingController(text: user?.name ?? "");
    _jeniskelaminController =
        TextEditingController(text: user?.jeniskelamin ?? "");
    _nohpController = TextEditingController(text: user?.nohp ?? "");
    _selectedBirthDate = user?.birthDate;
    _addressController = TextEditingController(text: user?.address ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jeniskelaminController.dispose();
    _nohpController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedBirthDate = pickedDate;
      });
    }
  }

  Future<void> _showConfirmationDialog() async {
    final shouldSave = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Apakah Anda yakin ingin melakukan perubahan?"),
        content: const Text("Pastikan semua data sudah benar"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      _saveProfileChanges();
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // ke profil
    }
  }

  Future<void> _saveProfileChanges() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateUserProfile(
        _nameController.text,
        _jeniskelaminController.text,
        _nohpController.text,
        _selectedBirthDate,
        _addressController.text,
        _newPhoto,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile",
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _newPhoto != null
                      ? FileImage(_newPhoto!)
                      : (user?.photoUrl != null
                          ? NetworkImage(user!.photoUrl)
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _jeniskelaminController,
                decoration: const InputDecoration(
                  labelText: "Jenis Kelamin",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please enter your gender'
                      : null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nohpController,
                decoration: const InputDecoration(
                  labelText: "No Hp",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please enter your no hp'
                      : null;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _selectBirthDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: _selectedBirthDate != null
                          ? "${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}"
                          : "",
                    ),
                    decoration: InputDecoration(
                      labelText: "Birth Date",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: const Color(0xFF5A189A), // Ubah warna ikon di sini
                        ),
                        onPressed:
                            _selectBirthDate, // Panggil fungsi pemilih tanggal
                      ),
                    ),
                    validator: (value) {
                      return value == null || value.isEmpty
                          ? 'Please select your birth date'
                          : null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please enter your address'
                      : null;
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
