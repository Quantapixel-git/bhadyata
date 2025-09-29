import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jobshub/utils/AppColor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isExpanded = false;
  String referralCode = "MAH82&";
final TextEditingController resumeController = TextEditingController();


  // Resume display / editing
  String resumeFile = "resume_john.pdf";

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebUI(context);
    } else {
      return _buildMobileUI(context);
    }
  }

  Widget _buildMobileUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Rewards ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReferralSection(),
            const SizedBox(height: 24),
            _buildHowItWorks(),
            const SizedBox(height: 16),
            // _buildResumeSection(),
            const SizedBox(height: 16),
            _buildTermsTile(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWebUI(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          "Rewards & Resume",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(24),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReferralSection(),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildHowItWorks()),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            // _buildResumeSection(),
                            const SizedBox(height: 16),
                            _buildTermsTile(context, isWeb: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= REFERRAL CODE =================
  Widget _buildReferralSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Invite Friends & Earn",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            "Invite your friends and get 250 coins after they complete their first service. They get 100 coins as a gift from us.",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    referralCode,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= HOW IT WORKS =================
  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("How it works?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildStep(1, "Invite your friends"),
          const SizedBox(height: 12),
          _buildStep(
              2,
              "They get 100 coins towards their first service after clicking the invitation link"),
          const SizedBox(height: 12),
          _buildStep(3, "You get 250 coins after they complete the service"),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primary,
          child: Text(
            number.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

// PlatformFile? pickedFile;
// bool isEditingResume = false;

// Widget _buildResumeSection() {
//   return Card(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     elevation: 2,
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Resume",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),

//           /// File display / pick button
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   pickedFile != null ? pickedFile!.name : "No file uploaded",
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   FilePickerResult? result = await FilePicker.platform.pickFiles(
//                     type: FileType.custom,
//                     allowedExtensions: ['pdf', 'doc', 'docx'],
//                   );
//                   if (result != null) {
//                     setState(() {
//                       pickedFile = result.files.first;
//                     });
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12))),
//                 child: const Text("Upload File"),
//               )
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

  /// ================= TERMS & CONDITIONS =================
  Widget _buildTermsTile(BuildContext context, {bool isWeb = false}) {
    return InkWell(
      onTap: () {
        if (isWeb) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        } else {
          _showTermsAndConditions(context);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Terms & Conditions",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Terms & Conditions",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text(
                  """1. The referral reward will be given only after the invited friend completes their first service.  
2. The referral code must be applied at the time of booking.  
3. Each user can only use one referral code during signup.  
4. Bhadyata reserves the right to change or cancel the referral program anytime.  
5. Coins earned cannot be exchanged for cash and can only be redeemed on the Bhadyata app.""",
                  style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
