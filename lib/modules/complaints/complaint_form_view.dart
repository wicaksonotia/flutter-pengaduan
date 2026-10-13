import 'dart:async';

import 'package:dio/dio.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import 'complaint_service.dart';
import 'widgets/form/complaint_form_header.dart';
import 'widgets/form/complaint_form_styles.dart';
import 'widgets/form/complaint_location_card.dart';
import 'widgets/form/complaint_photo_section.dart';
import 'widgets/form/complaint_section_heading.dart';

class ComplaintFormView extends StatefulWidget {
  const ComplaintFormView({super.key});

  @override
  State<ComplaintFormView> createState() => _ComplaintFormViewState();
}

class _ComplaintFormViewState extends State<ComplaintFormView> {
  static const int _minTitleLength = 5;
  static const int _minDescriptionLength = 10;
  static const int _maxPhotos = 5;

  static const LatLng _defaultLocation = LatLng(-7.6298, 111.5239);

  final _formKey = GlobalKey<FormState>();

  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  final _alamatController = TextEditingController();

  final _service = ComplaintService();
  final _imagePicker = ImagePicker();
  final _mapController = MapController();

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

  final List<XFile> _photos = [];

  LatLng _selectedLocation = _defaultLocation;

  bool _locationSelected = false;
  bool _gettingLocation = false;
  bool _resolvingAddress = false;
  bool _submitting = false;

  int _addressRequestId = 0;
  Timer? _geocodeDebounce;

  /// Tombol aktif hanya jika seluruh persyaratan pengaduan terpenuhi.
  bool get _isFormReady {
    return _judulController.text.trim().length >= _minTitleLength &&
        _isiController.text.trim().length >= _minDescriptionLength &&
        _locationSelected &&
        _photos.isNotEmpty &&
        !_submitting;
  }

