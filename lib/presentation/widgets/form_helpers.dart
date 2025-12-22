import 'package:flutter/material.dart';
import 'package:pharmacy_app/presentation/widgets/custom_text_field.dart';
import 'package:pharmacy_app/presentation/widgets/primary_button.dart';
import 'package:pharmacy_app/presentation/widgets/secondary_button.dart';

/// Helper widget for simple CRUD forms
class CrudForm extends StatefulWidget {
  final String title;
  final List<CrudFormField> fields;
  final VoidCallback onSave;
  final VoidCallback? onCancel;
  final String saveButtonText;
  final bool isLoading;
  final String? submitError;

  const CrudForm({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
    this.onCancel,
    this.saveButtonText = 'Lưu',
    this.isLoading = false,
    this.submitError,
  });

  @override
  State<CrudForm> createState() => _CrudFormState();
}

class _CrudFormState extends State<CrudForm> {
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24.0),
            ...widget.fields.map((field) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: field.build(context),
                )),
            if (widget.submitError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.submitError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: widget.saveButtonText,
                    isLoading: widget.isLoading,
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              widget.onSave();
                            }
                          },
                  ),
                ),
                if (widget.onCancel != null) ...[
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: SecondaryButton(
                      text: 'Huỷ',
                      onPressed: widget.onCancel,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Represents a form field
class CrudFormField {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData? icon;
  final int maxLines;

  CrudFormField({
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.maxLines = 1,
  });

  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: label,
      hintText: hint,
      validator: validator,
      prefixIcon: icon,
    );
  }
}

/// Helper widget for delete confirmation dialog
Future<bool> showDeleteConfirmation(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Huỷ'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Xoá',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Helper for CRUD list tiles
class CrudListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Widget? leading;

  const CrudListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.onEdit,
    required this.onDelete,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: leading,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: onEdit,
              child: const Text('Chỉnh sửa'),
            ),
            PopupMenuItem(
              onTap: onDelete,
              child: const Text('Xoá', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
