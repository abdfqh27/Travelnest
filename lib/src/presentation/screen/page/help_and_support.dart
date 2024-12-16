import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_asset.dart';
import 'package:wisata_app/core/app_color.dart';
import 'package:wisata_app/src/business_logic/provider/theme/theme_provider.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Image.asset(
                    AppAsset.travelnest, // Logo aplikasi
                    height: 120,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'TravelNest Support',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: context.read<ThemeProvider>().isLightTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // General Info Section
            Text(
              'How can we help you?',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: LightThemeColor.accent),
            ),
            const SizedBox(height: 10),
            Text(
              'At TravelNest, we aim to make your travel planning seamless and enjoyable. If you have any questions, encounter any issues, or just need assistance, you’re in the right place.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: context.read<ThemeProvider>().isLightTheme
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Contact Section
            Text(
              'Contact Us',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: LightThemeColor.accent),
            ),
            const SizedBox(height: 10),
            Card(
              color: context.read<ThemeProvider>().isLightTheme
                  ? LightThemeColor.primaryDark
                  : DarkThemeColor.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.email, color: Color(0xFF5A189A)),
                title: Text(
                  'Email Support',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.read<ThemeProvider>().isLightTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                subtitle: Text(
                  'support@travelnest.com',
                  style: TextStyle(
                    color: context.read<ThemeProvider>().isLightTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                onTap: () {
                  // Add email functionality if needed
                },
              ),
            ),
            Card(
              color: context.read<ThemeProvider>().isLightTheme
                  ? LightThemeColor.primaryDark
                  : DarkThemeColor.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Color(0xFF5A189A)),
                title: Text(
                  'Call Us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.read<ThemeProvider>().isLightTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                subtitle: Text(
                  '+1 234 567 890',
                  style: TextStyle(
                    color: context.read<ThemeProvider>().isLightTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                onTap: () {
                  // Add phone functionality if needed
                },
              ),
            ),
            Card(
              color: context.read<ThemeProvider>().isLightTheme
                  ? LightThemeColor.primaryDark
                  : DarkThemeColor.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: const Icon(Icons.chat, color: Color(0xFF5A189A)),
                title: Text(
                  'Live Chat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.read<ThemeProvider>().isLightTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Chat with our support team',
                  style: TextStyle(
                    color: context.read<ThemeProvider>().isLightTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                onTap: () {
                  // Add chat functionality if needed
                },
              ),
            ),
            const SizedBox(height: 20),
            // FAQ Section
            Text(
              'Frequently Asked Questions (FAQ)',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: LightThemeColor.accent),
            ),
            const SizedBox(height: 10),
            const FAQItem(
              question: 'How do I book a trip?',
              answer:
                  'To book a trip, browse through our destinations, select the one you like, and follow the booking instructions provided on the page.',
            ),
            const FAQItem(
              question: 'Can I cancel or modify a booking?',
              answer:
                  'Yes, cancellations and modifications can be made from your account page. Please note that cancellation policies vary by destination.',
            ),
            const FAQItem(
              question: 'How do I contact customer support?',
              answer:
                  'You can contact us via email, phone, or live chat. See the contact section above for details.',
            ),
            const FAQItem(
              question: 'Is my payment information secure?',
              answer:
                  'Absolutely. TravelNest uses advanced encryption to ensure your payment information is safe and secure.',
            ),
            const SizedBox(height: 30),
            // Footer Section
            const Center(
              child: Text(
                '© 2024 TravelNest. All Rights Reserved.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.read<ThemeProvider>().isLightTheme
          ? LightThemeColor.primaryDark
          : DarkThemeColor.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.read<ThemeProvider>().isLightTheme
                ? Colors.black
                : Colors.white,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.answer,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: context.read<ThemeProvider>().isLightTheme
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
      ),
    );
  }
}
