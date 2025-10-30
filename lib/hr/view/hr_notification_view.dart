// // HrNotificationView.dart
// import 'package:flutter/material.dart';
// import 'package:jobshub/clients/client_create_notification.dart';
// import 'package:jobshub/hr/view/hr_create_notification.dart';
// import 'package:jobshub/hr/view/hr_drawer_screen.dart';
// import 'package:jobshub/utils/AppColor.dart';

// class HrNotificationView extends StatelessWidget {
//   HrNotificationView({super.key});

//   final List<Map<String, String>> notifications = [
//     {
//       "title": "New Job Posted",
//       "message": "A new software developer job has been posted.",
//       "date": "29 Sept 2025",
//     },
//     {
//       "title": "Premium Feature Update",
//       "message": "Check out the new premium features in your dashboard.",
//       "date": "28 Sept 2025",
//     },
//     {
//       "title": "Payment Reminder",
//       "message": "Your subscription is about to expire. Renew now.",
//       "date": "27 Sept 2025",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final bool isWeb = MediaQuery.of(context).size.width >= 900;

//     Widget content = GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//         childAspectRatio: 2,
//       ),
//       itemCount: notifications.length,
//       itemBuilder: (context, index) {
//         final notif = notifications[index];
//         return _notificationCard(notif);
//       },
//     );

//     if (isWeb) {
//       return Material(
//         child: HrDrawer(
//           content: Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               title: const Text(
//                 "Notifications",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               backgroundColor: AppColors.primary,
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => ClientCreateNotification()),
//                     );
//                   },
//                   child: const Text(
//                     "Create",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//             body: content,
//           ),
//         ),
//       );
//     } else {
//       // Mobile: keep normal drawer
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Notifications",
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           backgroundColor: AppColors.primary,
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => HrCreateNotification()),
//                 );
//               },
//               child: const Text(
//                 "Create",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//         drawer: HrDrawer(),
//         body: content,
//       );
//     }
//   }

//   Widget _notificationCard(Map<String, String> notif) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(
//                   Icons.notifications,
//                   color: AppColors.primary,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     notif["title"]!,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(notif["message"]!),
//             const Spacer(),
//             Text(
//               notif["date"]!,
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }