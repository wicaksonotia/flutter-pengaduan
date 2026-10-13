import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ComplaintHelpers {
  static String statusLabel(dynamic value) {
    final status = (value ?? '').toString().toLowerCase().trim();

    switch (status) {
      case 'diajukan':
        return 'Diajukan';
      case 'diverifikasi':
        return 'Terverifikasi';
      case 'ditugaskan':
        return 'Ditugaskan';
      case 'diproses':
        return 'Sedang Diproses';
      case 'menunggu_verifikasi':
        return 'Menunggu Verifikasi';
      case 'selesai':
        return 'Selesai';
      case 'ditutup':
        return 'Ditutup';
      case 'ditolak':
        return 'Ditolak';
      default:
        if (status.isEmpty) return 'Belum diketahui';

        return status
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
    }
  }

  static Color statusColor(dynamic value) {
    final status = (value ?? '').toString().toLowerCase().trim();

    switch (status) {
      case 'selesai':
      case 'ditutup':
        return AppColors.success;

      case 'menunggu_verifikasi':
        return AppColors.warning;

      case 'diproses':
      case 'ditugaskan':
        return AppColors.blue;

      case 'diverifikasi':
        return AppColors.info;

      case 'ditolak':
        return AppColors.danger;

      case 'diajukan':
      default:
        return AppColors.textMuted;
    }
  }

  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString())?.toLocal();
  }

  static String formatDateTime(dynamic value) {
    final date = parseDate(value);
    if (date == null) return '-';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour.$minute WIB';
  }

  static String formatCoordinate(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    final number = double.tryParse(value.toString());
    if (number == null) return value.toString();

    return number.toStringAsFixed(6);
  }
}
