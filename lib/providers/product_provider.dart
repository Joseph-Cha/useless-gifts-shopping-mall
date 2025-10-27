import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:useless_gifts_shopping_mall/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => [..._products];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // JSON 파일에서 상품 데이터 로드
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // JSON 파일 읽기
      final String jsonString =
          await rootBundle.loadString('data/products/products.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // products 배열 파싱
      final List<dynamic> productList = jsonData['products'];
      _products = productList
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final json = entry.value as Map<String, dynamic>;
            // id가 없으면 인덱스 기반으로 생성
            json['id'] = (index + 1).toString();
            return Product.fromJson(json);
          })
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = '상품 데이터를 불러오는데 실패했습니다: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // 카테고리별 필터
  List<Product> getProductsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  // 검색
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [..._products];
    return _products.where((p) {
      return p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // 특정 상품 가져오기
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // 상품 추가 (등록 기능)
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  // 관련 상품 가져오기 (같은 카테고리의 다른 상품들)
  List<Product> getRelatedProducts(String productId, String category) {
    return _products
        .where((p) => p.category == category && p.id != productId)
        .take(4)
        .toList();
  }
}
