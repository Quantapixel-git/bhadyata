import 'package:flutter/material.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/user_sidedrawer.dart';
import 'package:jobshub/common/utils/app_color.dart';

// ------------------ Models ------------------
class WorkAssignment {
  final String title;
  final String company;
  final String employmentType;
  final double salary;

  WorkAssignment({
    required this.title,
    required this.company,
    required this.employmentType,
    required this.salary,
  });
}

class LeaveRequest {
  final String employeeName;
  final String leaveType;
  final String reason;
  final DateTime date;
  String status;
  String? hrReview;

  LeaveRequest({
    required this.employeeName,
    required this.leaveType,
    required this.reason,
    required this.date,
    this.status = "Pending",
    this.hrReview,
  });
}

// ------------------ Shared Service ------------------
class LeaveRequestService extends ChangeNotifier {
  static final LeaveRequestService _instance = LeaveRequestService._internal();
  factory LeaveRequestService() => _instance;
  LeaveRequestService._internal();

  final List<LeaveRequest> _requests = [];

  List<LeaveRequest> get allRequests => _requests;

  void addRequest(LeaveRequest request) {
    _requests.add(request);
    notifyListeners();
  }

  List<LeaveRequest> getRequestsForEmployee(String employeeName) {
    return _requests.where((r) => r.employeeName == employeeName).toList();
  }

  void updateRequestStatus(
    LeaveRequest request,
    String status,
    String? hrReview,
  ) {
    request.status = status;
    request.hrReview = hrReview;
    notifyListeners();
  }
}

// ------------------ Employee Leave Screen ------------------
class EmployeeLeaveRequestScreen extends StatefulWidget {
  final String employeeName;
  final WorkAssignment work;

  const EmployeeLeaveRequestScreen({
    super.key,
    required this.employeeName,
    required this.work,
  });

  @override
  _EmployeeLeaveRequestScreenState createState() =>
      _EmployeeLeaveRequestScreenState();
}

class _EmployeeLeaveRequestScreenState
    extends State<EmployeeLeaveRequestScreen> {
  DateTime? selectedDate;
  String? selectedLeaveType;
  final TextEditingController reasonController = TextEditingController();

  final List<String> leaveTypes = ["Sick", "Casual", "Personal", "Other"];
  final service = LeaveRequestService();

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _submitRequest() {
    if (selectedDate == null ||
        selectedLeaveType == null ||
        reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    service.addRequest(
      LeaveRequest(
        employeeName: widget.employeeName,
        leaveType: selectedLeaveType!,
        reason: reasonController.text,
        date: selectedDate!,
      ),
    );

    setState(() {
      selectedDate = null;
      selectedLeaveType = null;
      reasonController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Leave request submitted!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myRequests = service.getRequestsForEmployee(widget.employeeName);
    final work = widget.work;

    return AppDrawerWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 800;

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 1,
              title: const Text(
                "My Leave Requests",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb
                    ? MediaQuery.of(context).size.width * 0.2
                    : 16,
                vertical: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // JOB DETAILS
                    Container(
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
                          const Text(
                            "Job Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _infoRow(Icons.work_outline, work.title),
                          _infoRow(Icons.business_outlined, work.company),
                          _infoRow(
                            Icons.payment_outlined,
                            "₹${work.salary.toStringAsFixed(2)} / month",
                          ),
                          _infoRow(
                            Icons.badge_outlined,
                            "Type: ${work.employmentType}",
                            color: work.employmentType == "Salary Based Job"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (work.employmentType == "Salary Based Job")
                      _buildLeaveForm(myRequests)
                    else
                      _buildLockedState(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------ Widgets ------------------
  Widget _infoRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 15, color: color ?? Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveForm(List<LeaveRequest> myRequests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Apply for Leave",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                selectedDate == null
                    ? "No date selected"
                    : "Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
              ),
            ),
            ElevatedButton(
              onPressed: _pickDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text("Pick Date"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: selectedLeaveType,
          items: ["Sick", "Casual", "Personal", "Other"]
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          hint: const Text("Select Leave Type"),
          onChanged: (val) => setState(() => selectedLeaveType = val),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Reason",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton(
            onPressed: _submitRequest,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Submit Request"),
          ),
        ),
        const Divider(height: 30),
        const Text(
          "My Leave Requests",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        myRequests.isEmpty
            ? const Center(
                child: Text(
                  "No leave requests yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : Column(
                children: myRequests.map((req) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text("${req.leaveType} Leave"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date: ${req.date.day}-${req.date.month}-${req.date.year}",
                          ),
                          Text("Reason: ${req.reason}"),
                          if (req.hrReview != null)
                            Text("HR Review: ${req.hrReview}"),
                          const SizedBox(height: 4),
                          Text(
                            "Status: ${req.status}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: req.status == "Approved"
                                  ? Colors.green
                                  : req.status == "Rejected"
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildLockedState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.lock_outline, size: 80, color: Colors.grey.shade500),
          const SizedBox(height: 12),
          const Text(
            "Leave requests are only available\nfor salary-based employees.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
