


import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get cartCount => _cartItems.length;

  double get totalPrice {
    return _cartItems.fold(
      0.0,
          (total, item) => total + (item.product.price * item.quantity),
    );
  }

  void addToCart(Product product) {
    final existingItemIndex = _cartItems.indexWhere(
          (item) => item.product.id == product.id,
    );
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void incrementQuantity(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      notifyListeners();
    }
  }

  void removeFromCart(CartItem cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }
}