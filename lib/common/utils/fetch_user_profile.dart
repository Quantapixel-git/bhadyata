import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobshub/common/constants/base_url.dart';
import 'package:jobshub/common/utils/session_manager.dart';

Future<bool> fetchAndStoreUserProfile() async {
  try {
    final userIdRaw = await SessionManager.getValue('user_id');
    if (userIdRaw == null) return false;
    final userIdStr = userIdRaw.toString().trim();
    if (userIdStr.isEmpty) return false;

    final userId = int.tryParse(userIdStr);
    if (userId == null) return false;

    final url = Uri.parse("${ApiConstants.baseUrl}employeeProfileByUserId");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    if (response.statusCode != 200) {
      print('fetchAndStoreUserProfile: non-200 ${response.statusCode}');
      return false;
    }

    final data = jsonDecode(response.body);
    if (data == null) {
      print('fetchAndStoreUserProfile: empty response body');
      return false;
    }

    // Accept both "success": true OR status == 1 style
    final ok = (data["success"] == true) || (data["status"] == 1);
    if (!ok) {
      print('fetchAndStoreUserProfile: api returned not-ok');
      return false;
    }

    final user = data["data"]?["user"];
    final profile = data["data"]?["profile"];
    final hasProfile = data["data"]?["has_profile"];

    if (user == null) {
      print('fetchAndStoreUserProfile: no user object in response');
      return false;
    }

    // Basic user fields (safe-guarded)
    await SessionManager.setValue('user_id', (user['id'] ?? userId).toString());
    await SessionManager.setValue(
      'first_name',
      (user['first_name'] ?? '').toString(),
    );
    await SessionManager.setValue(
      'last_name',
      (user['last_name'] ?? '').toString(),
    );
    await SessionManager.setValue('email', (user['email'] ?? '').toString());
    await SessionManager.setValue(
      'profile_image',
      (user['profile_image'] ?? '').toString(),
    );
    await SessionManager.setValue(
      'referral_code',
      (user['referral_code'] ?? '').toString(),
    );
    await SessionManager.setValue(
      'referred_by',
      (user['referred_by'] ?? '').toString(),
    );
    await SessionManager.setValue(
      'wallet_balance',
      (user['wallet_balance']?.toString() ?? '0'),
    );
    await SessionManager.setValue('role', (user['role']?.toString() ?? '1'));
    await SessionManager.setValue('status', (user['status']?.toString() ?? ''));

    // timestamps (optional)
    if (user['created_at'] != null) {
      await SessionManager.setValue(
        'user_created_at',
        user['created_at'].toString(),
      );
    }
    if (user['updated_at'] != null) {
      await SessionManager.setValue(
        'user_updated_at',
        user['updated_at'].toString(),
      );
    }

    // Profile side (may be null)
    if (profile != null && profile is Map) {
      await SessionManager.setValue(
        'has_profile',
        (hasProfile ?? true).toString(),
      );
      await SessionManager.setValue(
        'category',
        (profile['category'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'job_type',
        (profile['job_type'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'skills',
        (profile['skills'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'education',
        (profile['education'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'experience',
        (profile['experience'] ?? '').toString(),
      );
      await SessionManager.setValue('bio', (profile['bio'] ?? '').toString());
      await SessionManager.setValue(
        'linkedin_url',
        (profile['linkedin_url'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'resume_url',
        (profile['resume_url'] ?? '').toString(),
      );

      // optional bank details
      await SessionManager.setValue(
        'bank_account_name',
        (profile['bank_account_name'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'bank_account_number',
        (profile['bank_account_number'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'bank_ifsc',
        (profile['bank_ifsc'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'bank_name',
        (profile['bank_name'] ?? '').toString(),
      );
      await SessionManager.setValue(
        'bank_branch',
        (profile['bank_branch'] ?? '').toString(),
      );

      // kyc_approval if present
      if (profile['kyc_approval'] != null) {
        await SessionManager.setValue(
          'kyc_approval',
          profile['kyc_approval'].toString(),
        );
      }
    } else {
      await SessionManager.setValue(
        'has_profile',
        (hasProfile ?? false).toString(),
      );
    }

    return true;
  } catch (e, st) {
    print("🔥 Exception in fetchAndStoreUserProfile: $e\n$st");
    return false;
  }
}
