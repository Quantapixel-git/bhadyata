import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/session_manager.dart';

Future<bool> fetchAndStoreUserProfile() async {
  try {
    final userId = await SessionManager.getValue('user_id');
    if (userId == null || userId.isEmpty) return false;

    final url = Uri.parse("${ApiConstants.baseUrl}employeeProfileByUserId");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": int.parse(userId)}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data["success"] == true) {
      final user = data["data"]["user"];
      final profile = data["data"]["profile"];
      final hasProfile = data["data"]["has_profile"];

      await SessionManager.setValue('first_name', user['first_name'] ?? "");
      await SessionManager.setValue('last_name', user['last_name'] ?? "");
      await SessionManager.setValue('email', user['email'] ?? "");
      await SessionManager.setValue(
        'profile_image',
        user['profile_image'] ?? "",
      );
      await SessionManager.setValue(
        'kyc_approval',
        profile['kyc_approval'].toString(),
      );
      await SessionManager.setValue('has_profile', hasProfile.toString());

      return true;
    }
    return false;
  } catch (e) {
    print("🔥 Exception in fetchAndStoreUserProfile: $e");
    return false;
  }
}
