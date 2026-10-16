class ComplaintStatus {
  ComplaintStatus._();

  static const Map<String, String> statusLabels = {
    '': 'Semua status',
    'diajukan': 'Diajukan',
    'ditugaskan': 'Ditugaskan',
    'diproses': 'Diproses',
    'menunggu_pemeriksaan_unit': 'Pemeriksaan unit',
    'menunggu_verifikasi': 'Menunggu verifikasi',
    'menunggu_persetujuan': 'Menunggu persetujuan',
    'selesai': 'Selesai',
    'ditolak': 'Ditolak',
    'ditutup': 'Ditutup',
  };

  static String labelOf(String? status) {
    if (status == null || status.isEmpty) {
      return statusLabels['']!;
    }

    return statusLabels[status] ?? status.replaceAll('_', ' ');
  }
}
