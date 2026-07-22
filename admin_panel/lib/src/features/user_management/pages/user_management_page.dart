// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/user_management/providers/user_providers.dart';
import 'package:admin_panel/src/features/user_management/pages/user_edit_dialog.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Management',
                      style: TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage registered users',
                      style: TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or email...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.toLowerCase()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          usersAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return const EmptyState(
                  icon: Icons.people_outline,
                  title: 'No Users Yet',
                  subtitle: 'No users have registered yet',
                );
              }

              final filtered = _searchQuery.isEmpty
                  ? users
                  : users.where((u) {
                      final name =
                          (u['fullName'] as String? ?? '').toLowerCase();
                      final email =
                          (u['email'] as String? ?? '').toLowerCase();
                      return name.contains(_searchQuery) ||
                          email.contains(_searchQuery);
                    }).toList();

              if (filtered.isEmpty) {
                return const EmptyState(
                  icon: Icons.search_off,
                  title: 'No Results',
                  subtitle: 'No users match your search',
                );
              }

              return _buildUsersTable(filtered);
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: AdminColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTable(List<Map<String, dynamic>> users) {
    return AdminCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Joined')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: users.map((user) {
                    final photoUrl = user['photoUrl'] as String? ?? '';
                    final fullName = user['fullName'] as String? ?? 'Unknown';
                    final email = user['email'] as String? ?? '';
                    final phone = user['phone'] as String? ?? '-';
                    final createdAt = user['createdAt'];

                    String joinedDate = '-';
                    if (createdAt != null) {
                      DateTime? date;
                      if (createdAt is DateTime) {
                        date = createdAt;
                      } else if (createdAt is String) {
                        date = DateTime.tryParse(createdAt);
                      }
                      if (date != null) {
                        joinedDate = '${date.day}/${date.month}/${date.year}';
                      }
                    }

                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    AdminColors.primary.withOpacity(0.2),
                                backgroundImage: photoUrl.isNotEmpty
                                    ? NetworkImage(photoUrl)
                                    : null,
                                child: photoUrl.isEmpty
                                    ? const Icon(Icons.person,
                                        size: 18, color: AdminColors.primary)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 180),
                                child: Text(
                                  fullName,
                                  style: const TextStyle(
                                    color: AdminColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              email,
                              style: const TextStyle(
                                  color: AdminColors.textSecondary,
                                  fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            phone,
                            style: const TextStyle(
                                color: AdminColors.textSecondary, fontSize: 13),
                          ),
                        ),
                        DataCell(
                          Text(
                            joinedDate,
                            style: const TextStyle(color: AdminColors.textMuted),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: AdminColors.primary, size: 20),
                                onPressed: () => _openEditDialog(user),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AdminColors.error, size: 20),
                                onPressed: () => _confirmDelete(user),
                                tooltip: 'Delete',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openEditDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (_) => UserEditDialog(user: user),
    );
  }

  void _confirmDelete(Map<String, dynamic> user) {
    final fullName = user['fullName'] as String? ?? 'Unknown';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
            'Are you sure you want to delete "$fullName"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(userServiceProvider)
                    .deleteUser(user['uid'] as String);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User deleted successfully'),
                      backgroundColor: AdminColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AdminColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete',
                style: TextStyle(color: AdminColors.error)),
          ),
        ],
      ),
    );
  }
}
