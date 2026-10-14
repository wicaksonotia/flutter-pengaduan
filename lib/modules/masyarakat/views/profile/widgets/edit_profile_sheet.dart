import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'profile_input_decoration.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({
    super.key,
    required this.name,
    required this.email,
    required this.onSave,
  });

  final String name;
  final String email;
  final Future<bool> Function(String name, String email) onSave;

  static Future<void> show(
    BuildContext context, {
    required String name,
    required String email,
    required Future<bool> Function(String name, String email) onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (_) =>
          EditProfileSheet(name: name, email: email, onSave: onSave),
    );
  }

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
    });

    var success = false;

    try {
      success = await widget.onSave(
        _nameController.text.trim(),
        _emailController.text.trim(),
      );
    } catch (_) {
      success = false;
    }

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSaving = false;
    });
  }

  void _close() {
    if (_isSaving) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSaving,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildHeader(),
                  const SizedBox(height: 28),

                  const Text(
                    'INFORMASI PRIBADI',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 13),

                  _buildFieldLabel('Nama lengkap'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    enabled: !_isSaving,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: ProfileInputDecoration.build(
                      hintText: 'Masukkan nama lengkap',
                      icon: Icons.person_outline_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama lengkap wajib diisi.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildFieldLabel('Alamat email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_isSaving,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: ProfileInputDecoration.build(
                      hintText: 'nama@email.com',
                      icon: Icons.alternate_email_rounded,
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';

                      if (email.isNotEmpty &&
                          !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(email)) {
                        return 'Format email belum benar.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  _buildInformationNote(),
                  const SizedBox(height: 26),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        disabledBackgroundColor: AppColors.blue.withValues(
                          alpha: 0.65,
                        ),
                        foregroundColor: AppColors.textOnPrimary,
                        disabledForegroundColor: AppColors.textOnPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSaving
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    color: AppColors.textOnPrimary,
                                  ),
                                ),
                                SizedBox(width: 11),
                                Text(
                                  'Menyimpan Perubahan...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 20,
                                ),
                                SizedBox(width: 9),
                                Text(
                                  'Simpan Perubahan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: TextButton(
                      onPressed: _isSaving ? null : _close,
                      child: const Text(
                        'Batalkan',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.manage_accounts_rounded,
            color: AppColors.textOnPrimary,
            size: 29,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profil',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Perbarui informasi akunmu',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _isSaving ? null : _close,
          style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted),
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.iconPrimary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildInformationNote() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.blueLight.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.blue, size: 19),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pastikan informasi yang kamu masukkan sudah benar.',
              style: TextStyle(
                color: AppColors.textBody,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
