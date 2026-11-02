import 'package:elingk/core/network/api_client.dart';

class NewsHelper {
  NewsHelper._();

  static String formatDate(DateTime? date, {bool fullMonth = false}) {
    if (date == null) return '';

    const shortMonths = [
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

    const fullMonths = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final month = fullMonth
        ? fullMonths[date.month - 1]
        : shortMonths[date.month - 1];

    return '${date.day} $month ${date.year}';
  }

  static String resolveImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final baseUrl = Uri.parse(ApiClient.dio.options.baseUrl);

    final origin = baseUrl.replace(path: '', query: null, fragment: null);

    return origin.resolve(path).toString();
  }
}
