import 'dart:async';

import 'package:dio/dio.dart';
import 'package:elingk/modules/masyarakat/views/complaints/complaint_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class ComplaintFormController extends GetxController {
  static const int minTitleLength = 5;
  static const int minDescriptionLength = 10;
  static const int maxPhotos = 5;

  static const LatLng defaultLocation = LatLng(-7.6298, 111.5239);

  final formKey = GlobalKey<FormState>();
  final judulController = TextEditingController();
  final isiController = TextEditingController();
  final alamatController = TextEditingController();

  final mapController = MapController();
  final ComplaintService _service = ComplaintService();
  final ImagePicker _imagePicker = ImagePicker();

  final Dio _geocodingDio = Dio(
    BaseOptions(
      baseUrl: 'https://nominatim.openstreetmap.org',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'User-Agent': 'eLingk/1.0 Flutter Mobile App',
        'Accept-Language': 'id',
      },
    ),
  );

  final RxList<XFile> photos = <XFile>[].obs;
  final Rx<LatLng> selectedLocation = defaultLocation.obs;
  final RxBool locationSelected = false.obs;
  final RxBool gettingLocation = false.obs;
  final RxBool resolvingAddress = false.obs;
  final RxBool submitting = false.obs;

  Timer? _geocodeDebounce;
  int _addressRequestId = 0;

  bool get isFormReady =>
      judulController.text.trim().length >= minTitleLength &&
      isiController.text.trim().length >= minDescriptionLength &&
      locationSelected.value &&
      photos.isNotEmpty &&
      !submitting.value;

  @override
  void onInit() {
    super.onInit();
    judulController.addListener(_onFormChanged);
    isiController.addListener(_onFormChanged);
  }

  @override
  void onReady() {
    super.onReady();
    getCurrentLocation(showSuccessMessage: false);
  }

  void _onFormChanged() {
    update();
  }

  void showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'Perhatian' : 'Informasi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> getCurrentLocation({bool showSuccessMessage = true}) async {
    if (gettingLocation.value || submitting.value) return;

    gettingLocation.value = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (showSuccessMessage) {
          showMessage(
            'GPS belum aktif. Silakan aktifkan lokasi perangkat.',
            isError: true,
          );
        }
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (showSuccessMessage) {
          showMessage(
            'Izin lokasi diperlukan untuk menentukan lokasi pengaduan.',
            isError: true,
          );
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (showSuccessMessage) {
          showMessage(
            'Aktifkan izin lokasi melalui pengaturan aplikasi.',
            isError: true,
          );
        }
        await Geolocator.openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      final point = LatLng(position.latitude, position.longitude);

      selectedLocation.value = point;
      locationSelected.value = true;
      mapController.move(point, 16);

      await resolveAddress(point);

      if (showSuccessMessage) {
        showMessage('Lokasi berhasil diperbarui.');
      }
    } catch (_) {
      showMessage(
        'Gagal mendapatkan lokasi. Periksa GPS dan koneksi internet.',
        isError: true,
      );
    } finally {
      gettingLocation.value = false;
    }
  }

  void onMapTap(LatLng point) {
    if (submitting.value) return;

    _geocodeDebounce?.cancel();
    _addressRequestId++;

    selectedLocation.value = point;
    locationSelected.value = true;
    resolvingAddress.value = false;
    alamatController.clear();

    _geocodeDebounce = Timer(
      const Duration(milliseconds: 800),
      () => resolveAddress(point),
    );
  }

  Future<void> resolveAddress(LatLng point) async {
    final requestId = ++_addressRequestId;
    resolvingAddress.value = true;

    try {
      final response = await _geocodingDio.get(
        '/reverse',
        queryParameters: {
          'format': 'jsonv2',
          'lat': point.latitude,
          'lon': point.longitude,
          'addressdetails': 1,
          'zoom': 18,
        },
      );

      if (isClosed || requestId != _addressRequestId) return;

      final data = response.data;
      final rawAddress = data is Map ? data['address'] : null;
      final parts = <String>[];

      if (rawAddress is Map) {
        void addPart(dynamic value) {
          if (value == null) return;
          final text = value.toString().trim();

          if (text.isNotEmpty && !parts.contains(text)) {
            parts.add(text);
          }
        }

        addPart(rawAddress['road']);
        addPart(rawAddress['suburb']);
        addPart(rawAddress['neighbourhood']);
        addPart(rawAddress['village']);
        addPart(rawAddress['town']);
        addPart(rawAddress['city']);
        addPart(rawAddress['county']);
        addPart(rawAddress['state_district']);
        addPart(rawAddress['state']);
        addPart(rawAddress['postcode']);
      }

      var address = parts.join(', ');

      if (address.isEmpty && data is Map) {
        address = data['display_name']?.toString() ?? '';
      }

      if (address.isNotEmpty) {
        alamatController.text = address;
      }
    } catch (_) {
      if (!isClosed && requestId == _addressRequestId) {
        showMessage(
          'Alamat otomatis tidak tersedia. Kamu bisa mengisinya sendiri.',
          isError: true,
        );
      }
    } finally {
      if (!isClosed && requestId == _addressRequestId) {
        resolvingAddress.value = false;
      }
    }
  }

  Future<void> pickPhotos(ImageSource source) async {
    if (submitting.value) return;

    final remaining = maxPhotos - photos.length;

    if (remaining <= 0) {
      showMessage('Maksimal 5 foto.', isError: true);
      return;
    }

    try {
      if (source == ImageSource.gallery) {
        final picked = await _imagePicker.pickMultiImage(
          imageQuality: 85,
          limit: remaining,
        );

        if (isClosed || picked.isEmpty) return;
        photos.addAll(picked.take(remaining));
      } else {
        final picked = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );

        if (isClosed || picked == null) return;
        photos.add(picked);
      }
    } catch (_) {
      showMessage(
        'Gagal mengambil foto. Periksa izin kamera atau galeri.',
        isError: true,
      );
    }
  }

  void removePhoto(int index) {
    if (submitting.value) return;
    if (index < 0 || index >= photos.length) return;

    photos.removeAt(index);
  }

  Future<bool> submitComplaint() async {
    if (submitting.value || !isFormReady) return false;

    if (!(formKey.currentState?.validate() ?? false)) {
      showMessage('Periksa kembali judul dan isi pengaduan.', isError: true);
      return false;
    }

    submitting.value = true;

    try {
      final response = await _service.createComplaint(
        judul: judulController.text.trim(),
        isiPengaduan: isiController.text.trim(),
        latitude: selectedLocation.value.latitude,
        longitude: selectedLocation.value.longitude,
        alamat: alamatController.text.trim().isEmpty
            ? null
            : alamatController.text.trim(),
        photoPaths: photos.map((photo) => photo.path).toList(),
      );

      if (response['status'] == 'success' || response['status'] == true) {
        showMessage('Pengaduan berhasil dikirim.');
        return true;
      }

      showMessage(
        response['message']?.toString() ?? 'Pengaduan gagal dikirim.',
        isError: true,
      );
      return false;
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map ? data['message']?.toString() : null;

      showMessage(
        message ?? 'Gagal mengirim pengaduan. Periksa koneksi internet.',
        isError: true,
      );
      return false;
    } catch (e) {
      showMessage(e.toString().replaceFirst('Exception: ', ''), isError: true);
      return false;
    } finally {
      submitting.value = false;
    }
  }

  @override
  void onClose() {
    _geocodeDebounce?.cancel();
    _addressRequestId++;

    judulController.removeListener(_onFormChanged);
    isiController.removeListener(_onFormChanged);

    judulController.dispose();
    isiController.dispose();
    alamatController.dispose();

    _geocodingDio.close();
    super.onClose();
  }
}
