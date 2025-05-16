import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../data/models/user.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final user = auth.user;
        if (user == null) {
          return const Center(child: Text('User not found'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditProfileDialog(context, user),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => auth.loadUser(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Profile Image
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.imageUrl != null
                            ? NetworkImage(user.imageUrl!)
                            : const AssetImage('assets/img/anonyme.jpg')
                                as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: user.enabled
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            user.enabled
                                ? Icons.check
                                : Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // User Name and Role
                Center(
                  child: Column(
                    children: [
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.position ?? 'No Position',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: user.roles.map((role) {
                          return Chip(
                            label: Text(role.replaceAll('ROLE_', '')),
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Personal Information
                _buildInfoCard(
                  title: 'Personal Information',
                  icon: Icons.person,
                  children: [
                    _buildInfoRow('Full Name', user.fullName),
                    _buildInfoRow('Username', user.username),
                    _buildInfoRow('Email', user.email),
                    if (user.gender != null)
                      _buildInfoRow('Gender', user.gender!),
                    if (user.birthDate != null)
                      _buildInfoRow(
                        'Birth Date',
                        DateFormat('MMM dd, yyyy').format(user.birthDate!),
                      ),
                    if (user.nationalId != null)
                      _buildInfoRow('National ID', user.nationalId!),
                  ],
                ),
                const SizedBox(height: 16),

                // Contact Information
                _buildInfoCard(
                  title: 'Contact Information',
                  icon: Icons.contact_phone,
                  children: [
                    if (user.phoneNumber != null)
                      _buildInfoRow('Phone', user.phoneNumber!),
                    if (user.address != null)
                      _buildInfoRow('Address', user.address!),
                    _buildInfoRow('Email', user.email),
                  ],
                ),
                const SizedBox(height: 16),

                // Work Information
                _buildInfoCard(
                  title: 'Employment Information',
                  icon: Icons.work,
                  children: [
                    _buildInfoRow('Employee ID', '#${user.id}'),
                    if (user.department != null)
                      _buildInfoRow('Department', user.department!),
                    if (user.position != null)
                      _buildInfoRow('Position', user.position!),
                    if (user.hireDate != null)
                      _buildInfoRow(
                        'Hire Date',
                        DateFormat('MMM dd, yyyy').format(user.hireDate!),
                      ),
                    _buildInfoRow(
                      'Status',
                      user.enabled ? 'Active' : 'Inactive',
                      valueColor: user.enabled ? Colors.green : Colors.red,
                    ),
                    _buildInfoRow(
                      'Member Since',
                      DateFormat('MMM dd, yyyy').format(user.createdAt),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Logout Button
                ElevatedButton.icon(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed ?? false) {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, User user) {
    // TODO: Implement profile editing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text('Profile editing will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}