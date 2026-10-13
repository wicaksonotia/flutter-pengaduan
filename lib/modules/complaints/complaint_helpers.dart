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
        return const Color(0xFF168653);

      case 'menunggu_verifikasi':
        return const Color(0xFFE68A17);

      case 'diproses':
      case 'ditugaskan':
        return const Color(0xFF2878F0);

      case 'diverifikasi':
        return const Color(0xFF087E8B);

      case 'ditolak':
        return const Color(0xFFDC4545);

      case 'diajukan':
      default:
        return const Color(0xFF64748B);
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
