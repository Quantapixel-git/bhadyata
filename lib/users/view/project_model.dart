class ProjectModel {
  final String title;
  final String description;
  final double budget;
  final String category;
  final String paymentType;
  final double paymentValue;
   String status;
  final DateTime deadline;
  final List<Map<String, String>> applicants; // ✅ New field

  ProjectModel({
    required this.title,
    required this.description,
    required this.budget,
    required this.category,
    required this.paymentType,
    required this.paymentValue,
    required this.status,
    required this.deadline,
    this.applicants = const [], // default empty
  });
}
