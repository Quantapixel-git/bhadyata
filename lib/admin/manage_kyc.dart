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
class KycDetailScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const KycDetailScreen({super.key, required this.user});

  @override
  State<KycDetailScreen> createState() => _KycDetailScreenState();
}

class _KycDetailScreenState extends State<KycDetailScreen> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.user["status"];
  }

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
                        Text(widget.user["name"],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(widget.user["email"],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
                const Divider(height: 30),

                // Personal Info
                _sectionTitle("Personal Information", Icons.person),
                _infoTile("DOB", widget.user["dob"]),
                _infoTile("Gender", widget.user["gender"]),
                _infoTile("Mobile", widget.user["mobile"]),
                _infoTile("Address", widget.user["address"]),
                _infoTile("Guardian", widget.user["guardian"]),

                const Divider(height: 30),

                // Work Info
                _sectionTitle("Work Information", Icons.work),
                _infoTile("Job Title", widget.user["jobTitle"]),
                _infoTile("Experience", "${widget.user["experience"]} years"),
                _infoTile("Skills", widget.user["skills"]),

                const Divider(height: 30),

                // Documents
                _sectionTitle("Uploaded Documents", Icons.file_copy),
                _infoTile("Identity Proof", widget.user["identityProof"]),
                _infoTile("Address Proof", widget.user["addressProof"]),
                _infoTile("Education Proof", widget.user["educationProof"]),
                _infoTile("Selfie", widget.user["selfie"]),

                const Divider(height: 30),

                // Status with Dropdown
                _sectionTitle("KYC Status", Icons.verified_user),
                Row(
                  children: [
                    const Text("Status: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _status,
                      items: const [
                        DropdownMenuItem(
                            value: "pending", child: Text("Pending")),
                        DropdownMenuItem(
                            value: "approved", child: Text("Approved")),
                        DropdownMenuItem(
                            value: "rejected", child: Text("Rejected")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                          widget.user["status"] = _status;
                        });

                        // TODO: send updated status to admin backend/API
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Status updated to $_status")),
                        );
                      },
                      dropdownColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
