import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:jobshub/common/constants/constants.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/employer/views/drawer_dashboard/employer_side_bar.dart';

class EmployerKycUploadPage extends StatefulWidget {
  const EmployerKycUploadPage({super.key});

  @override
  State<EmployerKycUploadPage> createState() => _EmployerKycUploadPageState();
}

class _EmployerKycUploadPageState extends State<EmployerKycUploadPage> {
  PlatformFile? aadharFile;
  PlatformFile? panFile;
  bool isLoading = false;

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb, // Needed for web to get bytes
    );

    if (result != null && result.files.single.path != null) {
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
      final userIdStr = await SessionManager.getValue('employer_id');
      final userId = userIdStr?.toString() ?? '0';
      final url = Uri.parse("${ApiConstants.baseUrl}employerUpload-kyc");

      var request = http.MultipartRequest('POST', url);
      request.fields['user_id'] = userId;

      if (kIsWeb) {
        // 🕸️ Web-safe upload using bytes
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
        // 📱 Mobile/Desktop upload using file path
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
            content: Text("KYC uploaded successfully!"),
          ),
        );
        setState(() {
          aadharFile = null;
          panFile = null;
        });
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
      debugPrint("🟥 Error during KYC upload: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(" Error: $e"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EmployerDashboardWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            "KYC Verification",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Upload Your KYC Documents"),
              const SizedBox(height: 12),
              _uploadCard(
                title: "Aadhaar Card (PDF)",
                subtitle: "Upload front and back in a single PDF file",
                icon: Icons.picture_as_pdf,
                fileName: aadharFile?.name,
                onTap: () => _pickFile('aadhar'),
              ),
              const SizedBox(height: 16),
              _uploadCard(
                title: "PAN Card (PDF)",
                subtitle: "Upload a clear scanned copy",
                icon: Icons.picture_as_pdf,
                fileName: panFile?.name,
                onTap: () => _pickFile('pan'),
              ),
              const SizedBox(height: 30),
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
                      : const Icon(Icons.upload, color: Colors.white),
                  label: Text(
                    isLoading ? "Uploading..." : "Submit KYC",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
          ),
        ),
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
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
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
                      fileName != null ? Icons.check_circle : Icons.upload_file,
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
