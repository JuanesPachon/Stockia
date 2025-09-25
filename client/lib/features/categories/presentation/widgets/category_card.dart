import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_button.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String description;
  final String date;
  final bool isEven;
  final VoidCallback? onDetailsPressed;

  const CategoryCard({
    super.key,
    required this.name,
    required this.description,
    required this.date,
    this.onDetailsPressed, required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven ? AppColors.mainWhite : AppColors.mainBlue.withValues(alpha: 0.1),
        border: Border.symmetric(horizontal: BorderSide(color: AppColors.mainBlue, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Descripción: $description',
            style: const TextStyle(
              color: AppColors.mainBlue,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Align(
            alignment: Alignment.centerRight,
            child: DefaultButton(
              text: 'Detalles',
              onPressed: onDetailsPressed,
              width: 250,
              height: 35,
            ),
          ),
        ],
      ),
    );
  }
}