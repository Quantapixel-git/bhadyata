import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobshub/common/utils/app_color.dart';

// Demo-only UI: Employee list -> Employee salary list -> New record (local only)

class SalaryDuePage extends StatefulWidget {
  const SalaryDuePage({Key? key}) : super(key: key);

  @override
  State<SalaryDuePage> createState() => _SalaryDuePageState();
}

class _SalaryDuePageState extends State<SalaryDuePage> {
  bool loading = false;
  List<Map<String, dynamic>> employees = [];

  // DEMO fallback data — replace with API later
  final demoEmployees = [
    {
      "employee_id": 54,
      "name": "Amit Sharma",
      "mobile": "9876543210",
      "joining_date": "2025-06-10",
    },
    {
      "employee_id": 55,
      "name": "Riya Verma",
      "mobile": "9988776655",
      "joining_date": "2024-10-01",
    },
    {
      "employee_id": 56,
      "name": "Sagar Patel",
      "mobile": "8765432109",
      "joining_date": "2023-04-12",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    employees = demoEmployees.map((e) => Map<String, dynamic>.from(e)).toList();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Employees', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final emp = employees[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.indigo.shade50,
                    backgroundImage: const NetworkImage(
                      'file:///mnt/data/f6e932ba-1b40-4ddf-9fb8-8dbf8371678b.png',
                    ),
                  ),
                  title: Text(emp['name'] ?? '—'),
                  subtitle: Text('Mobile: ${emp['mobile'] ?? '—'}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmployeeSalaryPage(
                          employeeId: emp['employee_id'],
                          employeeName: emp['name'],
                          joiningDate: emp['joining_date'],
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 12),
              itemCount: employees.length,
            ),
    );
  }
}

class EmployeeSalaryPage extends StatefulWidget {
  final int employeeId;
  final String employeeName;
  final String? joiningDate;

  const EmployeeSalaryPage({
    Key? key,
    required this.employeeId,
    required this.employeeName,
    this.joiningDate,
  }) : super(key: key);

  @override
  State<EmployeeSalaryPage> createState() => _EmployeeSalaryPageState();
}

class _EmployeeSalaryPageState extends State<EmployeeSalaryPage> {
  bool loading = false;

  // Local demo records store (in-memory). In production you'll fetch from API.
  List<Map<String, dynamic>> records = [];

  // demo initial records (could be empty)
  final demoRecords = <Map<String, dynamic>>[
    {
      "id": 4,
      "job_employee_id": 4,
      "employee_id": 54,
      "job_id": 6,
      "employer_id": 53,
      "start_date": "2025-11-01",
      "end_date": "2025-11-30",
      "input_monthly_amount": "20000.00",
      "calculated_amount": "20000.00",
      "total_days": 30,
      "payable_days": 30,
      "absent_days": 0,
      "leave_days": 0,
      "holiday_days": 0,
      "unmarked_days": 0,
      "per_day_basis": "pro-rata-by-month",
      "treat_unmarked_as_absent": 0,
      "paid_status": 2,
      "created_at": "2025-11-24T11:19:58.000000Z",
      "updated_at": "2025-11-24T11:19:58.000000Z",
    },
    // additional demo for other employees
    {
      "id": 5,
      "job_employee_id": 6,
      "employee_id": 55,
      "job_id": 7,
      "employer_id": 53,
      "start_date": "2025-10-01",
      "end_date": "2025-10-31",
      "input_monthly_amount": "18000.00",
      "calculated_amount": "18000.00",
      "total_days": 31,
      "payable_days": 31,
      "absent_days": 0,
      "leave_days": 0,
      "holiday_days": 0,
      "unmarked_days": 0,
      "per_day_basis": "pro-rata-by-month",
      "treat_unmarked_as_absent": 0,
      "paid_status": 2,
      "created_at": "2025-10-31T11:00:00.000000Z",
      "updated_at": "2025-10-31T11:00:00.000000Z",
    },
  ];

