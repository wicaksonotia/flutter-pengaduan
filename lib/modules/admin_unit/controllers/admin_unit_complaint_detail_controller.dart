import 'package:get/get.dart';
import 'package:sigapkawan/modules/admin_unit/services/admin_unit_service.dart';

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
  final reviewing = false.obs;

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

  /// Mengambil seluruh assignment dalam bentuk Map.
  List<Map<String, dynamic>> get assignments {
    return mapList(complaint.value?['assignments']);
  }

  /// Assignment terbaru berdasarkan waktu penugasan dan ID.
  Map<String, dynamic>? get latestAssignment {
    final items = assignments;

    if (items.isEmpty) return null;

    items.sort((a, b) {
      final dateA = DateTime.tryParse('${a['ditugaskan_pada'] ?? ''}');
      final dateB = DateTime.tryParse('${b['ditugaskan_pada'] ?? ''}');

      final comparison = (dateA ?? DateTime(1970)).compareTo(
        dateB ?? DateTime(1970),
      );

      if (comparison != 0) return comparison;

      final idA = int.tryParse('${a['id'] ?? 0}') ?? 0;
      final idB = int.tryParse('${b['id'] ?? 0}') ?? 0;

      return idA.compareTo(idB);
    });

    return items.last;
  }

  /// Foto bukti hasil penanganan pada assignment terbaru.
  List<Map<String, dynamic>> get latestEvidencePhotos {
    final assignment = latestAssignment;

    if (assignment == null) return [];

    return mapList(
      assignment['evidence_photos'] ?? assignment['evidencePhotos'],
    );
  }

  /// Catatan internal dari Field Officer assignment terbaru.
  ///
  /// ComplaintResponse tidak memiliki assignment_id pada struktur
  /// yang diberikan, sehingga pencocokan dilakukan melalui user_id.
  /// Mengambil respons internal berdasarkan assignment tertentu.
  /// Tidak lagi mencocokkan hanya berdasarkan user_id.
  Map<String, dynamic>? internalResponseFromAssignment(
    Map<String, dynamic> assignment,
  ) {
    final responses = mapList(assignment['responses']);

    final matching = responses.where((response) {
      final value = response['untuk_publik'];

      return value == false || value == 0 || value == '0';
    }).toList();

    if (matching.isEmpty) return null;

    matching.sort((a, b) {
      final dateA = DateTime.tryParse('${a['created_at'] ?? ''}');
      final dateB = DateTime.tryParse('${b['created_at'] ?? ''}');

      return (dateA ?? DateTime(1970)).compareTo(dateB ?? DateTime(1970));
    });

    return matching.last;
  }

  /// Respons dari assignment terbaru.
  Map<String, dynamic>? get latestFieldOfficerResponse {
    final assignment = latestAssignment;
    if (assignment == null) return null;

    return internalResponseFromAssignment(assignment);
  }

  bool get canReviewLatestAssignment {
    final data = complaint.value;
    final assignment = latestAssignment;

    if (data == null || assignment == null) return false;

    final status = '${data['status'] ?? ''}'.toLowerCase();
    final selesaiPada = assignment['selesai_pada'];

    final assignmentId = int.tryParse('${assignment['id'] ?? ''}');

    return status == 'menunggu_pemeriksaan_unit' &&
        selesaiPada != null &&
        '$selesaiPada'.isNotEmpty &&
        assignmentId != null;
  }

  Future<bool> reviewAssignment({
    required String keputusan,
    String? catatan,
  }) async {
    if (reviewing.value || !canReviewLatestAssignment) {
      return false;
    }

    final assignment = latestAssignment;
    final assignmentId = int.tryParse('${assignment?['id'] ?? ''}');

    if (assignmentId == null) {
      actionError.value = 'Data penugasan tidak ditemukan.';
      return false;
    }

    if (keputusan == 'perlu_perbaikan' &&
        (catatan == null || catatan.trim().isEmpty)) {
      actionError.value = 'Catatan perbaikan wajib diisi.';
      return false;
    }

    reviewing.value = true;
    actionError.value = null;

    try {
      await _service.reviewAssignment(
        assignmentId: assignmentId,
        keputusan: keputusan,
        catatan: catatan,
      );

      await loadDetail();
      return true;
    } catch (e) {
      actionError.value = _messageFromError(e);
      return false;
    } finally {
      reviewing.value = false;
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
