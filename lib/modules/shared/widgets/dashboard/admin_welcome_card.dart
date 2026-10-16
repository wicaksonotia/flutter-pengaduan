import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminWelcomeCard extends StatelessWidget {
  const AdminWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.primaryGradient),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pantau pengaduan masyarakat dan koordinasikan '
            'tindak lanjut antarunit.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}