  @override
  void initState() {
    super.initState();

    _judulController.addListener(_onFormChanged);
    _isiController.addListener(_onFormChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _getCurrentLocation(showSuccessMessage: false);
      }
    });
  }

  @override
  void dispose() {
    _geocodeDebounce?.cancel();

    _judulController.removeListener(_onFormChanged);
    _isiController.removeListener(_onFormChanged);

    _judulController.dispose();
    _isiController.dispose();
    _alamatController.dispose();

    _geocodingDio.close();

    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.info_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: AppColors.textOnPrimary,
                size: 21,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: isError ? AppColors.danger : AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ============================================================
  // LOCATION
  // ============================================================

  Future<void> _getCurrentLocation({bool showSuccessMessage = true}) async {
    if (_gettingLocation || _submitting) return;

    setState(() => _gettingLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (showSuccessMessage) {
          _showMessage(
            'GPS belum aktif. Silakan aktifkan lokasi perangkat.',
            isError: true,
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (showSuccessMessage) {
          _showMessage(
            'Izin lokasi diperlukan untuk menentukan lokasi pengaduan.',
            isError: true,
          );
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (showSuccessMessage) {
          _showMessage(
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

      if (!mounted) return;

      final point = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = point;
        _locationSelected = true;
      });

      _mapController.move(point, 16);

      await _resolveAddress(point);

      if (mounted && showSuccessMessage) {
        _showMessage('Lokasi berhasil diperbarui.');
      }
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Gagal mendapatkan lokasi. Periksa GPS dan koneksi internet.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _gettingLocation = false);
      }
    }
  }

  void _onMapTap(LatLng point) {
    if (_submitting) return;

    // Batalkan respons geocoding untuk titik sebelumnya.
    _geocodeDebounce?.cancel();
    _addressRequestId++;

    setState(() {
      _selectedLocation = point;
      _locationSelected = true;
      _resolvingAddress = false;
    });

    _alamatController.clear();

    _scheduleAddressLookup(point);
  }

  void _scheduleAddressLookup(LatLng point) {
    _geocodeDebounce?.cancel();

    _geocodeDebounce = Timer(
      const Duration(milliseconds: 800),
      () => _resolveAddress(point),
    );
  }

  Future<void> _resolveAddress(LatLng point) async {
    final requestId = ++_addressRequestId;

    if (mounted) {
      setState(() => _resolvingAddress = true);
    }

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

      if (!mounted || requestId != _addressRequestId) return;

      final data = response.data;
      final addressData = data is Map ? data['address'] : null;

      String address = '';

      if (addressData is Map) {
        final parts = <String>[];

        void addPart(dynamic value) {
          if (value == null) return;

          final text = value.toString().trim();

          if (text.isNotEmpty && !parts.contains(text)) {
            parts.add(text);
          }
        }

        addPart(addressData['road']);
        addPart(addressData['suburb']);
        addPart(addressData['neighbourhood']);
        addPart(addressData['village']);
        addPart(addressData['town']);
        addPart(addressData['city']);
        addPart(addressData['county']);
        addPart(addressData['state_district']);
        addPart(addressData['state']);
        addPart(addressData['postcode']);

        address = parts.join(', ');
      }

      if (address.isEmpty && data is Map) {
        address = data['display_name']?.toString() ?? '';
      }

      if (address.isNotEmpty) {
        _alamatController.text = address;
      }
    } catch (_) {
      if (mounted && requestId == _addressRequestId) {
        _showMessage(
          'Alamat otomatis tidak tersedia. Kamu bisa mengisinya sendiri.',
          isError: true,
        );
      }
    } finally {
      if (mounted && requestId == _addressRequestId) {
        setState(() => _resolvingAddress = false);
      }
    }
  }

  // ============================================================
  // PHOTOS
  // ============================================================

  Future<void> _showPhotoOptions() async {
    if (_submitting) return;

    if (_photos.length >= _maxPhotos) {
      _showMessage('Maksimal 5 foto.', isError: true);
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Tambahkan Foto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pilih sumber foto pengaduanmu.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _PhotoSourceButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Kamera',
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _pickPhotos(ImageSource.camera);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PhotoSourceButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Galeri',
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _pickPhotos(ImageSource.gallery);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickPhotos(ImageSource source) async {
    if (_submitting) return;

    try {
      final remaining = _maxPhotos - _photos.length;

      if (remaining <= 0) {
        _showMessage('Maksimal 5 foto.', isError: true);
        return;
      }

      if (source == ImageSource.gallery) {
        final picked = await _imagePicker.pickMultiImage(
          imageQuality: 85,
          limit: remaining,
        );

        if (!mounted || picked.isEmpty) return;

        setState(() {
          _photos.addAll(picked.take(remaining));
        });
      } else {
        final picked = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );

        if (!mounted || picked == null) return;

        setState(() {
          _photos.add(picked);
        });
      }
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Gagal mengambil foto. Periksa izin kamera atau galeri.',
          isError: true,
        );
      }
    }
  }

  void _removePhoto(int index) {
    if (_submitting) return;
    if (index < 0 || index >= _photos.length) return;

    setState(() {
      _photos.removeAt(index);
    });
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submitComplaint() async {
    FocusScope.of(context).unfocus();

    if (!_isFormReady || _submitting) return;

    if (!_formKey.currentState!.validate()) {
      _showMessage('Periksa kembali judul dan isi pengaduan.', isError: true);
      return;
    }

    setState(() => _submitting = true);

    try {
      final response = await _service.createComplaint(
        judul: _judulController.text.trim(),
        isiPengaduan: _isiController.text.trim(),
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        alamat: _alamatController.text.trim().isEmpty
            ? null
            : _alamatController.text.trim(),
        photoPaths: _photos.map((photo) => photo.path).toList(),
      );

      if (!mounted) return;

      if (response['status'] == 'success' || response['status'] == true) {
        _showMessage('Pengaduan berhasil dikirim.');
        Navigator.of(context).pop(true);
      } else {
        _showMessage(
          response['message']?.toString() ?? 'Pengaduan gagal dikirim.',
          isError: true,
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;
      final message = data is Map ? data['message']?.toString() : null;

      _showMessage(
        message ?? 'Gagal mengirim pengaduan. Periksa koneksi internet.',
        isError: true,
      );
    } catch (e) {
      if (mounted) {
        _showMessage(
          e.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            ComplaintFormHeader(
              onBack: () {
                if (!_submitting) {
                  Navigator.of(context).maybePop();
                }
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
                children: [
                  const ComplaintSectionHeading(
                    number: '01',
                    title: 'Ceritakan masalahnya',
                    subtitle: 'Jelaskan kejadian agar mudah ditindaklanjuti.',
                  ),
                  const SizedBox(height: 14),
                  _buildComplaintFields(),
                  const SizedBox(height: 28),
                  const ComplaintSectionHeading(
                    number: '02',
                    title: 'Lokasi kejadian',
                    subtitle: 'Tentukan titik lokasi pengaduan dengan tepat.',
                  ),
                  const SizedBox(height: 14),
                  ComplaintLocationCard(
                    mapController: _mapController,
                    selectedLocation: _selectedLocation,
                    locationSelected: _locationSelected,
                    gettingLocation: _gettingLocation,
                    resolvingAddress: _resolvingAddress,
                    submitting: _submitting,
                    addressController: _alamatController,
                    onGetCurrentLocation: _getCurrentLocation,
                    onMapTap: _onMapTap,
                  ),
                  const SizedBox(height: 28),
                  const ComplaintSectionHeading(
                    number: '03',
                    title: 'Foto pendukung',
                    subtitle: 'Bukti foto membantu petugas memahami kondisi.',
                    trailing: '1–5 foto',
                  ),
                  const SizedBox(height: 14),
                  ComplaintPhotoSection(
                    photos: _photos,
                    onAddPhoto: _showPhotoOptions,
                    onRemovePhoto: _removePhoto,
                  ),
                  const SizedBox(height: 20),
                  _buildReminder(),
                ],
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintFields() {
    return ComplaintFormStyles.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComplaintFormStyles.fieldLabel('Judul pengaduan'),
          const SizedBox(height: 9),
          TextFormField(
            controller: _judulController,
            enabled: !_submitting,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            maxLength: 120,
            decoration: ComplaintFormStyles.inputDecoration(
              hint: 'Contoh: Jalan rusak di depan sekolah',
              prefixIcon: Icons.short_text_rounded,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Judul pengaduan wajib diisi.';
              }

              if (value.trim().length < _minTitleLength) {
                return 'Judul minimal 5 karakter.';
              }

              return null;
            },
          ),
          const SizedBox(height: 10),
          ComplaintFormStyles.fieldLabel('Detail pengaduan'),
          const SizedBox(height: 9),
          TextFormField(
            controller: _isiController,
            enabled: !_submitting,
            textCapitalization: TextCapitalization.sentences,
            minLines: 5,
            maxLines: 8,
            maxLength: 3000,
            decoration: ComplaintFormStyles.inputDecoration(
              hint: 'Ceritakan apa yang terjadi, kapan kejadian berlangsung, dan dampaknya...',
              alignTop: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Detail pengaduan wajib diisi.';
              }

              if (value.trim().length < _minDescriptionLength) {
                return 'Detail minimal 10 karakter.';
              }

              return null;
            },
          ),
          const SizedBox(height: 2),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 17,
                color: AppColors.warning,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Gunakan bahasa yang jelas dan sertakan informasi yang kamu ketahui.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReminder() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: AppColors.textPrimary,
            size: 21,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Periksa sebelum mengirim',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pastikan informasi, lokasi, dan foto sudah sesuai sebelum mengirim pengaduan.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final isReady = _isFormReady;

    return Container(
      padding: EdgeInsets.fromLTRB(18, 13, 18, 13 + bottomInset),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: isReady ? _submitComplaint : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            disabledBackgroundColor: AppColors.surfaceMuted,
            foregroundColor: AppColors.textOnPrimary,
            disabledForegroundColor: AppColors.textMuted,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _submitting
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Mengirim pengaduan...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send_rounded,
                      size: 19,
                      color: isReady
                          ? AppColors.textOnPrimary
                          : AppColors.textMuted,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Kirim Pengaduan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _PhotoSourceButton extends StatelessWidget {
  const _PhotoSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 28),
            const SizedBox(height: 9),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
