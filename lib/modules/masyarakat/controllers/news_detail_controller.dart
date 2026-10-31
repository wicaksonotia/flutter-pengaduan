import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/data/services/berita_pengumuman_service.dart';
import 'package:get/get.dart';

class NewsDetailController extends GetxController {
  final BeritaPengumumanService _service = BeritaPengumumanService();

  final Rxn<BeritaPengumumanModel> selectedArticle =
      Rxn<BeritaPengumumanModel>();

  final RxBool isDetailLoading = false.obs;
  final RxString errorMessage = ''.obs;

  int _requestId = 0;

  Future<void> fetchDetail(int id) async {
    final requestId = ++_requestId;

    try {
      isDetailLoading.value = true;
      errorMessage.value = '';
      selectedArticle.value = null;

      final article = await _service.getPublicDetail(id);

      // Abaikan hasil request lama jika ada request baru.
      if (requestId != _requestId) return;

      selectedArticle.value = article;
    } catch (e) {
      if (requestId != _requestId) return;

      errorMessage.value = 'Gagal memuat informasi. Silakan coba kembali.';
    } finally {
      if (requestId == _requestId) {
        isDetailLoading.value = false;
      }
    }
  }

  Future<void> refreshDetail(int id) async {
    await fetchDetail(id);
  }
}
