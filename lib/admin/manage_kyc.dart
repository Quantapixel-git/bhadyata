import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class ManageKyc extends StatefulWidget {
  const ManageKyc({super.key});

  @override
  State<ManageKyc> createState() => _ManageKycState();
}

class _ManageKycState extends State<ManageKyc> {
  final List<Map<String, dynamic>> users = [
    {
      "name": "Ravi Sharma",
      "email": "ravi@example.com",
      "status": "pending",
      "dob": "12/08/1995",
      "gender": "Male",
      "mobile": "9876543210",
      "address": "Delhi, India",
      "guardian": "Suresh Sharma",
      "jobTitle": "Software Engineer",
      "experience": "5",
      "skills": "Flutter, Dart, Firebase",
      "identityProof": "aadhar_ravi.pdf",
      "addressProof": "electricity_bill.pdf",
      "educationProof": "btech_certificate.pdf",
      "selfie": "ravi_selfie.png",
    },
    {
      "name": "Priya Singh",
      "email": "priya@example.com",
      "status": "approved",
      "dob": "05/03/1998",
      "gender": "Female",
      "mobile": "9123456780",
      "address": "Mumbai, India",
      "guardian": "R.K. Singh",
      "jobTitle": "UI/UX Designer",
      "experience": "3",
      "skills": "Figma, Photoshop, Flutter UI",
      "identityProof": "passport_priya.pdf",
      "addressProof": "rent_agreement.pdf",
      "educationProof": "design_diploma.pdf",
      "selfie": "priya_selfie.png",
    },
    {
      "name": "Neha Gupta",
      "email": "neha@example.com",
      "status": "rejected",
      "dob": "15/09/1997",
      "gender": "Female",
      "mobile": "9001234567",
      "address": "Pune, India",
      "guardian": "Sunita Gupta",
      "jobTitle": "Content Writer",
      "experience": "2",
      "skills": "Writing, SEO, Blogging",
      "identityProof": "aadhar_neha.pdf",
      "addressProof": "phone_bill.pdf",
      "educationProof": "ba_english.pdf",
      "selfie": "neha_selfie.png",
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
       appBar: AppBar(
        title: const Text(
          "Manage KYC",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
          elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (_, index) {
          final user = users[index];
          final status = user["status"];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KycDetailScreen(user: user),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      child: const Icon(Icons.person,
                          size: 32, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user["name"],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(user["email"],
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey)),
                          const SizedBox(height: 6),
                          Text(
                            "Status: ${status[0].toUpperCase()}${status.substring(1)}",
                            style: TextStyle(
                              color: getStatusColor(status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class KycDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const KycDetailScreen({super.key, required this.user});

  Color getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text("$label:",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = user["status"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("KYC Details"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.person,
                          size: 40, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user["name"],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(user["email"],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
                const Divider(height: 30),

                // Personal Info
                _sectionTitle("Personal Information", Icons.person),
                _infoTile("DOB", user["dob"]),
                _infoTile("Gender", user["gender"]),
                _infoTile("Mobile", user["mobile"]),
                _infoTile("Address", user["address"]),
                _infoTile("Guardian", user["guardian"]),

                const Divider(height: 30),

                // Work Info
                _sectionTitle("Work Information", Icons.work),
                _infoTile("Job Title", user["jobTitle"]),
                _infoTile("Experience", "${user["experience"]} years"),
                _infoTile("Skills", user["skills"]),

                const Divider(height: 30),

                // Documents
                _sectionTitle("Uploaded Documents", Icons.file_copy),
                _infoTile("Identity Proof", user["identityProof"]),
                _infoTile("Address Proof", user["addressProof"]),
                _infoTile("Education Proof", user["educationProof"]),
                _infoTile("Selfie", user["selfie"]),

                const Divider(height: 30),

                // Status
                _sectionTitle("KYC Status", Icons.verified_user),
                Text(
                  status[0].toUpperCase() + status.substring(1),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(status),
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