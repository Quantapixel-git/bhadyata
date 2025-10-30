import 'package:flutter/material.dart';

// ------------------ Model ------------------
class WorkAssignment {
  final String title;
  final String company;
  final String employmentType; // e.g. "Salary Based" or "Task Based"
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

// ------------------ Employee Screen ------------------
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
  TextEditingController reasonController = TextEditingController();

  final List<String> leaveTypes = ["Sick", "Casual", "Personal", "Other"];
  final service = LeaveRequestService(); // shared instance

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitRequest() {
    if (selectedDate == null ||
        selectedLeaveType == null ||
        reasonController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
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

    // Clear form
    setState(() {
      selectedDate = null;
      selectedLeaveType = null;
      reasonController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Leave request submitted!")));
  }

  @override
  Widget build(BuildContext context) {
    final myRequests = service.getRequestsForEmployee(widget.employeeName);
    final work = widget.work;

    return Scaffold(
      appBar: AppBar(title: const Text("Leave Requests", style: TextStyle(fontWeight: FontWeight.bold),)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ JOB DETAILS ------------------
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Job Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.work_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(work.title, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.business_outlined, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(work.company, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.payment_outlined, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "₹${work.salary.toStringAsFixed(2)} / month",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.badge_outlined, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Type: ${work.employmentType}",
                          style: TextStyle(
                            fontSize: 16,
                            color: work.employmentType == "Salary Based Job"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ------------------ ONLY SALARY BASED EMPLOYEES CAN APPLY ------------------
            if (work.employmentType == "Salary Based Job") ...[
              Text(
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
                    child: const Text("Pick Date"),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedLeaveType,
                items: leaveTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                hint: const Text("Select Leave Type"),
                onChanged: (val) {
                  setState(() {
                    selectedLeaveType = val;
                  });
                },
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
                  child: const Text("Submit Request"),
                ),
              ),

              const Divider(height: 30),

              Text(
                "My Leave Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: myRequests.length,
                itemBuilder: (context, index) {
                  final req = myRequests[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 5),
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
                          Text(
                            "Status: ${req.status}",
                            style: TextStyle(
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
                },
              ),
            ] else
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Icon(Icons.lock_outline, size: 80, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      "Leave requests are only available\nfor salary-based employees.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
