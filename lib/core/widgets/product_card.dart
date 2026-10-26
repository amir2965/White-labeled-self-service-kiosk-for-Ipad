import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final bool isAvailable;
  final VoidCallback onTap;
  final ProductCardStyle style;

  const ProductCard({
    super.key,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.isAvailable = true,
    required this.onTap,
    this.style = ProductCardStyle.imageHeavy,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: style == ProductCardStyle.compact
            ? _buildCompactCard()
            : _buildImageHeavyCard(),
      ),
    );
  }

  Widget _buildImageHeavyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusLg),
              topRight: Radius.circular(AppSpacing.radiusLg),
            ),
            child: _buildImage(),
          ),
        ),

        // Content
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.h4,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (description != null && description!.isNotEmpty) ...[
                SizedBox(height: AppSpacing.xs),
                Text(
                  description!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: AppSpacing.sm),
              Text('\$${price.toStringAsFixed(2)}', style: AppTypography.price),
              if (!isAvailable)
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    'Unavailable',
                    style: AppTypography.label.copyWith(color: AppColors.error),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactCard() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Thumbnail
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: SizedBox(width: 80, height: 80, child: _buildImage()),
            ),
          SizedBox(width: AppSpacing.md),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: AppTypography.h4,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null && description!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // Price
          Text('\$${price.toStringAsFixed(2)}', style: AppTypography.price),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        color: AppColors.gray100,
        child: Icon(Icons.restaurant, size: 48, color: AppColors.gray400),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.gray100,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.gray400,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.gray100,
        child: Icon(Icons.restaurant, size: 48, color: AppColors.gray400),
      ),
    );
  }
}

enum ProductCardStyle { compact, imageHeavy }
