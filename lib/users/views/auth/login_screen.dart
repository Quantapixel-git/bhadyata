import 'package:flutter/material.dart';
import 'package:jobshub/admin/views/auth/admin_login.dart';
import 'package:jobshub/employer/views/auth/employer_login.dart';
import 'package:jobshub/hr/views/auth/hr_login_screen.dart';
import 'package:jobshub/users/views/auth/otp_screen.dart';
import 'package:jobshub/common/utils/AppColor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  String? _mobileError;
  bool _showAdminButton = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _sendOtp() {
    // final mobile = _mobileController.text.trim();
    // if (mobile.length != 10) {
    //   setState(() => _mobileError = "Enter a valid 10-digit mobile number");
    //   return;
    // }
    // setState(() => _mobileError = null);

    Future.microtask(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(mobile: '')),
      );
    });
  }

  Widget _buildRoleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRolesPage(List<Widget> buttons, bool isWeb) {
    return Padding(
      padding: const EdgeInsets.only(right: 45), // 👈 space for the arrow
      child: GridView.count(
        crossAxisCount: isWeb ? 3 : 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
        children: buttons,
      ),
    );
  }

  Widget _buildLoginContent(bool isWeb, double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),

        // 🔹 Logo (long press → admin)
        GestureDetector(
          onLongPress: () => setState(() => _showAdminButton = true),
          child: Column(
            children: [
              Image.asset("assets/job_bgr.png", height: isWeb ? 120 : 100),
              const SizedBox(height: 20),
              Text(
                "Welcome to Badhyata",
                style: TextStyle(
                  fontSize: isWeb ? 30 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Login to continue",
                style: TextStyle(
                  fontSize: isWeb ? 18 : 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // 🔹 Mobile input
        SizedBox(
          width: isWeb ? width * 0.9 : double.infinity,
          child: TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              counterText: '',
              labelText: "Mobile Number",
              prefixIcon: Icon(
                Icons.phone_iphone_rounded,
                color: AppColors.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(14),
              ),
              errorText: _mobileError,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 🔹 Send OTP Button
        SizedBox(
          width: isWeb ? width * 0.9 : double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Send OTP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // 🔹 Swipeable roles section
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Login as:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 🔹 Swipeable roles with arrow button
        SizedBox(
          height: isWeb ? 100 : 130,
          child: Stack(
            children: [
              // PageView
              PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  // Page 1
                  _buildRolesPage([
                    _buildRoleButton(
                      icon: Icons.business_center_outlined,
                      label: "Employer",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployerLogin(),
                        ),
                      ),
                    ),
                    _buildRoleButton(
                      icon: Icons.badge_outlined,
                      label: "Badhyata HR",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HrLoginPage()),
                      ),
                    ),
                    if (_showAdminButton)
                      _buildRoleButton(
                        icon: Icons.admin_panel_settings_outlined,
                        label: "Admin",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminLoginPage()),
                        ),
                      ),
                  ], isWeb),

                  // Page 2
                  _buildRolesPage([
                    _buildRoleButton(
                      icon: Icons.group_work_outlined,
                      label: "Company",
                      onTap: () {},
                    ),
                    _buildRoleButton(
                      icon: Icons.supervised_user_circle_outlined,
                      label: "Team Lead",
                      onTap: () {},
                    ),
                  ], isWeb),
                ],
              ),

              // 🔹 Right Arrow Button
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      _currentPage == 1
                          ? Icons.arrow_back_ios_new_rounded
                          : Icons.arrow_forward_ios_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      final nextPage = _currentPage == 1 ? 0 : 1;
                      _pageController.animateToPage(
                        nextPage,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5),

        // 🔹 Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 22 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),

        const SizedBox(height: 5),

        // 🔹 Admin button (hidden)
        // if (_showAdminButton)
        //   OutlinedButton.icon(
        //     onPressed: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (_) => AdminLoginPage()),
        //     ),
        //     icon: const Icon(Icons.admin_panel_settings_outlined),
        //     label: const Text("Admin Login"),
        //     style: OutlinedButton.styleFrom(
        //       side: BorderSide(color: AppColors.primary, width: 1.5),
        //       foregroundColor: AppColors.primary,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fb),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 800;

            if (isWeb) {
              // 💻 Desktop/Web Layout
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                    maxHeight: 700,
                  ),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left Branding
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/job_bgr.png", height: 160),
                              const SizedBox(height: 20),
                              Text(
                                "Welcome to Badhyata",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Connecting job seekers, HRs, employers, and companies — all in one place.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Divider
                      Container(
                        width: 1,
                        height: 400,
                        color: Colors.grey.shade300,
                      ),

                      // Right form
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildLoginContent(true, 300),
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
                    child: _buildLoginContent(false, double.infinity),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
