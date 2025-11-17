import 'dart:convert';
import 'dart:io' show File; // only used on non-web
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/app_color.dart';
import 'package:jobshub/common/utils/session_manager.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';

class EmployeeLeaveRequestScreen extends StatefulWidget {
  const EmployeeLeaveRequestScreen({super.key});

  @override
  State<EmployeeLeaveRequestScreen> createState() =>
      _EmployeeLeaveRequestScreenState();
}

class _EmployeeLeaveRequestScreenState
    extends State<EmployeeLeaveRequestScreen> {
  // API DATA
  List<Map<String, dynamic>> jobs = [];
  bool loading = true;
  String? errorMessage;

  // FORM DATA
  DateTime? startDate;
  DateTime? endDate;
  PlatformFile? pickedFile;
  final TextEditingController reasonController = TextEditingController();

  int? selectedJobId;
  int? employerId;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeJobs();
  }

  // ---------------- API: Fetch Jobs ----------------
  Future<void> _fetchEmployeeJobs() async {
    setState(() {
      loading = true;
      errorMessage = null;
      jobs = [];
      selectedJobId = null;
      employerId = null;
    });

    try {
      final userId = await SessionManager.getValue('user_id');
      debugPrint('[DEBUG] _fetchEmployeeJobs: userId = $userId');
      if (userId == null || userId.toString().isEmpty) {
        setState(() {
          errorMessage = "User not logged in.";
          loading = false;
        });
        debugPrint('[DEBUG] _fetchEmployeeJobs: user not logged in');
        return;
      }

      final url = Uri.parse("${ApiConstants.baseUrl}salaryJobsByEmployee");
      debugPrint(
        '[DEBUG] _fetchEmployeeJobs: POST $url body={"employee_id": ${int.parse(userId)}}',
      );

      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"employee_id": int.parse(userId)}),
      );

      debugPrint(
        '[DEBUG] _fetchEmployeeJobs: response status=${resp.statusCode}',
      );
      debugPrint('[DEBUG] _fetchEmployeeJobs: response body=${resp.body}');

      if (resp.statusCode != 200) {
        setState(() {
          errorMessage = "Server returned ${resp.statusCode}";
          loading = false;
        });
        debugPrint('[DEBUG] _fetchEmployeeJobs: non-200 status, returning');
        return;
      }

      final body = jsonDecode(resp.body);
      debugPrint(
        '[DEBUG] _fetchEmployeeJobs: decoded body type=${body.runtimeType}',
      );

      if (body is Map && body["success"] == true) {
        final List data = body["data"] ?? [];
        // ensure typed maps
        jobs = data.map<Map<String, dynamic>>((e) {
          if (e is Map) return Map<String, dynamic>.from(e);
          return <String, dynamic>{};
        }).toList();

        debugPrint('[DEBUG] _fetchEmployeeJobs: jobs length=${jobs.length}');
        if (jobs.isNotEmpty) {
          // default selection = first job
          selectedJobId = jobs.first["job_id"] is int
              ? jobs.first["job_id"] as int
              : int.tryParse('${jobs.first["job_id"]}');
          employerId = jobs.first["employer_id"] is int
              ? jobs.first["employer_id"] as int
              : int.tryParse('${jobs.first["employer_id"]}');
          debugPrint(
            '[DEBUG] _fetchEmployeeJobs: default selectedJobId=$selectedJobId, employerId=$employerId',
          );
        }
      } else {
        errorMessage = body["message"]?.toString() ?? "Failed to fetch jobs";
        debugPrint(
          '[DEBUG] _fetchEmployeeJobs: API returned success != true, message=${body["message"]}',
        );
      }
    } catch (e, st) {
      errorMessage = "Exception: $e";
      debugPrint('[ERROR] _fetchEmployeeJobs exception: $e\n$st');
    } finally {
      setState(() => loading = false);
    }
  }

  // ---------------- API: Apply Leave ----------------
  Future<void> _applyLeave() async {
    debugPrint(
      '[DEBUG] _applyLeave: startDate=$startDate endDate=$endDate selectedJobId=$selectedJobId employerId=$employerId pickedFile=${pickedFile?.path} pickedFile.bytes.length=${pickedFile?.bytes?.length ?? 'no-bytes'} kIsWeb=$kIsWeb',
    );

    if (startDate == null ||
        endDate == null ||
        reasonController.text.trim().isEmpty ||
        selectedJobId == null ||
        employerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please fill all fields"),
        ),
      );
      debugPrint('[DEBUG] _applyLeave: validation failed');
      return;
    }

    try {
      final userId = await SessionManager.getValue('user_id');
      debugPrint('[DEBUG] _applyLeave: userId=$userId');
      if (userId == null || userId.toString().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("User not logged in"),
          ),
        );
        debugPrint('[DEBUG] _applyLeave: user not logged in');
        return;
      }

      final url = Uri.parse("${ApiConstants.baseUrl}applyForLeave");
      debugPrint('[DEBUG] _applyLeave: POST Multipart $url');

      var request = http.MultipartRequest('POST', url);
      request.fields['employee_id'] = userId.toString();
      request.fields['job_id'] = selectedJobId.toString();
      request.fields['employer_id'] = employerId.toString();
      request.fields['start_date'] =
          "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
      request.fields['end_date'] =
          "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";
      request.fields['reason'] = reasonController.text.trim();

      debugPrint('[DEBUG] _applyLeave: fields=${request.fields}');

      // === Attach file: handle web and non-web separately ===
      if (pickedFile != null) {
        // On web: pickedFile.path may be null or a blob: URI. Use bytes.
        if (kIsWeb) {
          debugPrint('[DEBUG] _applyLeave: running on Web - using bytes');
          if (pickedFile!.bytes == null) {
            debugPrint('[ERROR] _applyLeave: pickedFile.bytes is null on web');
          } else {
            final bytes = pickedFile!.bytes!;
            final multipartFile = http.MultipartFile.fromBytes(
              'attachment',
              bytes,
              filename: pickedFile!.name,
            );
            request.files.add(multipartFile);
            debugPrint(
              '[DEBUG] _applyLeave: added MultipartFile.fromBytes name=${pickedFile!.name} size=${bytes.length}',
            );
          }
        } else {
          // native (android/ios) - use file path
          if (pickedFile!.path == null) {
            debugPrint(
              '[ERROR] _applyLeave: pickedFile.path is null on native',
            );
          } else {
            final file = File(pickedFile!.path!);
            final length = await file.length();
            debugPrint(
              '[DEBUG] _applyLeave: attaching file ${pickedFile!.path} size=$length',
            );
            final stream = http.ByteStream(file.openRead());
            final multipartFile = http.MultipartFile(
              'attachment',
              stream,
              length,
              filename: pickedFile!.name,
            );
            request.files.add(multipartFile);
            debugPrint(
              '[DEBUG] _applyLeave: added MultipartFile.fromPath name=${pickedFile!.name}',
            );
          }
        }
      } else {
        debugPrint('[DEBUG] _applyLeave: no attachment');
      }

      final streamedResponse = await request.send();
      debugPrint(
        '[DEBUG] _applyLeave: streamedResponse status=${streamedResponse.statusCode}',
      );
      final respStr = await streamedResponse.stream.bytesToString();
      debugPrint('[DEBUG] _applyLeave: response body=$respStr');

      if (streamedResponse.statusCode != 200 &&
          streamedResponse.statusCode != 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Server error: ${streamedResponse.statusCode}"),
          ),
        );
        debugPrint('[DEBUG] _applyLeave: non-200/201 status');
        return;
      }

      final jsonBody = jsonDecode(respStr);
      debugPrint('[DEBUG] _applyLeave: decoded jsonBody=$jsonBody');

      if (jsonBody is Map && jsonBody["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Leave applied successfully"),
          ),
        );

        // reset form
        reasonController.clear();
        pickedFile = null;
        startDate = null;
        endDate = null;

        debugPrint('[DEBUG] _applyLeave: reset form after success');
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Failed: ${jsonBody['message'] ?? 'Unknown'}"),
          ),
        );
        debugPrint(
          '[DEBUG] _applyLeave: API returned success != true, message=${jsonBody['message']}',
        );
      }
    } catch (e, st) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Exception: $e"),
        ),
      );
      debugPrint('[ERROR] _applyLeave exception: $e\n$st');
    }
  }

  // ------------ UI PART --------------
  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[DEBUG] build: loading=$loading jobs.length=${jobs.length} selectedJobId=$selectedJobId',
    );
    return AppDrawerWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          title: const Text(
            "My Leave Requests",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : jobs.isEmpty
            ? _buildLockedState()
            : _buildContent(),
      ),
    );
  }

  // ---------------- IF JOBS AVAILABLE ----------------
  Widget _buildContent() {
    // ensure employerId stays in sync with selectedJobId
    if (selectedJobId != null) {
      final match = jobs.firstWhere(
        (j) =>
            (j['job_id'] is int
                ? j['job_id']
                : int.tryParse('${j['job_id']}')) ==
            selectedJobId,
        orElse: () => {},
      );
      if (match.isNotEmpty) {
        employerId = match['employer_id'] is int
            ? match['employer_id'] as int
            : int.tryParse('${match['employer_id']}');
        debugPrint(
          '[DEBUG] _buildContent: matched employerId=$employerId for selectedJobId=$selectedJobId',
        );
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobCard(),
          const SizedBox(height: 20),
          _buildLeaveForm(),
        ],
      ),
    );
  }

  // ---------------- JOB CARD ----------------
  Widget _buildJobCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Jobs",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: selectedJobId,
            decoration: const InputDecoration(labelText: "Select Job"),
            items: jobs.map<DropdownMenuItem<int>>((j) {
              final id = (j['job_id'] is int)
                  ? j['job_id'] as int
                  : int.tryParse('${j['job_id']}') ?? 0;
              final title = (j['title'] ?? j['title']?.toString() ?? 'Untitled')
                  .toString();
              return DropdownMenuItem<int>(value: id, child: Text(title));
            }).toList(),
            onChanged: (v) {
              debugPrint('[DEBUG] Dropdown onChanged: new selectedJobId=$v');
              setState(() {
                selectedJobId = v;
                // update employerId to match selected job
                final match = jobs.firstWhere(
                  (j) =>
                      (j['job_id'] is int
                          ? j['job_id']
                          : int.tryParse('${j['job_id']}')) ==
                      v,
                  orElse: () => {},
                );
                if (match.isNotEmpty) {
                  employerId = match['employer_id'] is int
                      ? match['employer_id'] as int
                      : int.tryParse('${match['employer_id']}');
                } else {
                  employerId = null;
                }
                debugPrint(
                  '[DEBUG] Dropdown onChanged: employerId updated to $employerId',
                );
              });
            },
          ),
          const SizedBox(height: 12),
          // quick job summary
          if (selectedJobId != null) _selectedJobSummary(),
        ],
      ),
    );
  }

  Widget _selectedJobSummary() {
    final match = jobs.firstWhere(
      (j) =>
          (j['job_id'] is int ? j['job_id'] : int.tryParse('${j['job_id']}')) ==
          selectedJobId,
      orElse: () => {},
    );
    if (match.isEmpty) return const SizedBox.shrink();

    Widget infoRow(IconData icon, String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
        ],
      ),
    );
  }

  // ---------------- LEAVE FORM ----------------
  Widget _buildLeaveForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Apply for Leave",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          // START DATE
          _datePickerTile("Start Date", startDate, (date) {
            debugPrint('[DEBUG] Start date picked: $date');
            setState(() => startDate = date);
          }),

          // END DATE
          _datePickerTile("End Date", endDate, (date) {
            debugPrint('[DEBUG] End date picked: $date');
            setState(() => endDate = date);
          }),

          const SizedBox(height: 12),

          TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Reason",
            ),
          ),

          const SizedBox(height: 12),

          // FILE PICKER
          ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.attach_file),
            label: Text(
              pickedFile == null
                  ? "Attach File (optional)"
                  : pickedFile!.name ?? "",
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed: _applyLeave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                "Submit Leave",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      // Important: request bytes for web so we can upload via MultipartFile.fromBytes
      final result = await FilePicker.platform.pickFiles(withData: true);
      debugPrint('[DEBUG] _pickFile: result=${result?.files.length ?? 0}');
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          pickedFile = result.files.first;
        });
        debugPrint(
          '[DEBUG] _pickFile: pickedFile=${pickedFile!.name} path=${pickedFile!.path} bytes=${pickedFile!.bytes?.length ?? 'null'}',
        );
      }
    } catch (e, st) {
      // ignore file picker errors silently but print
      debugPrint('[ERROR] _pickFile exception: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("File pick error: $e"),
        ),
      );
    }
  }

  // -------------- LOCKED SCREEN ----------------
  Widget _buildLockedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 80, color: Colors.grey.shade600),
          const SizedBox(height: 10),
          const Text(
            "Leave requests are only available\nfor salary-based employees.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ---------------- UTIL WIDGET ----------------
  Widget _datePickerTile(
    String label,
    DateTime? date,
    Function(DateTime) onSelect,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        date == null
            ? "$label: Not selected"
            : "$label: ${date.day}-${date.month}-${date.year}",
      ),
      trailing: ElevatedButton(
        onPressed: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (picked != null) onSelect(picked);
        },
        child: const Text("Pick"),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }
}
