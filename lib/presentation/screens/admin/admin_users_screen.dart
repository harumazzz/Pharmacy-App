import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/form_helpers.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);

    return Scaffold(
      body: usersAsync.when(
        data: (users) => users.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('Chưa có người dùng',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return CrudListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: user.username,
                    subtitle:
                        '${user.fullName ?? 'Không có tên'} | Vai trò: ${user.role}',
                    onEdit: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Chỉnh sửa người dùng chưa được hỗ trợ')),
                      );
                    },
                    onDelete: () => _deleteUser(
                      context,
                      ref,
                      user.id,
                      user.username,
                    ),
                  );
                },
              ),
        loading: () => const Center(child: LoadingSpinner()),
        error: (error, stack) => Center(
          child: ErrorDisplay(
            message: 'Lỗi tải danh sách người dùng',
            onRetry: () => ref.refresh(userListProvider),
          ),
        ),
      ),
    );
  }

  void _deleteUser(
    BuildContext context,
    WidgetRef ref,
    int userId,
    String username,
  ) async {
    final confirmed = await showDeleteConfirmation(
      context,
      title: 'Xoá người dùng',
      message: 'Bạn chắc chắn muốn xoá người dùng "$username"?',
    );

    if (confirmed && context.mounted) {
      try {
        final adminRepo = ref.read(adminRepositoryProvider);
        await adminRepo.softDeleteUser(userId);
        if (context.mounted) {
          ref.invalidate(userListProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xoá người dùng thành công')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }
}
