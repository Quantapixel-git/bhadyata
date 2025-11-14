// import 'package:flutter/material.dart';
// import 'package:jobshub/common/utils/app_color.dart';

// class UserNotificationsPage extends StatelessWidget {
//   const UserNotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Dummy notifications (replace later with API/DB data)
//     final List<Map<String, String>> notifications = [
//       {
//         "title": "New Job Posted",
//         "message": "A new Software Engineer position is available at ABC Pvt Ltd.",
//         "date": "29 Sept 2025"
//       },
//       {
//         "title": "Application Update",
//         "message": "Your application for UI/UX Designer has been shortlisted.",
//         "date": "28 Sept 2025"
//       },
//       {
//         "title": "Interview Scheduled",
//         "message": "Your interview for Flutter Developer is scheduled on 1 Oct 2025.",
//         "date": "27 Sept 2025"
//       },
//     ];

//     return Scaffold(
//         appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         title: const Text("Notifications",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
//         backgroundColor: AppColors.primary,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           final notif = notifications[index];
//           return Card(
//             elevation: 2,
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: AppColors.primary,
//                 child: const Icon(Icons.notifications, color: Colors.white),
//               ),
//               title: Text(
//                 notif["title"]!,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(notif["message"]!),
//                   const SizedBox(height: 4),
//                   Text(
//                     notif["date"]!,
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               onTap: () {
//                 // Later: navigate to job detail / application detail
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                      behavior: SnackBarBehavior.floating,
//                     content: Text("Tapped: ${notif["title"]}")),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
