import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'eLingk',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  letterSpacing: -0.6,
                ),
              ),
              Text(
                'Layanan Pengaduan Masyarakat',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            onPressed: () {
              // TODO: Buka halaman notifikasi.
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}
