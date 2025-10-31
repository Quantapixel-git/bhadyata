// import 'package:flutter/material.dart';
// import 'package:jobshub/extra/views/clients/client_sidebar.dart';
// import 'package:jobshub/users/views/project_model.dart';
// import 'package:jobshub/common/utils/AppColor.dart';

// class ClientDashboardPage extends StatelessWidget {
//   ClientDashboardPage({super.key});

//   final int totalWorks = 12;
//   final int pendingApproval = 5;
//   final int completedWorks = 7;
//   final double walletBalance = 12500.50;

//   final List<ProjectModel> projects = [
//     ProjectModel(
//       title: 'Website Design',
//       description: 'Landing page project',
//       budget: 5000,
//       category: 'Design',
//       paymentType: 'Salary',
//       paymentValue: 5000,
//       status: 'In Progress',
//       deadline: DateTime.now().add(const Duration(days: 7)),
//       applicants: [
//         {'name': 'Alice Johnson', 'proposal': 'I can complete this in 3 days with high quality.'},
//         {'name': 'Bob Smith', 'proposal': 'I will deliver in 2 days with responsive design.'},
//       ],
//     ),
//     ProjectModel(
//       title: 'Sales Partner',
//       description: 'Earn commission per sale',
//       budget: 0,
//       category: 'Marketing',
//       paymentType: 'Commission',
//       paymentValue: 15,
//       status: 'In Progress',
//       deadline: DateTime.now().add(const Duration(days: 15)),
//       applicants: [
//         {'name': 'Charlie Brown', 'proposal': 'Experienced in sales, I’ll close deals in 4 days.'},
//         {'name': 'Daisy Miller', 'proposal': 'I have a wide network, can boost sales quickly.'},
//       ],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final bool isWeb = constraints.maxWidth >= 900;

//         if (isWeb) {
//           return Scaffold(
//             body: Row(
//               children: [
//                 SizedBox(
//                   width: 250,
//                   child: ClientSidebar(projects: projects, isWeb: true),
//                 ),
//                 Expanded(
//                   child: Scaffold(
//                     appBar: AppBar(
//                       title: const Text(
//                         "Client Dashboard",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                           fontSize: 22,
//                         ),
//                       ),
//                       backgroundColor: Colors.white,
//                       elevation: 0,
//                       automaticallyImplyLeading: false,
//                     ),
//                     body: _buildDashboardContent(isWeb),
//                     backgroundColor: Colors.grey[100],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text(
//                 "Client Dashboard",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               iconTheme: const IconThemeData(color: Colors.white),
//               backgroundColor: AppColors.primary,
//             ),
//             drawer: ClientSidebar(projects: projects),
//             body: _buildDashboardContent(isWeb),
//             backgroundColor: Colors.grey[50],
//           );
//         }
//       },
//     );
//   }

//   // ---------- Dashboard Content ----------
// Widget _buildDashboardContent(bool isWeb) {
//   return Container(
//     color: Colors.grey[100],
//     child: SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 👋 Greeting Section (only for mobile)
//           if (!isWeb)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     "Welcome Back ",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "Here’s an overview of your work and balance.",
//                     style: TextStyle(color: Colors.black54, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),

//           // 🧮 Stats Grid
//           LayoutBuilder(
//             builder: (context, constraints) {
//               final double width = constraints.maxWidth;
//               final bool isWide = width > 800;
//               final crossAxisCount = isWeb ? 4 : 2; // ✅ Always 2 per row on mobile


//               final stats = [
//                 _statCard("Total Works", totalWorks.toString(),
//                     AppColors.primary, Icons.work, isWeb),
//                 _statCard("Pending Approval", pendingApproval.toString(),
//                     Colors.orange.shade400, Icons.pending_actions, isWeb),
//                 _statCard("Completed Works", completedWorks.toString(),
//                     Colors.green.shade400, Icons.check_circle_outline, isWeb),
//                 _statCard("Wallet Balance", "\$${walletBalance.toStringAsFixed(2)}",
//                     Colors.purple.shade400, Icons.account_balance_wallet, isWeb),
//               ];

//               return GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: crossAxisCount,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: isWeb ? 1.8 : 1.4,
//                 children: stats,
//               );
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }


//   // ---------- Stat Card ----------
//   Widget _statCard(String title, String value, Color color, IconData icon, bool isWeb) {
//   return GestureDetector(
//     onTap: () {},
//     child: AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       padding: EdgeInsets.all(isWeb ? 18 : 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color.withOpacity(0.9), color],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Colors.white, size: isWeb ? 36 : 30),
//           const Spacer(),
//           Text(
//             value,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: isWeb ? 24 : 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: isWeb ? 15 : 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// }
