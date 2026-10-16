import 'package:dio/dio.dart';
import 'package:elingk/modules/field_officer/controllers/field_officer_assignments_controller.dart';
import 'package:elingk/modules/field_officer/services/field_officer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FieldOfficerAssignmentDetailController extends GetxController {
  FieldOfficerAssignmentDetailController({required this.assignmentId});

  final int assignmentId;
  final FieldOfficerService _service = FieldOfficerService();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController catatanController = TextEditingController();

  final assignment = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final error = RxnString();
  final photos = <XFile>[].obs;

  Map<String, dynamic> get complaint {
    final value = assignment.value?['complaint'];

    return value is Map
        ? Map<String, dynamic>.from(value)
        : <String, dynamic>{};
  }

  bool get canSubmit =>
      assignment.value?['selesai_pada'] == null &&
      complaint['status'] == 'diproses';

  String value(dynamic data, [String fallback = '-']) {
    if (data == null || data.toString().trim().isEmpty) {
      return fallback;
    }

    return data.toString();
  }

  List<Map<String, dynamic>> extractPhotos(dynamic data) {
    if (data is! List) return [];

    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  @override
  void onClose() {
    catatanController.dispose();
    super.onClose();
  }

  Future<void> loadDetail() async {
    if (isLoading.value) return;

    isLoading.value = true;
    error.value = null;

    try {
      assignment.value = await _service.getAssignmentDetail(assignmentId);
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickPhotos(ImageSource source) async {
    if (photos.length >= 5) {
      _message('Batas foto', 'Maksimal 5 foto bukti.');
      return;
    }

    try {
      if (source == ImageSource.gallery) {
        final files = await _picker.pickMultiImage(imageQuality: 85);

        if (files.isEmpty) return;

        photos.addAll(files.take(5 - photos.length));
      } else {
        final file = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );

        if (file != null) photos.add(file);
      }
    } catch (_) {
      _message(
        'Gagal memilih foto',
        'Periksa izin kamera atau galeri perangkat.',
      );
    }
  }

  void removePhoto(int index) {
    if (isSubmitting.value) return;
    if (index < 0 || index >= photos.length) return;

    photos.removeAt(index);
  }

  Future<void> submitResult() async {
    if (isSubmitting.value) return;

    final catatan = catatanController.text.trim();

    if (catatan.isEmpty) {
      _message('Catatan wajib diisi', 'Jelaskan hasil penanganan pengaduan.');
      return;
    }

    if (photos.isEmpty) {
      _message('Foto bukti wajib', 'Pilih minimal satu foto hasil penanganan.');
      return;
    }

    if (!canSubmit) {
      _message(
        'Penugasan tidak tersedia',
        'Penugasan ini tidak dapat dikirim saat ini.',
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final result = await _service.submitAssignment(
        assignmentId: assignmentId,
        catatan: catatan,
        photoPaths: photos.map((photo) => photo.path).toList(),
      );

      photos.clear();
      catatanController.clear();

      await loadDetail();

      if (Get.isRegistered<FieldOfficerAssignmentsController>()) {
        await Get.find<FieldOfficerAssignmentsController>()
            .refreshAssignments();
      }

      _message(
        'Berhasil',
        result['message']?.toString() ?? 'Hasil penanganan berhasil dikirim.',
      );
    } on DioException catch (e) {
      debugPrint('SUBMIT STATUS: ${e.response?.statusCode}');
      debugPrint('SUBMIT RESPONSE: ${e.response?.data}');

      final data = e.response?.data;
      String message = 'Gagal mengirim hasil penanganan.';

      if (data is Map) {
        final errors = data['errors'];

        if (errors is Map) {
          message = errors.entries
              .map((entry) {
                final value = entry.value;
                final detail = value is List
                    ? value.join(', ')
                    : value.toString();

                return '${entry.key}: $detail';
              })
              .join('\n');
        } else if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      _message('Gagal mengirim', message);
    } catch (e) {
      _message('Gagal mengirim', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isSubmitting.value = false;
    }
  }

  void _message(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
