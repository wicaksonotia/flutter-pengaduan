import 'package:elingk/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppHeroCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool initiallyExpanded;

  const AppHeroCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.initiallyExpanded = true,
  });

  @override
  State<AppHeroCard> createState() => _AppHeroCardState();
}

class _AppHeroCardState extends State<AppHeroCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (!_expanded) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _expanded = true),
          icon: const Icon(Icons.expand_more_rounded),
          label: const Text('Tampilkan informasi'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(widget.icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Sembunyikan informasi',
            onPressed: () => setState(() => _expanded = false),
            icon: const Icon(Icons.expand_less_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
