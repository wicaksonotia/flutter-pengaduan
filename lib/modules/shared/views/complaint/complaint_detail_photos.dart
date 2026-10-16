import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'complaint_detail_section.dart';

class ComplaintDetailPhotos extends StatelessWidget {
  const ComplaintDetailPhotos({
    super.key,
    required this.photos,
    required this.resolveImageUrl,
    this.title = 'Foto Pengaduan',
    this.icon = Icons.photo_library_outlined,
  });

  final List<Map<String, dynamic>> photos;
  final String Function(dynamic value) resolveImageUrl;
  final String title;
  final IconData icon;

  void _showImage(BuildContext context, String url) {
    if (url.isEmpty) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            InteractiveViewer(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 250,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(dialogContext),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }

    return ComplaintDetailSection(
      title: title,
      icon: icon,
      child: SizedBox(
        height: 112,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: photos.length,
          separatorBuilder: (_, _) => const SizedBox(width: 11),
          itemBuilder: (context, index) {
            final photo = photos[index];
            final url = resolveImageUrl(photo['url'] ?? photo['path']);

            return GestureDetector(
              onTap: () => _showImage(context, url),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  width: 125,
                  color: AppColors.surfaceMuted,
                  child: url.isEmpty
                      ? const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.textMuted,
                        )
                      : Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.textMuted,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
