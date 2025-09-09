import 'package:flutter/material.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payments & Wallet"), backgroundColor: Colors.green.shade700),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Colors.green),
                title: const Text("Total Wallet Balance"),
                subtitle: const Text("\$15,230"),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.payment, color: Colors.orange),
                title: const Text("Pending Payments"),
                subtitle: const Text("\$2,500"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
