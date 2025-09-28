import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_button.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String category;
  final String stock;
  final String price;
  final String imageUrl;
  final bool isEven;
  final VoidCallback? onDetailsPressed;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    required this.imageUrl,
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
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.mainBlue, width: 1),
              color: Colors.orange.shade300,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.orange.shade300,
                    child: const Icon(
                      Icons.fastfood,
                      color: Colors.white,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'Categoría: $category',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'Stock: $stock',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'Precio c/u: $price',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                DefaultButton(
                  text: 'Detalles',
                  onPressed: onDetailsPressed,
                  height: 35,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}