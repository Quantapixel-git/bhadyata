import 'package:flutter/material.dart';

class UserWorksPage extends StatefulWidget {
  const UserWorksPage({super.key});

  @override
  State<UserWorksPage> createState() => _UserWorksPageState();
}

class _UserWorksPageState extends State<UserWorksPage> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _works = [
    {
      "title": "Marketing Campaign",
      "category": "Marketing",
      "desc": "Promote our new app on social media platforms.",
      "budget": "₹5000",
      "status": "Open",
      "applied": false,
    },
    {
      "title": "Onboarding Support",
      "category": "Onboarding",
      "desc": "Help onboard 20+ new clients this month.",
      "budget": "₹3000",
      "status": "Open",
      "applied": false,
    },
    {
      "title": "Sales Call Assistance",
      "category": "Sales",
      "desc": "Assist in reaching out to 50+ leads.",
      "budget": "₹4000",
      "status": "Open",
      "applied": false,
    },
  ];

  void _applyForWork(int index) {
    setState(() {
      _works[index]["applied"] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ You applied for ${_works[index]["title"]}"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedWorks =
        _currentIndex == 0 ? _works : _works.where((w) => w["applied"]).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? "Available Works" : "My Works"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: displayedWorks.isEmpty
          ? Center(
              child: Text(
                _currentIndex == 0
                    ? "No available works at the moment."
                    : "You haven't applied for any works yet.",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: displayedWorks.length,
              itemBuilder: (context, index) {
                final work = displayedWorks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(Icons.work, color: Colors.blue),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                work["title"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(work["category"]),
                              backgroundColor: Colors.blue.shade50,
                              labelStyle:
                                  const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          work["desc"],
                          style:
                              const TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "💰 ${work["budget"]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Chip(
                              label: Text(
                                  work["applied"] ? "Applied" : work["status"]),
                              backgroundColor: work["applied"]
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              labelStyle: TextStyle(
                                color:
                                    work["applied"] ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_currentIndex == true)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: work["applied"]
                                  ? null
                                  : () => _applyForWork(
                                      _works.indexOf(work)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: work["applied"]
                                    ? Colors.grey
                                    : Colors.blue.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                  work["applied"] ? "Already Applied" : "Apply Now"),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "Available Works",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "My Works",
          ),
        ],
      ),
    );
  }
}
