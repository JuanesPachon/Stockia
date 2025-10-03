import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final Color? backgroundColor;
  final IconData fallbackIcon;
  final double fallbackIconSize;

  const ProductImage({
    super.key,
    this.imageUrl,
    this.width = 80,
    this.height = 80,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.fallbackIcon = Icons.inventory,
    this.fallbackIconSize = 40,
  });

  String? get _fullImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    
    if (imageUrl!.startsWith('http')) return imageUrl;
    
    const supabaseUrl = 'https://yelcwjxpzmknkzedgpwe.supabase.co';
    const bucketName = 'stockia_files';
    return '$supabaseUrl/storage/v1/object/public/$bucketName/$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.mainBlue, width: 1),
        color: backgroundColor ?? Colors.orange.shade300,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _fullImageUrl != null
            ? Image.network(
                _fullImageUrl!,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: backgroundColor ?? AppColors.mainBlue,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainWhite,
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: backgroundColor ?? AppColors.mainBlue,
                  child: Icon(
                    fallbackIcon,
                    color: AppColors.mainWhite,
                    size: fallbackIconSize,
                  ),
                ),
              )
            : Container(
                color: backgroundColor ?? AppColors.mainBlue,
                child: Icon(
                  fallbackIcon,
                  color: AppColors.mainWhite,
                  size: fallbackIconSize,
                ),
              ),
      ),
    );
  }
}