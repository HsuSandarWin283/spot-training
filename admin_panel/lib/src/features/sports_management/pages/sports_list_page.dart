// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_panel/src/core/theme/admin_theme.dart';
import 'package:admin_panel/src/core/services/sport_service.dart';
import 'package:admin_panel/src/core/widgets/admin_widgets.dart';
import 'package:admin_panel/src/features/sports_management/providers/sports_provider.dart';
import 'package:admin_panel/src/features/admin_shell/pages/admin_shell_page.dart';
import 'package:admin_panel/src/features/auth/providers/admin_auth_provider.dart';
import 'package:admin_panel/src/features/sport_detail/providers/sport_detail_providers.dart';
import 'package:admin_panel/src/core/l10n/app_localizations.dart';
import 'package:admin_panel/src/core/services/locale_provider.dart';

class SportsListPage extends ConsumerWidget {
  const SportsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportsAsync = ref.watch(sportsListProvider);
    final currentLocale = ref.watch(localeProvider);

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
                      AppLocalizations.of(context)!.sportsManagement,
                      style: const TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.sportsManagementDescription,
                      style: const TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              GradientButton(
                text: AppLocalizations.of(context)!.addSport,
                icon: Icons.add,
                onPressed: () {
                  ref.read(adminViewProvider.notifier).state = AdminView.addSport;
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          sportsAsync.when(
            data: (sports) {
              if (sports.isEmpty) {
                return EmptyState(
                  icon: Icons.sports_soccer_outlined,
                  title: AppLocalizations.of(context)!.noSportsYet,
                  subtitle: AppLocalizations.of(context)!.addFirstSport,
                );
              }
               return _buildSportsTable(context, ref, sports, currentLocale);
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

  Widget _buildSportsTable(BuildContext context, WidgetRef ref,
      List<SportModel> sports, Locale currentLocale) {
    return AdminCard(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(AppLocalizations.of(context)!.sport)),
            DataColumn(label: Text(AppLocalizations.of(context)!.description)),
            DataColumn(label: Text(AppLocalizations.of(context)!.created)),
            DataColumn(label: Text(AppLocalizations.of(context)!.actions)),
          ],
          rows: sports.map((sport) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (sport.thumbnailUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            sport.thumbnailUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AdminColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.sports_soccer,
                                color: AdminColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AdminColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.sports_soccer,
                            color: AdminColors.primary,
                            size: 20,
                          ),
                        ),
                      const SizedBox(width: 12),
                       Text(
                         sport.localizedName(currentLocale.languageCode),
                         style: const TextStyle(
                           fontWeight: FontWeight.w600,
                           color: AdminColors.textPrimary,
                         ),
                       ),
                    ],
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Text(
                      sport.localizedDescription(currentLocale.languageCode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AdminColors.textSecondary),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '${sport.createdAt.day}/${sport.createdAt.month}/${sport.createdAt.year}',
                    style: const TextStyle(color: AdminColors.textMuted),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.manage_search,
                            color: AdminColors.secondary, size: 20),
                        onPressed: () {
                          ref.read(selectedSportIdProvider.notifier).state =
                              sport.id;
                          ref.read(selectedSportNameProvider.notifier).state =
                              sport.localizedName(currentLocale.languageCode);
                          ref.read(adminViewProvider.notifier).state =
                              AdminView.sportDetail;
                        },
                        tooltip: AppLocalizations.of(context)!.manageDetails,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AdminColors.primary, size: 20),
                        onPressed: () {
                          ref.read(editingSportProvider.notifier).state = sport;
                          ref.read(adminViewProvider.notifier).state =
                              AdminView.editSport;
                        },
                        tooltip: AppLocalizations.of(context)!.edit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AdminColors.error, size: 20),
                        onPressed: () =>
                            _confirmDelete(context, ref, sport),
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
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, SportModel sport) {
    final currentLocale = ref.read(localeProvider);
    final sportName = sport.localizedName(currentLocale.languageCode);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteSport),
        content: Text('Are you sure you want to delete "$sportName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref.read(sportServiceProvider).deleteSport(sport.id);
                ref.invalidate(sportsListProvider);
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text('$sportName deleted successfully'),
                       backgroundColor: AdminColors.success,
                     ),
                   );
                }
              } catch (e) {
                if (context.mounted) {
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
