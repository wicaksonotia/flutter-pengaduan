import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SharedComplaintStatusFilter extends StatelessWidget {
  const SharedComplaintStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.statusOptions,
    required this.onChanged,
    this.title = 'Filter pengaduan',
    this.fieldLabel = 'Status',
  });

  final String selectedStatus;
  final Map<String, String> statusOptions;
  final ValueChanged<String> onChanged;
  final String title;
  final String fieldLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveStatus = statusOptions.containsKey(selectedStatus)
        ? selectedStatus
        : (statusOptions.containsKey('') ? '' : null);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            key: ValueKey(effectiveStatus),
            initialValue: effectiveStatus,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: fieldLabel,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            items: statusOptions.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
