import 'package:flutter/material.dart';

class UserWalletScreen extends StatelessWidget {
  final double balance = 250.0;
  final List<Map<String, dynamic>> transactions = [
    {"type": "credit", "amount": 250, "desc": "Job #7 payment", "status": "Success"},
    {"type": "withdraw", "amount": 100, "desc": "Bank Transfer", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Wallet")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.green.shade100,
              child: ListTile(
                title: Text("Balance", style: TextStyle(fontSize: 18)),
                trailing: Text("\$$balance", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // Navigate to withdraw form
              child: Text("Withdraw"),
            ),
            SizedBox(height: 20),
            Text("Transactions", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (_, index) {
                  final tx = transactions[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        tx["type"] == "credit" ? Icons.arrow_downward : Icons.arrow_upward,
                        color: tx["type"] == "credit" ? Colors.green : Colors.red,
                      ),
                      title: Text(tx["desc"]),
                      subtitle: Text(tx["status"]),
                      trailing: Text("\$${tx["amount"]}"),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
