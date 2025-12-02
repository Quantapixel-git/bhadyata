import 'package:flutter/material.dart';
import 'package:jobshub/common/utils/app_color.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f4f8),

      appBar: AppBar(
        elevation: 0.8,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Contact Us",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _leftInfoCard()),
                          const SizedBox(width: 28),
                          Expanded(child: _contactForm(context)),
                        ],
                      )
                    : Column(
                        children: [
                          _leftInfoCard(),
                          const SizedBox(height: 24),
                          _contactForm(context),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =====================================================
  // LEFT SIDE — Contact Info Card
  // =====================================================
  Widget _leftInfoCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Get in Touch",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We're here to help! Reach out to us for any queries, support, or business inquiries.",
              style: TextStyle(
                fontSize: 14.5,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 28),

            _contactInfoTile(
              icon: Icons.email_outlined,
              title: "Email",
              value: "support@badhyata.com",
            ),

            const SizedBox(height: 20),

            _contactInfoTile(
              icon: Icons.phone_forwarded_outlined,
              title: "Phone",
              value: "+91 98765 43210",
            ),

            const SizedBox(height: 20),

            _contactInfoTile(
              icon: Icons.location_on_outlined,
              title: "Address",
              value: "Badhyata HQ, Noida, Uttar Pradesh, India",
            ),

            const SizedBox(height: 30),

            // Social Icons
            const Text(
              "Follow Us",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _socialIcon(Icons.facebook),
                const SizedBox(width: 12),
                _socialIcon(Icons.linked_camera_sharp),
                const SizedBox(width: 12),
                _socialIcon(Icons.alternate_email),
                const SizedBox(width: 12),
                _socialIcon(Icons.web),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 26),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: AppColors.primary),
    );
  }

  // =====================================================
  // RIGHT SIDE — Contact Form Card
  // =====================================================
  Widget _contactForm(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Send Us a Message",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 22),

            // Name
            _formField("Full Name"),
            const SizedBox(height: 18),

            // Email
            _formField("Email"),
            const SizedBox(height: 18),

            // Message
            _formField("Your Message", maxLines: 5),
            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Message sent successfully"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade700),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
