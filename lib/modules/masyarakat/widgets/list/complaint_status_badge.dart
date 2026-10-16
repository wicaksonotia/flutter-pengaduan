import 'package:elingk/modules/masyarakat/views/complaints/complaint_helpers.dart';
import 'package:flutter/material.dart';

class ComplaintStatusBadge extends StatelessWidget {
  final dynamic status;

  const ComplaintStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = ComplaintHelpers.statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        ComplaintHelpers.statusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
