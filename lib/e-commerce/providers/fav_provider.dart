import 'package:flutter/material.dart';
import '../models/product_model.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
}