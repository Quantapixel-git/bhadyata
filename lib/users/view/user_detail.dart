import 'package:flutter/material.dart';
import 'package:jobshub/users/view/bottom_nav.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class JobProfileDetailsPage extends StatefulWidget {
  const JobProfileDetailsPage({super.key});

  @override
  State<JobProfileDetailsPage> createState() => _JobProfileDetailsPageState();
}

class _JobProfileDetailsPageState extends State<JobProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final _skillsController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _resumeUrlController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _skillsController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _linkedinController.dispose();
    _resumeUrlController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashBoardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 800;

            Widget formContent = Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tell us more",
                      style: TextStyle(
                        fontSize: isWeb ? 26 : 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We’ll match you with the best job opportunities",
                      style: TextStyle(
                        fontSize: isWeb ? 16 : 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // 🔹 Skills
                    TextFormField(
                      controller: _skillsController,
                      decoration: _inputDecoration(
                        label: "Skills (comma separated)",
                        icon: Icons.code,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please enter your skills"
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // 🔹 Education
                    TextFormField(
                      controller: _educationController,
                      decoration: _inputDecoration(
                        label: "Education (e.g., B.Tech Computer Science)",
                        icon: Icons.school,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Education is required"
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // 🔹 Experience
                    TextFormField(
                      controller: _experienceController,
                      decoration: _inputDecoration(
                        label: "Experience (e.g., 2 years, Fresher)",
                        icon: Icons.work_outline,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please enter experience"
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // 🔹 LinkedIn
                    TextFormField(
                      controller: _linkedinController,
                      decoration: _inputDecoration(
                        label: "LinkedIn Profile URL",
                        icon: Icons.link,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return "Please enter LinkedIn URL";
                        if (!Uri.parse(v).isAbsolute) return "Enter valid URL";
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // 🔹 Resume URL
                    TextFormField(
                      controller: _resumeUrlController,
                      decoration: _inputDecoration(
                        label: "Resume URL (Google Drive, Dropbox, etc.)",
                        icon: Icons.picture_as_pdf,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return "Please enter your resume URL";
                        if (!Uri.parse(v).isAbsolute) return "Enter valid URL";
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // 🔹 Short Bio
                    TextFormField(
                      controller: _bioController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        label: "Short Bio / About Yourself",
                        icon: Icons.person_outline,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Please write a short bio"
                          : null,
                    ),
                    const SizedBox(height: 30),

                    // 🔹 Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (isWeb) {
              // 💻 Web Layout (two-panel)
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 40,
                  ),
                  child: Row(
                    children: [
                      // 🔹 Left Info Panel
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 600,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage('assets/job_bg.png'),
                              fit: BoxFit.cover,
                              opacity: 0.15,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.work_outline,
                                    size: 80,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Let’s create your job profile",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Provide details about your education, experience, and skills to get better job matches instantly.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 60),

                      // 🔹 Right Form Panel
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: SingleChildScrollView(child: formContent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // 📱 Mobile Layout
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
                    child: formContent,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
