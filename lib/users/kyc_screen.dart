import 'package:flutter/material.dart';
import 'package:jobshub/users/dashboard_screen.dart';


class KycStepperPage extends StatefulWidget {
  const KycStepperPage({super.key});

  @override
  State<KycStepperPage> createState() => _KycStepperPageState();
}

class _KycStepperPageState extends State<KycStepperPage> {
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _guardianController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();

  String? _gender;
  String? _identityProof;
  String? _addressProof;
  String? _educationProof;
  String? _selfie;

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🎉 KYC Submitted Successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashBoardScreen()),
          (route) => false,
        );
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  Widget _uploadCard(String title, String? file, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_file, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(child: Text(file ?? title)),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KYC Verification"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
        controlsBuilder: (context, details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_currentStep > 0)
                TextButton(onPressed: details.onStepCancel, child: const Text("Back")),
              const SizedBox(width: 12),
              ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 4 ? "Submit" : "Next")),
            ],
          );
        },
        steps: [
          // Step 1: Personal Details
          Step(
            title: const Text("Personal Details"),
            content: Column(
              children: [
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
                TextField(controller: _dobController, readOnly: true, decoration: const InputDecoration(labelText: "Date of Birth"), onTap: () async {
                  DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now());
                  if (picked != null) _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
                }),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ["Male", "Female", "Other"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _gender = v),
                  decoration: const InputDecoration(labelText: "Gender"),
                ),
                TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
                TextField(controller: _mobileController, decoration: const InputDecoration(labelText: "Mobile Number"), keyboardType: TextInputType.phone, maxLength: 10),
                TextField(controller: _addressController, decoration: const InputDecoration(labelText: "Address")),
                TextField(controller: _guardianController, decoration: const InputDecoration(labelText: "Father / Guardian Name (Optional)")),
              ],
            ),
          ),

          // Step 2: Documents
          Step(
            title: const Text("Upload Documents"),
            content: Column(
              children: [
                _uploadCard("Identity Proof (Aadhaar / PAN / Passport)", _identityProof, () => setState(() => _identityProof = "identity.pdf")),
                const SizedBox(height: 8),
                _uploadCard("Address Proof (Driving License / Utility Bill / Passport)", _addressProof, () => setState(() => _addressProof = "address.pdf")),
                const SizedBox(height: 8),
                _uploadCard("Educational Certificate (Optional)", _educationProof, () => setState(() => _educationProof = "education.pdf")),
              ],
            ),
          ),

          // Step 3: Work Details
          Step(
            title: const Text("Work Details"),
            content: Column(
              children: [
                TextField(controller: _jobTitleController, decoration: const InputDecoration(labelText: "Current Job Title (Optional)")),
                TextField(controller: _experienceController, decoration: const InputDecoration(labelText: "Years of Experience"), keyboardType: TextInputType.number),
                TextField(controller: _skillsController, decoration: const InputDecoration(labelText: "Skills / Expertise")),
              ],
            ),
          ),

          // Step 4: Selfie
          Step(
            title: const Text("Selfie Verification"),
            content: Column(
              children: [
                _uploadCard("Take a Selfie", _selfie, () => setState(() => _selfie = "selfie.png")),
                const SizedBox(height: 8),
                const Text("Tip: Ensure good lighting and your face is clearly visible.", style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),

          // Step 5: Review & Submit
          Step(
            title: const Text("Review & Submit"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Full Name: ${_nameController.text}"),
                Text("DOB: ${_dobController.text}"),
                Text("Gender: $_gender"),
                Text("Email: ${_emailController.text}"),
                Text("Mobile: ${_mobileController.text}"),
                Text("Address: ${_addressController.text}"),
                Text("Father/Guardian: ${_guardianController.text}"),
                Text("Job Title: ${_jobTitleController.text}"),
                Text("Experience: ${_experienceController.text}"),
                Text("Skills: ${_skillsController.text}"),
                Text("Identity Proof: ${_identityProof ?? "Not uploaded"}"),
                Text("Address Proof: ${_addressProof ?? "Not uploaded"}"),
                Text("Education: ${_educationProof ?? "Not uploaded"}"),
                Text("Selfie: ${_selfie ?? "Not uploaded"}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
