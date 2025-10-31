// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:jobshub/admin/views/assigened_work.dart';
// import 'package:jobshub/common/utils/AppColor.dart';

// // ------------------ Assign Work Form ------------------
// class ClientAssignWorkScreen extends StatefulWidget {
//   const ClientAssignWorkScreen({super.key});

//   @override
//   State<ClientAssignWorkScreen> createState() => _ClientAssignWorkScreenState();
// }

// class _ClientAssignWorkScreenState extends State<ClientAssignWorkScreen> {
//   String? selectedCandidate;
//   final List<String> candidates = ['John Doe', 'Jane Smith', 'Alex Johnson'];
//   final TextEditingController jobTitleController = TextEditingController();
//   final TextEditingController paymentController = TextEditingController();
//   DateTime? startDate;
//   DateTime? endDate;

//   Future<void> pickDate({required bool isStart}) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           startDate = picked;
//         } else {
//           endDate = picked;
//         }
//       });
//     }
//   }

//   void _assignWork() {
//     if (selectedCandidate == null ||
//         jobTitleController.text.isEmpty ||
//         startDate == null ||
//         endDate == null ||
//         paymentController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
//       return;
//     }

//     final work = AssignedWork(
//       candidate: selectedCandidate!,
//       jobTitle: jobTitleController.text,
//       startDate: startDate!,
//       endDate: endDate!,
//       payment: double.tryParse(paymentController.text) ?? 0,
//     );

//     Navigator.pop(context, work);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isWeb = constraints.maxWidth >= 900; // Web threshold

//         // ------------------ Form content (same for both) ------------------
//         Widget formContent = SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(Icons.arrow_back,color: AppColors.primary,),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Assign Work',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Select Candidate',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: selectedCandidate,
//                 items: candidates
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (val) => setState(() => selectedCandidate = val),
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Choose Candidate',
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Job Title',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: jobTitleController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter job title',
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Start Date',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         InkWell(
//                           onTap: () => pickDate(isStart: true),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 12,
//                               horizontal: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Text(
//                               startDate != null
//                                   ? DateFormat('yyyy-MM-dd').format(startDate!)
//                                   : 'Select Start Date',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'End Date',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         InkWell(
//                           onTap: () => pickDate(isStart: false),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 12,
//                               horizontal: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Text(
//                               endDate != null
//                                   ? DateFormat('yyyy-MM-dd').format(endDate!)
//                                   : 'Select End Date',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Payment',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: paymentController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter payment amount',
//                 ),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _assignWork,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     'Assign Work',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );

//         // ------------------ MOBILE LAYOUT ------------------
//         if (!isWeb) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text(
//                 'Assign Work',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               backgroundColor: AppColors.primary,
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: formContent,
//             ),
//           );
//         }

//         // ------------------ WEB LAYOUT ------------------
//         return Scaffold(
//           backgroundColor: const Color(0xfff9f6fb),
//           body: Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 650),
//               child: Card(
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//                 margin: const EdgeInsets.all(32),
//                 child: Padding(
//                   padding: const EdgeInsets.all(28),
//                   child: formContent,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
