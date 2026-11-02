import 'package:elingk/app/data/models/berita_pengumuman_model.dart';
import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NewsArticleCard extends StatelessWidget {
  final BeritaPengumumanModel article;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const NewsArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  });

  String _categoryLabel(String value) {
    switch (value.toLowerCase()) {
      case 'pengumuman':
        return 'PENGUMUMAN';
      default:
        return 'BERITA';
    }
  }

  Color _categoryColor(String value) {
    return value.toLowerCase() == 'pengumuman'
        ? const Color(0xFFFFF3E0)
        : const Color(0xFFE8F1FF);
  }

  Color _categoryTextColor(String value) {
    return value.toLowerCase() == 'pengumuman'
        ? const Color(0xFFB76E00)
        : const Color(0xFF2463B5);
  }

  String _dateLabel() {
    final date = article.publishedAt ?? article.createdAt;
    if (date == null) return '';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 7,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _buildBadge(
                        _categoryLabel(article.jenis),
                        _categoryColor(article.jenis),
                        _categoryTextColor(article.jenis),
                      ),
                      Text(
                        _dateLabel(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if ((article.ringkasan ?? '').isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      article.ringkasan!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (showActions) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (article.canEdit)
                          _actionButton(
                            icon: Icons.edit_outlined,
                            label: 'Edit',
                            color: AppColors.navy,
                            onTap: onEdit,
                          ),

                        const SizedBox(width: 8),

                        if (article.canDelete)
                          _actionButton(
                            icon: Icons.delete_outline_rounded,
                            label: 'Hapus',
                            color: Colors.red.shade600,
                            onTap: onDelete,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final url = article.gambarUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: 88,
        height: 94,
        color: const Color(0xFFF0F3F7),
        child: url != null && url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _imagePlaceholder(),
              )
            : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.article_outlined,
        size: 30,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildBadge(String label, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w800,
          color: foreground,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
