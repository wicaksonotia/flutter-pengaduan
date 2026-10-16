import 'package:elingk/core/network/api_client.dart';

class ImageUrlHelper {
  ImageUrlHelper._();

  static String resolve(dynamic value) {
    final path = (value ?? '').toString().trim();

    if (path.isEmpty) return '';

    final uri = Uri.tryParse(path);
    if (uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty) {
      return path;
    }

    final baseUri = Uri.parse(ApiClient.dio.options.baseUrl);
    final serverUri = baseUri.replace(path: '', query: null, fragment: null);

    final normalizedPath = path.replaceFirst(RegExp(r'^/+'), '');

    final storagePath = normalizedPath.startsWith('storage/')
        ? '/$normalizedPath'
        : '/storage/$normalizedPath';

    return serverUri.resolve(storagePath).toString();
  }
}
