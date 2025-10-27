import 'package:flutter/foundation.dart';
import 'package:useless_gifts_shopping_mall/models/cart_item.dart';
import 'package:useless_gifts_shopping_mall/models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  // 전체 상품 개수 (수량 포함)
  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // 전체 금액
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // 장바구니에 상품 추가
  void addItem(Product product, int quantity) {
    // 이미 장바구니에 있는 상품인지 확인
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // 이미 있으면 수량만 증가
      _items[existingIndex].quantity += quantity;
    } else {
      // 없으면 새로 추가
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  // 특정 상품의 수량 변경
  void updateQuantity(String productId, int newQuantity) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  // 장바구니에서 상품 제거
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // 장바구니 전체 비우기
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