  int _nextId = 100;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    // filter demoRecords for this employee
    records = demoRecords
        .where((r) => r['employee_id'] == widget.employeeId)
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
    setState(() {
      loading = false;
    });
  }

  Widget _buildRecordTile(Map<String, dynamic> r) {
    final start = r['start_date'] ?? '';
    final end = r['end_date'] ?? '';
    final amount = r['calculated_amount'] ?? r['input_monthly_amount'] ?? '0';
    final paidStatus = r['paid_status'] ?? 2;
    final paidLabel = (paidStatus == 1) ? 'Paid' : 'Unpaid';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Period: $start → $end',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  'Payable: ₹$amount',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text('Status: $paidLabel'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Record'),
                  content: Text(
                    'ID: ${r['id']}\nAmount: ₹$amount\nStatus: $paidLabel',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  String _formatJoining() {
    try {
      if (widget.joiningDate == null) return '';
      final d = DateTime.parse(widget.joiningDate!);
      return DateFormat.yMMMd().format(d);
    } catch (_) {
      return widget.joiningDate ?? '';
    }
  }

  // Called by NewSalaryRecordPage when a new record is created (local)
  void _addRecordLocally(Map<String, dynamic> rec) {
    setState(() {
      rec['id'] = _nextId++;
      records.insert(0, rec);
    });
  }

  @override
  Widget build(BuildContext context) {
    final join = _formatJoining();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.employeeName,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            if (join.isNotEmpty)
              Text(
                'Joined: $join\n Salary: 20,000',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: records.isEmpty
                        ? const Center(child: Text('No salary records found.'))
                        : ListView.builder(
                            itemCount: records.length,
                            itemBuilder: (_, i) => _buildRecordTile(records[i]),
                          ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final rec = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewSalaryRecordPage(
                            employeeId: widget.employeeId,
                          ),
                        ),
                      );
                      if (rec != null) {
                        // Add locally
                        _addRecordLocally(rec);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('New Record'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class NewSalaryRecordPage extends StatefulWidget {
  final int employeeId;
  final int? jobId;
  final int? employerId;

  const NewSalaryRecordPage({
    Key? key,
    required this.employeeId,
    this.jobId,
    this.employerId,
  }) : super(key: key);

  @override
  State<NewSalaryRecordPage> createState() => _NewSalaryRecordPageState();
}

class _NewSalaryRecordPageState extends State<NewSalaryRecordPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  final _amountCtrl = TextEditingController();
  bool _treatUnmarkedAsPaid = false; // false => unmarked = present (paid)
  bool _loading = false;

  final DateFormat _fmt = DateFormat('yyyy-MM-dd');

  Future<void> _pickStart() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEnd() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  void _saveLocally() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick start and end dates')),
      );
      return;
    }
    if (_startDate!.isAfter(_endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start date must be before end date')),
      );
      return;
    }
    final amountText = _amountCtrl.text.trim();
    if (amountText.isEmpty || double.tryParse(amountText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid monthly amount')),
      );
      return;
    }

    final rec = <String, dynamic>{
      'job_employee_id': widget.jobId ?? 0,
      'employee_id': widget.employeeId,
      'job_id': widget.jobId ?? 0,
      'employer_id': widget.employerId ?? 0,
      'start_date': _fmt.format(_startDate!),
      'end_date': _fmt.format(_endDate!),
      'input_monthly_amount': double.parse(amountText).toStringAsFixed(2),
      // For demo we assume full calculation equals input amount
      'calculated_amount': double.parse(amountText).toStringAsFixed(2),
      'total_days': _endDate!.difference(_startDate!).inDays + 1,
      'payable_days': _endDate!.difference(_startDate!).inDays + 1,
      'absent_days': 0,
      'leave_days': 0,
      'holiday_days': 0,
      'unmarked_days': 0,
      'per_day_basis': 'pro-rata-by-month',
      'treat_unmarked_as_absent': _treatUnmarkedAsPaid ? 1 : 0,
      'paid_status': 2,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    // return this record to caller to add locally
    Navigator.pop(context, rec);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startText = _startDate == null
        ? 'Pick start date'
        : _fmt.format(_startDate!);
    final endText = _endDate == null ? 'Pick end date' : _fmt.format(_endDate!);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'New Salary Record',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Start date'),
              subtitle: Text(startText),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickStart,
              ),
            ),
            ListTile(
              title: const Text('End date'),
              subtitle: Text(endText),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickEnd,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monthly amount',
                prefixText: '₹',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Unmarked dates:'),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<bool>(
                    isExpanded: true,
                    value: _treatUnmarkedAsPaid,
                    items: const [
                      DropdownMenuItem(
                        value: false,
                        child: Text('Unmarked = Present (Paid)'),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('Unmarked = Absent (Unpaid)'),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => _treatUnmarkedAsPaid = v ?? false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveLocally,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Save (demo)'),
                  ),
          ],
        ),
      ),
    );
  }
}
