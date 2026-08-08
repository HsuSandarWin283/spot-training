// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/user_management/providers/user_providers.dart';
import 'package:admin_panel/src/features/user_management/pages/user_edit_dialog.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';

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
    final currentUser = ref.read(currentUserProvider);
    final currentUid = currentUser?.uid;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.userManagement,
                      style: const TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.manageRegisteredUsers,
                      style: const TextStyle(
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
                return EmptyState(
                  icon: Icons.people_outline,
                  title: AppLocalizations.of(context)!.noUsersYet,
                  subtitle: AppLocalizations.of(context)!.noUsersRegistered,
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

              final displayUsers = currentUid != null
                  ? filtered.where((u) => u['uid'] != currentUid).toList()
                  : filtered;

              if (displayUsers.isEmpty) {
                return EmptyState(
                  icon: Icons.search_off,
                  title: AppLocalizations.of(context)!.noResults,
                  subtitle: AppLocalizations.of(context)!.noUsersMatchSearch,
                );
              }

              return _buildUsersTable(context, displayUsers);
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

  Widget _buildUsersTable(BuildContext context, List<Map<String, dynamic>> users) {
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
                  columns: [
                    DataColumn(label: Text(AppLocalizations.of(context)!.user)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.email)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.phone)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.actions)),
                  ],
                  rows: users.map((user) {
                    final photoUrl = user['photoUrl'] as String? ?? '';
                    final fullName = user['fullName'] as String? ?? 'Unknown';
                    final email = user['email'] as String? ?? '';
                    final phone = user['phone'] as String? ?? '-';

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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: AdminColors.primary, size: 20),
                                onPressed: () => _openEditDialog(user),
                                tooltip: AppLocalizations.of(context)!.edit,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AdminColors.error, size: 20),
                                onPressed: () => _confirmDelete(user),
                                tooltip: AppLocalizations.of(context)!.delete,
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
        title: Text(AppLocalizations.of(context)!.deleteUser),
        content: Text(
            'Are you sure you want to delete "$fullName"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
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
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.userDeletedSuccessfully),
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
            child: Text(AppLocalizations.of(context)!.delete,
                style: const TextStyle(color: AdminColors.error)),
          ),
        ],
      ),
    );
  }
}
