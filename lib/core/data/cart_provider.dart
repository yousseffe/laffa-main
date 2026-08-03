import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  double _deliveryFee = 0;

  CartProvider() {
    _deliveryFee = (GetStorage().read('regionDeliveryFee') ?? 0).toDouble();
  }

  List<CartItem> get items => _items;

  // Called whenever the user picks/changes their region, so cart totals stay correct.
  void updateDeliveryFee(double deliveryFee) {
    _deliveryFee = deliveryFee;
    notifyListeners();
  }

  double priceForItem(CartItem item) => item.product.priceForDeliveryFee(_deliveryFee);

  double totalForItem(CartItem item) => priceForItem(item) * item.quantity;

  double get totalCartPrice {
    double total = 0;
    for (var item in _items) {
      total += totalForItem(item);
    }
    return total;
  }

  void addToCart(Product product) {
    // Check if already in cart
    int index = _items.indexWhere((item) => item.product.sId == product.sId);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.sId == product.sId);
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    int index = _items.indexWhere((item) => item.product.sId == product.sId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    int index = _items.indexWhere((item) => item.product.sId == product.sId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Lets the user type a specific quantity directly instead of tapping +/-.
  void setQuantity(Product product, int quantity) {
    int index = _items.indexWhere((item) => item.product.sId == product.sId);
    if (index < 0) return;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
