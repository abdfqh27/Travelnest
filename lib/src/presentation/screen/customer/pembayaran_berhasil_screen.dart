import 'package:flutter/material.dart';

class KonfirmasiPembayaranScreen extends StatelessWidget {
  final String totalPembayaran;
  final String tanggal;

  const KonfirmasiPembayaranScreen({
    Key? key,
    required this.totalPembayaran,
    required this.tanggal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F30),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F30),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Pembayaran Berhasil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              "Payment Notification Sent",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Check your Dana Account to make payment",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF292940),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Complete payment immediately on DANA application in 55 seconds",
                      style: TextStyle(
                        color: Color(0xFF7B7B7B),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "How to Pay With DANA",
                      style: TextStyle(
                        color: Color(0xFF7B7B7B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "1. Open the DANA application and log in with your registered phone number (example: 08123456789).\n"
                      "2. Tap on the 'Payment Notification' displayed on your DANA app homepage to view the payment details.\n"
                      "3. Confirm the payment and ensure it is completed within the specified time limit to avoid transaction timeout.\n"
                      "4. If you experience any issues, please retry or contact our support team for assistance.",
                      style: TextStyle(
                        color: Color(0xFF7B7B7B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF292940),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem("Date", tanggal),
                    _buildDetailItem("Kode Pemesanan", "A10271088773"),
                    _buildDetailItem("Payment Metode", "Dana"),
                    _buildDetailItem("Total Pembayaran", " $totalPembayaran"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A189A),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Back Go Home",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF7B7B7B), fontSize: 14)),
          Text(value, style: const TextStyle(color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
