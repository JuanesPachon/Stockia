import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_button.dart';

class NoteCard extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String description;
  final bool isEven;
  final VoidCallback? onDetailsPressed;

  const NoteCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.isEven,
    this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven ? AppColors.mainWhite : AppColors.mainBlue.withValues(alpha: 0.1),
        border: const Border.symmetric(
          horizontal: BorderSide(color: AppColors.mainBlue, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$id - $title',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  'Categoría: $category',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            description,
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