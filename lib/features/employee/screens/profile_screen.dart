// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../auth/providers/auth_provider.dart';
// import '../../../data/models/user.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, auth, child) {
//         final user = auth.user;
//         if (user == null) {
//           return const Center(child: Text('User not found'));
//         }

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Profile'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () => _showEditProfileDialog(context, user),
//               ),
//             ],
//           ),
//           body: ListView(
//             padding: const EdgeInsets.all(16.0),
//             children: [
//               const CircleAvatar(
//                 radius: 50,
//                 backgroundImage: AssetImage('assets/img/anonyme.jpg'),
//               ),
//               const SizedBox(height: 24),
//               _buildInfoCard(
//                 title: 'Personal Information',
//                 children: [
//                   _buildInfoRow('Full Name', user.fullname),
//                   _buildInfoRow('Email', user.username),
//                   _buildInfoRow('Position', user.position),
//                   _buildInfoRow('Gender', user.gender),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               _buildInfoCard(
//                 title: 'Contact Information',
//                 children: [
//                   _buildInfoRow('Phone', user.telNumber),
//                   _buildInfoRow('Address', user.address),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               _buildInfoCard(
//                 title: 'Employment Information',
//                 children: [
//                   _buildInfoRow('ID', user.nationalID),
//                   _buildInfoRow(
//                     'Hire Date',
//                     user.hireDate.toString().split(' ')[0],
//                   ),
//                   //_buildInfoRow('Department', user.department ?? 'Not assigned'),
//                   _buildInfoRow('Role', user.roles.join(', ')),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () async {
//                   await context.read<AuthProvider>().logout();
//                   if (context.mounted) {
//                     Navigator.of(context).pushReplacementNamed('/login');
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text('Logout'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoCard({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEditProfileDialog(BuildContext context, User user) {
//     // TODO: Implement edit profile dialog
//   }
// }