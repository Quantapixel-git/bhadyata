import 'package:flutter/material.dart';
import 'package:jobshub/clients/client_dashboard.dart';
import 'package:jobshub/users/dashboard_screen.dart';
import 'package:jobshub/utils/AppColor.dart';

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
          MaterialPageRoute(builder: (context) =>  DashBoardScreen()),
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_file, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                file ?? title,
                style: TextStyle(
                  color: file != null ? Colors.black87 : Colors.grey.shade600,
                  fontWeight: file != null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _formWrapper({required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 520 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                child,
                const SizedBox(height: 24),

                // 🔹 Show navigation buttons only on Web
                if (isWeb)
                  Row(
                    children: [
                      if (_currentStep > 0)
                        OutlinedButton.icon(
                          onPressed: _previousStep,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Back"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _nextStep,
                        icon: Icon(
                          _currentStep == 4
                              ? Icons.check_circle
                              : Icons.arrow_forward,
                        ),
                        label: Text(_currentStep == 4 ? "Submit" : "Next"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 Sidebar-only steps (no content)
  List<Step> _getSidebarSteps() {
    return [
      Step(
        title: const Text("Personal"),
        content: const SizedBox.shrink(),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text("Documents"),
        content: const SizedBox.shrink(),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text("Work"),
        content: const SizedBox.shrink(),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text("Selfie"),
        content: const SizedBox.shrink(),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text("Review"),
        content: const SizedBox.shrink(),
        isActive: _currentStep >= 4,
      ),
    ];
  }

  // 🔹 Full steps with content (right side card)
  List<Step> _getSteps() {
    return [
      Step(
        title: const Text("Personal Details"),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        content: _formWrapper(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Date of Birth"),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dobController.text =
                        "${picked.day}/${picked.month}/${picked.year}";
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ["Male", "Female", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v),
                decoration: const InputDecoration(labelText: "Gender"),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: "Mobile Number"),
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextField(
                controller: _guardianController,
                decoration: const InputDecoration(
                  labelText: "Father / Guardian Name (Optional)",
                ),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text("Upload Documents"),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        content: _formWrapper(
          child: Column(
            children: [
              _uploadCard(
                "Identity Proof (Aadhaar / PAN / Passport)",
                _identityProof,
                () => setState(() => _identityProof = "identity.pdf"),
              ),
              _uploadCard(
                "Address Proof (Driving License / Utility Bill / Passport)",
                _addressProof,
                () => setState(() => _addressProof = "address.pdf"),
              ),
              _uploadCard(
                "Educational Certificate (Optional)",
                _educationProof,
                () => setState(() => _educationProof = "education.pdf"),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text("Work Details"),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        content: _formWrapper(
          child: Column(
            children: [
              TextField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  labelText: "Current Job Title (Optional)",
                ),
              ),
              TextField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: "Years of Experience",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: "Skills / Expertise",
                ),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text("Selfie Verification"),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        content: _formWrapper(
          child: Column(
            children: [
              _uploadCard(
                "Take a Selfie",
                _selfie,
                () => setState(() => _selfie = "selfie.png"),
              ),
              const SizedBox(height: 8),
              const Text(
                "💡 Tip: Ensure good lighting and your face is clearly visible.",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text("Review & Submit"),
        isActive: _currentStep >= 4,
        state: _currentStep == 4 ? StepState.editing : StepState.indexed,
        content: _formWrapper(
          child: Card(
            color: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
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
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: const Text(
              "KYC Verification",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: isWeb
              ? Row(
                  children: [
                    // 🔹 Sidebar with highlighted steps (no content duplication)
                    Container(
                      width: 260,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      color: Colors.white,
                      child: Stepper(
                        type: StepperType.vertical,
                        currentStep: _currentStep,
                        onStepTapped: (step) =>
                            setState(() => _currentStep = step),
                        controlsBuilder: (context, details) =>
                            const SizedBox.shrink(),
                        steps: _getSidebarSteps(),
                      ),
                    ),

                    // 🔹 Right side content with progress bar
                    Expanded(
                      child: Center(
                        child: Card(
                          margin: const EdgeInsets.all(40),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 🔹 Progress bar + step counter
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LinearProgressIndicator(
                                      value: (_currentStep + 1) / 5,
                                      color: AppColors.primary,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Step ${_currentStep + 1} of 5",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // 🔹 Step content
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: _getSteps()[_currentStep].content,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepTapped: (step) => setState(() => _currentStep = step),
                  onStepContinue: _nextStep,
                  onStepCancel: _previousStep,
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            OutlinedButton(
                              onPressed: details.onStepCancel,
                              child: const Text("Back"),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: Text(
                                _currentStep == 4 ? "Submit" : "Next",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  steps: _getSteps(),
                ),
        );
      },
    );
  }
}
