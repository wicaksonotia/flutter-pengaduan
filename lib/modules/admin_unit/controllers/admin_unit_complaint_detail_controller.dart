import 'package:get/get.dart';
import 'package:elingk/modules/admin_unit/services/admin_unit_service.dart';

class AdminUnitComplaintDetailController extends GetxController {
  AdminUnitComplaintDetailController({required this.complaintId});

  final int complaintId;
  final AdminUnitService _service = AdminUnitService();

  final complaint = Rxn<Map<String, dynamic>>();
  final loading = false.obs;
  final error = Rxn<String>();

  final fieldOfficers = <Map<String, dynamic>>[].obs;
  final loadingOfficers = false.obs;
  final assigning = false.obs;
  final officersError = Rxn<String>();
  final actionError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    if (loading.value) return;

    loading.value = true;
    error.value = null;

    try {
      complaint.value = await _service.getComplaintDetail(complaintId);
    } catch (e) {
      error.value = _messageFromError(e);
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadFieldOfficers({required int unitId}) async {
    loadingOfficers.value = true;
    officersError.value = null;
    fieldOfficers.clear();

    try {
      fieldOfficers.assignAll(await _service.getFieldOfficers(unitId: unitId));
    } catch (e) {
      officersError.value = _messageFromError(e);
    } finally {
      loadingOfficers.value = false;
    }
  }

  Future<bool> assignFieldOfficer({
    required int userId,
    String? catatan,
  }) async {
    if (assigning.value) return false;

    assigning.value = true;
    actionError.value = null;

    try {
      await _service.assignFieldOfficer(
        complaintId: complaintId,
        userId: userId,
        catatan: catatan,
      );

      await loadDetail();
      return true;
    } catch (e) {
      actionError.value = _messageFromError(e);
      return false;
    } finally {
      assigning.value = false;
    }
  }

  List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _messageFromError(Object exception) {
    final message = exception.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return 'Terjadi kesalahan saat memproses pengaduan.';
  }
}
