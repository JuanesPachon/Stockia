import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/product_image.dart';

class ProductSaleCard extends StatelessWidget {
  final String name;
  final int stock;
  final double price;
  final int quantity;
  final String? imageUrl;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool isEven;

  const ProductSaleCard({
    super.key,
    required this.name,
    required this.stock,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.onIncrease,
    required this.onDecrease,
    required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven ? AppColors.mainWhite : AppColors.mainBlue.withValues(alpha: 0.1),
        border: const Border(
          bottom: BorderSide(color: AppColors.mainBlue, width: 1),
        ),
      ),
      child: Row(
        children: [
          ProductImage(
            imageUrl: imageUrl,
            width: 80,
            height: 80,
            borderRadius: 12,
            fallbackIcon: Icons.inventory,
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
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Stock: $stock',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Precio c/u: ${CurrencyFormatter.formatCOP(price)}',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainBlue, width: 2),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDecrease,
                    child: const Center(
                      child: Icon(
                        Icons.remove_rounded,
                        color: AppColors.mainBlue,
                        size: 24,
                        weight: 900,
                      ),
                    ),
                  ),
                ),
              ),
              
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide.none,
                    horizontal: BorderSide(color: AppColors.mainBlue, width: 2),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$quantity',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.mainBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainBlue, width: 2),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onIncrease,
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        color: AppColors.mainBlue,
                        size: 24,
                        weight: 900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}