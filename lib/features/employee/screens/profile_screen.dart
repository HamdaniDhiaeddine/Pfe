import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../data/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _imageLoadError = false;

  @override
  void initState() {
    super.initState();
    // Refresh user data when screen opens
    Future.microtask(
      () => context.read<AuthProvider>().loadUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        debugPrint('Building ProfileScreen with user: ${auth.user?.username}');

        if (auth.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = auth.user;
        if (user == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: const Center(
              child: Text('User not found. Please login again.'),
            ),
          );
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
            onRefresh: () async {
              await auth.loadUser();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated')),
                );
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Profile Image
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _getProfileImage(user.profileImagePath),
                        onBackgroundImageError: (exception, stackTrace) {
                          debugPrint('Error loading profile image: $exception');
                          if (mounted) {
                            setState(() {
                              _imageLoadError = true;
                            });
                          }
                        },
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: user.enabled ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            user.enabled ? Icons.check : Icons.close,
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
                            backgroundColor: _getRoleColor(role),
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
                    if (user.telNumber != null)
                      _buildInfoRow('Phone', user.telNumber!),
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
                      'Leave Balance',
                      '${user.leaveBalance} days',
                      valueColor: Colors.blue,
                    ),
                    if (user.salary != null)
                      _buildInfoRow(
                        'Salary',
                        '\$${user.salary!.toStringAsFixed(2)}',
                        valueColor: Colors.green,
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Logout Button
                ElevatedButton.icon(
                  onPressed: () => _handleLogout(context, auth),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  ImageProvider _getProfileImage(String? profileImagePath) {
    if (_imageLoadError || profileImagePath == null || profileImagePath.isEmpty) {
      return const AssetImage('assets/img/anonyme.jpg');
    }
    final fullImageUrl = profileImagePath.startsWith('http')
        ? profileImagePath
        : '${ApiConstants.baseUrl}/uploads/profile/$profileImagePath';
    return NetworkImage(fullImageUrl);
  }

  Color _getRoleColor(String role) {
    switch (role.replaceAll('ROLE_', '')) {
      case 'SUPERADMIN':
        return Colors.red.withOpacity(0.2);
      case 'ADMIN':
        return Colors.orange.withOpacity(0.2);
      case 'MANAGER':
        return Colors.blue.withOpacity(0.2);
      case 'RH':
        return Colors.purple.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
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

  Future<void> _handleLogout(BuildContext context, AuthProvider auth) async {
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
      await auth.logout(context);
    }
  }

  void _showEditProfileDialog(BuildContext context, User user) {
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