import 'package:elingk/app/theme/app_colors.dart';
import 'package:elingk/app/utils/image_url_helper.dart';
import 'package:flutter/material.dart';

import 'assignment_detail_section.dart';

class AssignmentInitialPhotos extends StatelessWidget {
  final List<Map<String, dynamic>> photos;

  const AssignmentInitialPhotos({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return AssignmentDetailSection(
      title: 'Foto Awal Pengaduan',
      child: photos.isEmpty
          ? const Text('Tidak ada foto awal.')
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: photos.map((photo) {
                final url = ImageUrlHelper.resolve(
                  photo['url'] ?? photo['path'],
                );

                if (url.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    url,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 110,
                        height: 110,
                        color: AppColors.surfaceMuted,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.iconSecondary,
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
    );
  }
}
