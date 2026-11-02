import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NewsCategoryFilter extends StatelessWidget {
  final String selectedJenis;
  final ValueChanged<String> onChanged;

  const NewsCategoryFilter({
    super.key,
    required this.selectedJenis,
    required this.onChanged,
  });

  static const List<Map<String, String>> filters = [
    {'label': 'Semua', 'value': 'semua'},
    {'label': 'Berita', 'value': 'berita'},
    {'label': 'Pengumuman', 'value': 'pengumuman'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = filters[index];
          final value = item['value']!;
          final selected = selectedJenis == value;

          return InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => onChanged(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.navy : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected ? AppColors.navy : AppColors.border,
                ),
              ),
              child: Text(
                item['label']!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
