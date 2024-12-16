import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import 'package:wisata_app/src/presentation/screen/customer/kebijakan_screen.dart';
import 'package:wisata_app/src/presentation/screen/customer/detail_pesanan_screen.dart';
import 'package:intl/intl.dart'; // Untuk memformat tanggal

class TambahPesananScreen extends StatefulWidget {
  const TambahPesananScreen({super.key, required this.wisata});

  final Wisata wisata;

  @override
  State<TambahPesananScreen> createState() => _TambahPesananScreenState();
}

class _TambahPesananScreenState extends State<TambahPesananScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alamatController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fungsi untuk memformat harga ke dalam format Rupiah
    String formatRupiah(double amount) {
      return 'Rp ${amount.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Form",
          style: Theme.of(context).textTheme.displayMedium, // Warna teks putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Wisata (Tidak Bisa Diubah)
                TextFormField(
                  initialValue: widget.wisata.name,
                  decoration: InputDecoration(
                    labelText: "Tour Name",
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
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                // Harga Tiket (Tidak Bisa Diubah)
                TextFormField(
                  initialValue: formatRupiah(widget.wisata.price),
                  decoration: InputDecoration(
                    labelText: "Ticket Price",
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
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                // Jumlah Tiket (Tidak Bisa Diubah)
                /* TextFormField(
                  initialValue: widget.wisata.quantity.toString(),
                  decoration: const InputDecoration(
                    labelText: "Jumlah Tiket",
                  ),
                  readOnly: true,
                ), */
                /* const SizedBox(height: 16), */
                // Nama Pemesan
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Booker Name",
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
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      )),
                  validator: (value) => value == null || value.isEmpty
                      ? "Booker Name Required"
                      : null,
                ),
                const SizedBox(height: 16),
                // NIK
                TextFormField(
                  controller: _nikController,
                  decoration: InputDecoration(
                    labelText: "NIK",
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
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2.0,
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
                  validator: (value) =>
                      value == null || value.isEmpty ? "NIK Required" : null,
                ),
                const SizedBox(height: 16),
                // Nomor Telepon
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "No. Handphone",
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
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2.0,
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
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty
                      ? "Mobile phone number required"
                      : null,
                ),
                const SizedBox(height: 16),
                // Nama Pengunjung
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: "Address",
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
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2.0,
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
                  validator: (value) => value == null || value.isEmpty
                      ? "Address Required"
                      : null,
                ),
                const SizedBox(height: 16),
                // Tanggal Kunjungan
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date",
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
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2.0,
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
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? ""
                        : DateFormat('dd MMM yyyy').format(_selectedDate!),
                  ),
                  onTap: () => pickDate(context),
                  validator: (value) =>
                      _selectedDate == null ? "Date Required" : null,
                ),
                const SizedBox(height: 16),
                // Tombol Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Navigasi ke halaman detail pesanan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KebijakanScreen(
                              namaWisata: widget.wisata.name,
                              hargaTiket: formatRupiah(widget.wisata.price),
                              /* jumlahTiket: widget.wisata.quantity, */
                              namaPemesan: _nameController.text,
                              nik: _nikController.text,
                              nomorTelepon: _phoneController.text,
                              alamat: _alamatController.text,
                              tanggalKunjungan: _selectedDate == null
                                  ? ""
                                  : DateFormat('dd MMM yyyy')
                                      .format(_selectedDate!),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Border radius 8
                      ),
                      backgroundColor:
                          const Color(0xFF5A189A), // Warna tombol (contoh)
                      padding: const EdgeInsets.symmetric(
                          vertical: 16), // Padding vertikal
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
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
