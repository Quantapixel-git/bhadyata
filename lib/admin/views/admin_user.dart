// import 'package:flutter/material.dart';
// import 'package:jobshub/admin/views/dashboard_drawer/admin_sidebar.dart';
// import 'package:jobshub/common/utils/AppColor.dart';

// class AdminUser extends StatefulWidget {
//   const AdminUser({super.key});

//   @override
//   State<AdminUser> createState() => _AdminUserState();
// }

// class _AdminUserState extends State<AdminUser> {
//   final List<Map<String, dynamic>> users = [
//     {
//       "name": "John Doe",
//       "email": "john@example.com",
//       "mobile": "9876543210",
//       "role": "User",
//       "blocked": false
//     },
//     {
//       "name": "Jane Smith",
//       "email": "jane@example.com",
//       "mobile": "9123456780",
//       "role": "Client",
//       "blocked": true
//     },
//     {
//       "name": "Mike Johnson",
//       "email": "mike@example.com",
//       "mobile": "9001234567",
//       "role": "User",
//       "blocked": false
//     },
//   ];

//   Widget _buildUserCard(Map<String, dynamic> user) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.all(8),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(8),
//         leading: const CircleAvatar(
//           backgroundColor: AppColors.primary,
//           child: Icon(Icons.person, color: Colors.white),
//         ),
//         title: Text(
//           user["name"],
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             Text("Email: ${user["email"]}"),
//             Text("Mobile: ${user["mobile"]}"),
//             Text("Role: ${user["role"]}"),
//           ],
//         ),
//         trailing: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               user["blocked"] ? "Blocked" : "Unblocked",
//               style: TextStyle(
//                 color: user["blocked"] ? Colors.red : Colors.green,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Expanded(
//               child: Switch(
//                 value: user["blocked"],
//                 activeColor: Colors.red,
//                 onChanged: (value) {
//                   setState(() {
//                     user["blocked"] = value;
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("${user["name"]} ${value ? "blocked" : "unblocked"}"),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       bool isMobile = constraints.maxWidth < 600;
//       int crossAxisCount = constraints.maxWidth < 900
//           ? 1
//           : constraints.maxWidth < 1200
//               ? 2
//               : 3;

//       Widget content = Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: users.isEmpty
//             ? const Center(child: Text("No users found"))
//             : isMobile
//                 ? ListView.builder(
//                     itemCount: users.length,
//                     itemBuilder: (context, index) => _buildUserCard(users[index]),
//                   )
//                 : GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: crossAxisCount,
//                       mainAxisSpacing: 16,
//                       crossAxisSpacing: 16,
//                       childAspectRatio: 2.8,
//                     ),
//                     itemCount: users.length,
//                     itemBuilder: (context, index) => _buildUserCard(users[index]),
//                   ),
//       );

//       return Scaffold(
//         appBar: isMobile
//             ? AppBar(
//                 iconTheme: const IconThemeData(color: Colors.white),
//                 title: const Text(
//                   "Manage Users",
//                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 backgroundColor: AppColors.primary,
//               )
//             : null,
//         drawer: isMobile ? const AdminSidebar(selectedPage: "Manage Users") : null,
//         body: Row(
//           children: [
//             if (!isMobile)
//               const SizedBox(
//                 width: 260,
//                 child: AdminSidebar(selectedPage: "Manage Users", isWeb: true),
//               ),
//             Expanded(child: content),
//           ],
//         ),
//       );
//     });
//   }
// }
