import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ComplaintHeroCard extends StatelessWidget {
  const ComplaintHeroCard({super.key});

  void _onCreateComplaint(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form pengaduan akan kita buat berikutnya.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF193B68), Color(0xFF2878F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.20),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -14,
            child: Icon(
              Icons.campaign_rounded,
              size: 118,
              color: Colors.white.withValues(alpha: 0.09),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'SUARAMU BERARTI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              const Text(
                'Mari wujudkan\nlingkungan yang lebih baik.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Sampaikan laporanmu dengan mudah dan transparan.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () => _onCreateComplaint(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.blue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  label: const Text(
                    'Buat Pengaduan',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
