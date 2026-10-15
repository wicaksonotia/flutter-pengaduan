import 'package:elingk/core/network/api_client.dart';

class ImageUrlHelper {
  ImageUrlHelper._();

  static String resolve(dynamic value) {
    final path = (value ?? '').toString().trim();

    if (path.isEmpty) return '';

    // Jika API memberikan URL lengkap, gunakan langsung.
    final uri = Uri.tryParse(path);
    if (uri != null && uri.hasScheme) {
      return path;
    }

    // Ambil alamat server tanpa path /api.
    final baseUri = Uri.parse(ApiClient.dio.options.baseUrl);
    final serverUri = baseUri.replace(path: '', query: null, fragment: null);

    // Pastikan path foto menggunakan /storage/.
    final storagePath = path.startsWith('/storage/')
        ? path
        : '/storage/${path.replaceFirst(RegExp(r'^/+'), '')}';

    return serverUri.resolve(storagePath).toString();
  }
}
