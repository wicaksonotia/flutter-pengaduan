import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app/theme/app_theme.dart';
import '../../core/storage/token_storage.dart';
import '../home/home_view.dart';
import 'auth_service.dart';

class OtpView extends StatefulWidget {
  final String phone;
  final String? developmentOtp;

  const OtpView({super.key, required this.phone, this.developmentOtp});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final _otpController = TextEditingController();
  final _authService = AuthService();

  String? _developmentOtp;

  bool _loading = false;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    _developmentOtp = widget.developmentOtp;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _copyOtp() async {
    final otp = _developmentOtp;

    if (otp == null || otp.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: otp));

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Kode OTP berhasil disalin.')));
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode OTP 6 digit.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      await _authService.verifyOtp(phone: widget.phone, otp: otp);

      final token = await TokenStorage.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token autentikasi tidak ditemukan.');
      }

      if (!mounted) return;

      Get.offAll(() => const HomeView());
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;
      String message = 'Verifikasi OTP gagal.';

      if (data is Map) {
        message = data['message']?.toString() ?? message;

        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            message = firstError.first.toString();
          }
        }
      } else if (e.response == null) {
        message = 'Tidak dapat terhubung ke server.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _resending = true);

    try {
      final result = await _authService.requestOtp(widget.phone);

      if (!mounted) return;

      setState(() {
        _developmentOtp = result['development_otp']?.toString();
        _otpController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ??
                'Permintaan OTP baru berhasil diproses.',
          ),
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;
      final message = data is Map
          ? data['message']?.toString() ?? 'Gagal meminta OTP baru.'
          : 'Tidak dapat menghubungi server.';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.sms_outlined,
                  color: AppTheme.blue,
                  size: 31,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Verifikasi nomor HP',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Masukkan kode OTP 6 digit untuk melanjutkan.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.phone,
                style: const TextStyle(
                  color: AppTheme.navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              if (_developmentOtp != null && _developmentOtp!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFD98A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.developer_mode_rounded,
                            color: Color(0xFF9A6700),
                            size: 19,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'MODE DEVELOPMENT',
                            style: TextStyle(
                              color: Color(0xFF9A6700),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              _developmentOtp!,
                              style: const TextStyle(
                                color: AppTheme.navy,
                                fontSize: 29,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 7,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Salin OTP',
                            onPressed: _copyOtp,
                            icon: const Icon(
                              Icons.copy_rounded,
                              color: AppTheme.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Kode pengujian sementara. Jangan gunakan '
                        'mode ini di production.',
                        style: TextStyle(
                          color: Color(0xFF765B24),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                autofocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 12,
                  color: AppTheme.navy,
                ),
                decoration: InputDecoration(
                  hintText: '••••••',
                  hintStyle: const TextStyle(
                    color: Color(0xFFBCC7D7),
                    letterSpacing: 8,
                  ),
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(color: Color(0xFFE5EAF2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(color: Color(0xFFE5EAF2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: AppTheme.blue,
                      width: 1.5,
                    ),
                  ),
                ),
                onSubmitted: (_) => _verifyOtp(),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Verifikasi & Masuk',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: (_resending || _loading) ? null : _resendOtp,
                  child: Text(
                    _resending
                        ? 'Meminta kode baru...'
                        : 'Kirim ulang kode OTP',
                    style: const TextStyle(
                      color: AppTheme.blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
