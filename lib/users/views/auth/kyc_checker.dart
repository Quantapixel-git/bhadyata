import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:jobshub/common/utils/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
// import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';

class KycCheckerPage extends StatefulWidget {
  const KycCheckerPage({super.key});

  @override
  State<KycCheckerPage> createState() => _KycCheckerPageState();
}

class _KycCheckerPageState extends State<KycCheckerPage> {
  PlatformFile? aadharFile;
  PlatformFile? panFile;

  bool isLoading = false; // while uploading
  bool isFetching = true; // while fetching current KYC/status

  // already uploaded file URLs from backend
  String? existingAadharUrl;
  String? existingPanUrl;

  // 1=approved, 2=pending, 3=rejected, null = not submitted
  int? kycApproval;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeKycStatus();
  }

  // ----- Status helpers (same mapping as employer screen) -----
  String kycLabel(int? v) {
    switch (v) {
      case 1:
        return 'Approved';
      case 2:
        return 'Pending';
      case 3:
        return 'Rejected';
      default:
        return 'Not submitted';
    }
  }

  Color kycColor(int? v) {
    switch (v) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ---- Fetch current KYC + status from employeeProfileByUserId ----
  Future<void> _fetchEmployeeKycStatus() async {
    setState(() => isFetching = true);
    try {
      final userIdStr = await SessionManager.getValue('user_id');
      final userId = userIdStr?.toString() ?? '0';

      final url = Uri.parse("${ApiConstants.baseUrl}employeeProfileByUserId");
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_id": userId}),
      );

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map && decoded['success'] == true) {
          final data = decoded['data'] as Map?;
          final profile = (data?['profile'] ?? {}) as Map;

          setState(() {
            existingAadharUrl = profile['kyc_aadhaar']?.toString();
            existingPanUrl = profile['kyc_pan']?.toString();
            // 1=Approved, 2=Pending, 3=Rejected
            kycApproval = profile['kyc_approval'] is int
                ? profile['kyc_approval'] as int
                : (profile['kyc_approval'] != null
                      ? int.tryParse(profile['kyc_approval'].toString())
                      : null);
          });
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching Employee KYC status: $e");
    } finally {
      if (mounted) setState(() => isFetching = false);
    }
  }

  // ---- Pick PDF (web uses bytes, mobile/desktop uses path) ----
  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // needed for web bytes
    );

    if (result != null &&
        (kIsWeb
            ? result.files.single.bytes != null
            : result.files.single.path != null)) {
      setState(() {
        if (type == 'aadhar') {
          aadharFile = result.files.single;
        } else {
          panFile = result.files.single;
        }
      });
    }
  }

  // ---- Upload both PDFs ----
  Future<void> _uploadKyc() async {
    if (aadharFile == null || panFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please select both Aadhaar and PAN files"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final userIdStr = await SessionManager.getValue('user_id');
      final userId = userIdStr?.toString() ?? '0';
      final url = Uri.parse("${ApiConstants.baseUrl}employeeUpload-kyc");

      final request = http.MultipartRequest('POST', url);
      request.fields['user_id'] = userId;

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'kyc_aadhaar',
            aadharFile!.bytes!,
            filename: aadharFile!.name,
          ),
        );
        request.files.add(
          http.MultipartFile.fromBytes(
            'kyc_pan',
            panFile!.bytes!,
            filename: panFile!.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('kyc_aadhaar', aadharFile!.path!),
        );
        request.files.add(
          await http.MultipartFile.fromPath('kyc_pan', panFile!.path!),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      debugPrint("Employee KYC upload response: $responseBody");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("✅ KYC uploaded successfully!"),
          ),
        );
        setState(() {
          aadharFile = null;
          panFile = null;
        });
        await _fetchEmployeeKycStatus(); // refresh links and status
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Upload failed: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      debugPrint("🟥 Error during Employee KYC upload: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Error: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ---- Open PDF in external app/browser ----
  Future<void> _openPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Cannot open PDF link"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUploaded =
        (existingAadharUrl != null && existingAadharUrl!.isNotEmpty) &&
        (existingPanUrl != null && existingPanUrl!.isNotEmpty);

    // Match the employer page: black app bar + status banner
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),

        // automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 1,
        title: const Text(
          "KYC Verification",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: isFetching
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statusBanner(hasUploaded),
                  const SizedBox(height: 16),

                  _sectionTitle("Upload or View Your KYC Documents"),
                  const SizedBox(height: 12),

                  _uploadCard(
                    title: "Aadhaar Card (PDF)",
                    subtitle: "Upload front and back in a single PDF file",
                    icon: Icons.picture_as_pdf,
                    fileName: aadharFile?.name,
                    existingUrl: existingAadharUrl,
                    onTap: () => _pickFile('aadhar'),
                    onPreview: existingAadharUrl != null
                        ? () => _openPdf(existingAadharUrl!)
                        : null,
                  ),
                  const SizedBox(height: 16),

                  _uploadCard(
                    title: "PAN Card (PDF)",
                    subtitle: "Upload a clear scanned copy",
                    icon: Icons.picture_as_pdf,
                    fileName: panFile?.name,
                    existingUrl: existingPanUrl,
                    onTap: () => _pickFile('pan'),
                    onPreview: existingPanUrl != null
                        ? () => _openPdf(existingPanUrl!)
                        : null,
                  ),
                  const SizedBox(height: 30),

                  // Only show Submit when something missing OR Rejected
                  // Buttons section
                  if (!hasUploaded || kycApproval == 3)
                    // ❌ Missing docs OR Rejected → show Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _uploadKyc,
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.upload,
                                color: Colors.white,
                                size: 22,
                              ),
                        label: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            isLoading ? "Uploading..." : "Submit KYC",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    )
                  else if (kycApproval == 1)
                    // ✅ Approved → show message + Go to Dashboard button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            "✅ KYC approved.",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.userDashboard,
                              );
                            },
                            icon: const Icon(
                              Icons.dashboard,
                              color: Colors.white,
                            ),
                            label: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                "Go to Dashboard",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    // 🕒 Uploaded but Pending → only info
                    const Center(
                      child: Text(
                        "KYC documents uploaded. Waiting for approval.",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  // ----- UI bits (same style as employer) -----
  Widget _statusBanner(bool hasUploaded) {
    final color = kycColor(kycApproval);
    final label = kycLabel(kycApproval);
    final showHelp = (kycApproval == 3); // show hint when rejected

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(
            kycApproval == 1
                ? Icons.verified_user
                : kycApproval == 2
                ? Icons.hourglass_bottom
                : kycApproval == 3
                ? Icons.error_outline
                : Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hasUploaded
                  ? "KYC Status: $label"
                  : "KYC Status: ${kycLabel(null)}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (showHelp) const SizedBox(width: 8),
          if (showHelp)
            const Text(
              "Please re-upload clear PDFs",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 4),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );

  Widget _uploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    String? fileName,
    String? existingUrl,
    VoidCallback? onPreview,
  }) {
    final hasExistingFile = existingUrl != null && existingUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.redAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // If file already uploaded -> show "View" button, else show chooser
          if (hasExistingFile)
            ElevatedButton.icon(
              onPressed: onPreview,
              icon: const Icon(Icons.visibility, color: Colors.white),
              label: const Text(
                "View Uploaded Document",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        fileName != null
                            ? Icons.check_circle
                            : Icons.upload_file,
                        color: fileName != null
                            ? Colors.green
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          fileName ?? "Choose PDF File",
                          style: TextStyle(
                            color: fileName != null
                                ? Colors.black87
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
