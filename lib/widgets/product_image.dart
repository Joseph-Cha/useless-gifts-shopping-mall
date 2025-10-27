import 'dart:io';
import 'package:flutter/material.dart';
import 'package:useless_gifts_shopping_mall/models/product.dart';

/// 상품 이미지를 표시하는 위젯
/// 네트워크 URL과 로컬 파일 경로를 모두 지원합니다
class ProductImage extends StatelessWidget {
  final Product product;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.product,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (product.isAssetImage) {
      // Asset 이미지
      imageWidget = Image.asset(
        product.imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
      );
    } else if (product.isLocalImage) {
      // 로컬 파일 이미지
      imageWidget = Image.file(
        File(product.imageUrl),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
      );
    } else {
      // 네트워크 이미지
      imageWidget = Image.network(
        product.imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.image,
          size: (width ?? 100) * 0.4,
          color: Colors.grey,
        ),
      ),
    );
  }
}
