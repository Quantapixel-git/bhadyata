
import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class UserContactUsPage extends StatelessWidget {
  const UserContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _messageController = TextEditingController();

    return Scaffold(
       appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Contact Us",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Your Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send),
              label: const Text("Send Message"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
