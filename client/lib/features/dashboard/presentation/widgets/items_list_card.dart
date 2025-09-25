import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'stat_card.dart';

class ItemListCard extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;

  const ItemListCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.mainBlue))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.mainBlue, width: 2)),
              color: AppColors.mainBlue.withValues(alpha: 0.2),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.asMap().entries.map(
              (entry) {
                int index = entry.key;
                Map<String, String> item = entry.value;
                return StatCard(
                  label: item.keys.first,
                  value: item.values.first,
                  isEven: (index % 2 == 0),
                );
              }
            ).toList(),
          ),
        ],
      ),
    );
  }
}