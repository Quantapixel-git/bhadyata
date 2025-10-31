class UserModel {
  String id;
  String name;
  String email;
  String role; // "client" or "worker"
  String onboardStatus; // "partial" or "complete"
  bool isVerified;
  List<String> skills; // for worker
  String? companyName; // for client
  String? gstNumber; // client verification
  String? paymentDetails; // worker side

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.onboardStatus = "partial",
    this.isVerified = false,
    this.skills = const [],
    this.companyName,
    this.gstNumber,
    this.paymentDetails,
  });
}
