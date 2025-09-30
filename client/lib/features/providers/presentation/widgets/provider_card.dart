import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/default_button.dart';

class ProviderCard extends StatelessWidget {
  final String id;
  final String name;
  final String contact;
  final String category;
  final String status;
  final bool isEven;
  final VoidCallback? onDetailsPressed;

  const ProviderCard({
    super.key,
    required this.id,
    required this.name,
    required this.contact,
    required this.category,
    required this.status,
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
                  name,
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'Activo' ? Colors.green[800] : Colors.red[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Estado: $status',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Contacto: $contact',
            style: const TextStyle(
              color: AppColors.mainBlue,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'Categoría: $category',
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