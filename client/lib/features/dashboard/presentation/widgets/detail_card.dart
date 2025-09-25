import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'stat_card.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final List<Map<String, String>> dropdowns;
  final List<Map<String, String>> stats;

  const DetailCard({
    super.key,
    required this.title,
    required this.dropdowns,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.mainBlue, width: 2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.mainBlue.withValues(alpha: 0.2),
              border: Border(bottom: BorderSide(color: AppColors.mainBlue, width: 2))
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.mainBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          ...dropdowns.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, String> dropdown = entry.value;
            bool isLast = index == dropdowns.length - 1;
            return DropdownRow(
              label: dropdown.keys.first, 
              value: dropdown.values.first, 
              isLast: isLast,
            );
          }),
          
          ...stats.asMap().entries.map((entry) {
            Map<String, String> stat = entry.value;
            return StatCard(
              label: stat.keys.first,
              value: stat.values.first,
              isEven: true,
            );
          }),
        ],
      ),
    );
  }
}

class DropdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const DropdownRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        border: isLast ? Border(bottom: BorderSide(color: AppColors.mainBlue, width: 2)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.mainBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              color: AppColors.mainWhite,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.mainBlue,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}