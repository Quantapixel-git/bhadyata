import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/utils/session_manager.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobshub/admin/views/dashboard_drawer/admin_dashboard.dart';
import 'package:jobshub/common/utils/AppColor.dart';
import 'package:jobshub/common/constants/constants.dart'; // ✅ for ApiConstants.baseUrl

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _emailError;
  String? _passwordError;

  // 🔹 Admin Login Function
  Future<void> _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _emailError = email.isEmpty ? "Email is required" : null;
        _passwordError = password.isEmpty ? "Password is required" : null;
      });
      return;
    }

    final url = Uri.parse("${ApiConstants.baseUrl}adminLogin");
    final body = {"email": email, "password": password};

    try {
      // 🔹 Show Loader Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      Navigator.pop(context); // Close loader

      // 🧾 Pretty print API logs
      print("\n═══════════════════════════════════════════");
      print("🔹 API Endpoint: $url");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Request Body: ${jsonEncode(body)}");
      print("🔹 Response Body:");
      try {
        const encoder = JsonEncoder.withIndent('  ');
        final pretty = encoder.convert(jsonDecode(response.body));
        print(pretty);
      } catch (_) {
        print(response.body);
      }
      print("═══════════════════════════════════════════\n");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (data['success'] == true || data['status'] == true)) {
        // ✅ Save admin login flag
        await SessionManager.setValue('admin_login', 'true');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Login successful ✅"),
          ),
        );

        // ✅ Navigate to Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              data['message'] ?? "Invalid credentials, please try again.",
            ),
            // backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      print("❌ Exception while logging in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Something went wrong: $e"),
          // backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildLoginContent(bool isWeb, double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),

        Image.asset("assets/job_bgr.png", height: isWeb ? 120 : 100),
        const SizedBox(height: 20),

        Text(
          "Admin Login",
          style: TextStyle(
            fontSize: isWeb ? 30 : 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign in to access the admin dashboard",
          style: TextStyle(fontSize: isWeb ? 18 : 14, color: Colors.black54),
        ),
        const SizedBox(height: 40),

        // 🔹 Email Field
        SizedBox(
          width: isWeb ? width * 0.9 : double.infinity,
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(14),
              ),
              errorText: _emailError,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 🔹 Password Field
        SizedBox(
          width: isWeb ? width * 0.9 : double.infinity,
          child: TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(14),
              ),
              errorText: _passwordError,
            ),
          ),
        ),
        const SizedBox(height: 35),

        // 🔹 Login Button
        SizedBox(
          width: isWeb ? width * 0.9 : double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
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
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  constraints: const BoxConstraints(
                    maxWidth: 800,
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                size: 90,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 25),
                              Text(
                                "Welcome, Admin!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Manage users, jobs, and system operations all from one place.",
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
                      Container(
                        width: 1,
                        height: 400,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: _buildLoginContent(true, 300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
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
