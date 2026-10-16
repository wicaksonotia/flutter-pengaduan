import 'package:elingk/modules/masyarakat/bindings/complaint_form_binding.dart';
import 'package:elingk/modules/masyarakat/controllers/complaint_form_controller.dart';
import 'package:elingk/modules/masyarakat/widgets/form/complaint_form_header.dart';
import 'package:elingk/modules/masyarakat/widgets/form/complaint_location_card.dart';
import 'package:elingk/modules/masyarakat/widgets/form/complaint_photo_section.dart';
import 'package:elingk/modules/shared/views/complaint/complaint_photo_source_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintFormView extends StatefulWidget {
  const ComplaintFormView({super.key});

  @override
  State<ComplaintFormView> createState() => _ComplaintFormViewState();
}

class _ComplaintFormViewState extends State<ComplaintFormView> {
  late final ComplaintFormController controller;

  @override
  void initState() {
    super.initState();

    ComplaintFormBinding().dependencies();
    controller = Get.find<ComplaintFormController>();
  }

  @override
  void dispose() {
    if (Get.isRegistered<ComplaintFormController>()) {
      Get.delete<ComplaintFormController>(force: true);
    }

    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final success = await controller.submitComplaint();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _showPhotoOptions() async {
    if (controller.submitting.value) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tambah Foto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pilih sumber foto untuk mendukung pengaduanmu.',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
                ComplaintPhotoSourceButton(
                  icon: Icons.camera_alt_outlined,
                  title: 'Ambil Foto',
                  subtitle: 'Gunakan kamera perangkat',
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickPhotos(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 10),
                ComplaintPhotoSourceButton(
                  icon: Icons.photo_library_outlined,
                  title: 'Pilih dari Galeri',
                  subtitle: 'Pilih foto yang sudah tersimpan',
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickPhotos(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComplaintFormController>(
      builder: (_) {
        return Obx(() {
          final isSubmitting = controller.submitting.value;
          final isReady = controller.isFormReady;

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FB),
            body: SafeArea(
              child: Column(
                children: [
                  ComplaintFormHeader(
                    onBack: () {
                      if (!isSubmitting) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  Expanded(
                    child: Form(
                      key: controller.formKey,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                        children: [
                          _buildIntro(),
                          const SizedBox(height: 24),

                          _buildSectionHeading(
                            number: '01',
                            title: 'Ceritakan Pengaduan',
                            subtitle: 'Jelaskan masalah yang kamu temukan secara jelas.',
                          ),
                          const SizedBox(height: 14),
                          _buildComplaintFields(),
                          const SizedBox(height: 28),

                          _buildSectionHeading(
                            number: '02',
                            title: 'Lokasi Kejadian',
                            subtitle: 'Tentukan titik lokasi agar petugas mudah menemukan tempat kejadian.',
                          ),
                          const SizedBox(height: 14),
                          ComplaintLocationCard(
                            mapController: controller.mapController,
                            selectedLocation: controller.selectedLocation.value,
                            locationSelected: controller.locationSelected.value,
                            gettingLocation: controller.gettingLocation.value,
                            resolvingAddress: controller.resolvingAddress.value,
                            submitting: isSubmitting,
                            addressController: controller.alamatController,
                            onGetCurrentLocation: () {
                              controller.getCurrentLocation();
                            },
                            onMapTap: controller.onMapTap,
                          ),
                          const SizedBox(height: 28),

                          _buildSectionHeading(
                            number: '03',
                            title: 'Bukti Foto',
                            subtitle: 'Tambahkan foto yang menunjukkan kondisi di lokasi.',
                          ),
                          const SizedBox(height: 14),
                          ComplaintPhotoSection(
                            photos: controller.photos.toList(),
                            onAddPhoto: _showPhotoOptions,
                            onRemovePhoto: controller.removePhoto,
                          ),
                          const SizedBox(height: 22),

                          _buildReminder(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomAction(
                    isReady: isReady,
                    isSubmitting: isSubmitting,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7ECF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'LAYANAN MASYARAKAT',
              style: TextStyle(
                color: Color(0xFF245BC5),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Buat Pengaduan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172B4D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sampaikan laporanmu dengan melengkapi informasi, '
            'lokasi kejadian, dan bukti pendukung.',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF68758A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading({
    required String number,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFF245BC5),
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172B4D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Color(0xFF68758A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintFields() {
    final isSubmitting = controller.submitting.value;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Judul Pengaduan'),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.judulController,
            enabled: !isSubmitting,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 120,
            decoration: _inputDecoration(
              hintText: 'Contoh: Jalan rusak di depan balai desa',
              prefixIcon: Icons.edit_note_rounded,
            ),
            validator: (value) {
              final text = value?.trim() ?? '';

              if (text.isEmpty) {
                return 'Judul pengaduan wajib diisi.';
              }

              if (text.length < ComplaintFormController.minTitleLength) {
                return 'Judul minimal 5 karakter.';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildFieldLabel('Isi Pengaduan'),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.isiController,
            enabled: !isSubmitting,
            textCapitalization: TextCapitalization.sentences,
            minLines: 5,
            maxLines: 8,
            maxLength: 3000,
            decoration: _inputDecoration(
              hintText: 'Jelaskan kejadian, kondisi yang ditemukan, dan informasi lain yang diperlukan...',
              alignLabelWithHint: true,
            ),
            validator: (value) {
              final text = value?.trim() ?? '';

              if (text.isEmpty) {
                return 'Isi pengaduan wajib diisi.';
              }

              if (text.length < ComplaintFormController.minDescriptionLength) {
                return 'Isi pengaduan minimal 10 karakter.';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF263650),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    IconData? prefixIcon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF9AA5B5), fontSize: 12),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: const Color(0xFF7D8CA3), size: 20),
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: const Color(0xFFF8FAFD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E7F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E7F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2F65D5), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  Widget _buildReminder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF5E5B8)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF9A6A00), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Periksa kembali laporanmu',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF805900),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Pastikan informasi benar, lokasi sesuai, dan foto '
                  'mendukung laporan. Pengaduan akan diteruskan '
                  'untuk ditinjau oleh petugas yang berwenang.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: Color(0xFF806B3B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction({
    required bool isReady,
    required bool isSubmitting,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7ECF3))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isReady && !isSubmitting ? _submit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF245BC5),
              disabledBackgroundColor: const Color(0xFFDCE3EE),
              foregroundColor: Colors.white,
              disabledForegroundColor: const Color(0xFF8793A5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: isSubmitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Mengirim Pengaduan...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Kirim Pengaduan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE7ECF3)),
    );
  }
}
