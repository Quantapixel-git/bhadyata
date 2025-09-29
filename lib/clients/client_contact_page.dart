
import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class ClientContactUsPage extends StatelessWidget {
  const ClientContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _companyController = TextEditingController();
    final _emailController = TextEditingController();
    final _queryController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Contact Us",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: "Company Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _queryController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Your Query",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send),
              label: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}

