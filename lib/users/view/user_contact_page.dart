import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/users/view/user_sidedrawer.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/users/view/home_page.dart'; // for AppDrawer

class UserContactUsPage extends StatefulWidget {
  const UserContactUsPage({super.key});

  @override
  State<UserContactUsPage> createState() => _UserContactUsPageState();
}

class _UserContactUsPageState extends State<UserContactUsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isHovered = false; // hover effect for the send button

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildContactForm(double spacing) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: spacing),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Your Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: spacing),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: spacing * 2),
            MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Message sent!")),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Send Message"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isHovered
                        ? AppColors.primary.withOpacity(0.85)
                        : AppColors.primary,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = kIsWeb && constraints.maxWidth > 800;

        if (isWeb) {
          // 💻 Web layout with sidebar
          double spacing = 16;
          return Scaffold(
            body: Row(
              children: [
                const AppDrawer(), // Sidebar
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(40),
                    child: Center(child: _buildContactForm(spacing)),
                  ),
                ),
              ],
            ),
          );
        } else {
          // 📱 Mobile layout with AppBar
          double spacing = constraints.maxWidth <= 600 ? 12 : 16;
          double horizontalPadding =
              constraints.maxWidth <= 600 ? 16 : constraints.maxWidth * 0.2;

          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text(
                "Contact Us",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // backgroundColor: AppColors.primary,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Center(child: _buildContactForm(spacing)),
            ),
          );
        }
      },
    );
  }
}
