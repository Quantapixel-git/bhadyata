import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_side_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HrKycUploadPage extends StatefulWidget {
  const HrKycUploadPage({super.key});

  @override
  State<HrKycUploadPage> createState() => _HrKycUploadPageState();
}

class _HrKycUploadPageState extends State<HrKycUploadPage> {
  PlatformFile? aadharFile;
  PlatformFile? panFile;
  bool isLoading = false;
  bool isFetching = true;

  String? existingAadharUrl;
  String? existingPanUrl;

  // NEW: kyc status from server (1 approved, 2 pending, 3 rejected)
  int? kycApproval;

  @override
  void initState() {
    super.initState();
    _fetchHrKycStatus();
  }

  // NEW: helpers for chip text/color
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

  Future<void> _fetchHrKycStatus() async {
    try {
      final userIdStr = await SessionManager.getValue('hr_id');
      final userId = userIdStr?.toString() ?? '0';
      final url = Uri.parse("${ApiConstants.baseUrl}getHrProfileByUserId");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            existingAadharUrl = data['data']['kyc_aadhaar'];
            existingPanUrl = data['data']['kyc_pan'];
            // NEW: capture status
            kycApproval = data['data']['kyc_approval'] as int?;
          });
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching HR KYC status: $e");
    } finally {
      setState(() {
        isFetching = false;
      });
    }
  }

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
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
      final userIdStr = await SessionManager.getValue('hr_id');
      final userId = userIdStr?.toString() ?? '0';
      final url = Uri.parse("${ApiConstants.baseUrl}hrUpload-kyc");

      var request = http.MultipartRequest('POST', url);
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

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("HR KYC uploaded successfully!"),
          ),
        );
        setState(() {
          aadharFile = null;
          panFile = null;
        });
        // refresh (this will also fetch kyc_approval)
        await _fetchHrKycStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Upload failed: ${response.statusCode}"),
          ),
        );
      }

      debugPrint("Response Body: $responseBody");
    } catch (e) {
      debugPrint("🟥 Error during HR KYC upload: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

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

    return HrDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          elevation: 1,
          title: const Text(
            "KYC Verification",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        body: isFetching
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NEW: Status banner (always visible)
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

                    // Submit button visible if any doc missing OR if rejected (allow re-upload)
                    if (!hasUploaded)
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
                    else
                      // When both docs exist and not rejected, just show a compact note under status banner
                      const SizedBox.shrink(),
                  ],
                ),
              ),
      ),
    );
  }

  // NEW: Status banner widget
  Widget _statusBanner(bool hasUploaded) {
    final color = kycColor(kycApproval);
    final label = kycLabel(kycApproval);
    final showHelp = (kycApproval == 3); // rejected -> show hint

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
              style: TextStyle(
                // color: color
                // .shade900, // works for MaterialColor like green/orange/red
                fontWeight: FontWeight.w600,
              ),
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
        boxShadow: [
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
