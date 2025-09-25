import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TopListCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const TopListCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.mainBlue, width: 2))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.mainBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.mainBlue,
                      fontSize: 14,
                    ), 
                  ),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}