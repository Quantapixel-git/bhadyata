class EmployerProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImage;
  final String? referralCode;
  final String? referredBy;
  final int role;
  final int status;
  final String? fcmToken;
  final String createdAt;
  final String updatedAt;

  EmployerProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImage,
    this.referralCode,
    this.referredBy,
    required this.role,
    required this.status,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployerProfile.fromJson(Map<String, dynamic> json) {
    return EmployerProfile(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
      referralCode: json['referral_code'],
      referredBy: json['referred_by'],
      role: json['role'],
      status: json['status'],
      fcmToken: json['fcm_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
