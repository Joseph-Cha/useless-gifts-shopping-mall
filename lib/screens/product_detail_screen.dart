import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useless_gifts_shopping_mall/models/product.dart';
import 'package:useless_gifts_shopping_mall/providers/cart_provider.dart';
import 'package:useless_gifts_shopping_mall/providers/product_provider.dart';
import 'package:useless_gifts_shopping_mall/widgets/product_grid_item.dart';
import 'package:useless_gifts_shopping_mall/widgets/product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addItem(widget.product, _quantity);

    // 스낵바로 알림
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} $_quantity개가 장바구니에 추가되었습니다!'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(label: '확인', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final relatedProducts = productProvider.getRelatedProducts(
      widget.product.id,
      widget.product.category,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('상품 상세')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상품 이미지
            ProductImage(
              product: widget.product,
              width: double.infinity,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.product.category,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 상품명
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 가격
                  Text(
                    widget.product.formattedPrice,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // 상품 설명
                  const Text(
                    '상품 설명',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 수량 선택
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '수량',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _decrementQuantity,
                            icon: const Icon(Icons.remove_circle_outline),
                            iconSize: 32,
                            color: Colors.blue,
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _incrementQuantity,
                            icon: const Icon(Icons.add_circle_outline),
                            iconSize: 32,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 장바구니 담기 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _addToCart(context),
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text(
                        '장바구니에 담기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  // 관련 상품
                  if (relatedProducts.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Text(
                      '관련 상품',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
                        itemBuilder: (ctx, i) => SizedBox(
                          width: 180,
                          child: ProductGridItem(product: relatedProducts[i]),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
