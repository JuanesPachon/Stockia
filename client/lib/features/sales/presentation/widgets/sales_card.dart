import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_button.dart';

class SalesCard extends StatelessWidget {
  final String id;
  final String date;
  final String productsInfo;
  final String total;
  final bool isEven;
  final VoidCallback? onDetailsPressed;

  const SalesCard({
    super.key,
    required this.id,
    required this.date,
    required this.productsInfo,
    required this.total,
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
                  'Venta $id',
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
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
          
          Row(
            children: [
              const Text(
                'Productos:',
                style: TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  productsInfo,
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
          
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: $total',
                style: const TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              DefaultButton(
                text: 'Detalles',
                onPressed: onDetailsPressed,
                height: 35,
                width: 200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}