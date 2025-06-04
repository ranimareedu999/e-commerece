import '../api_repo/api_service.dart';
import '../models/product_model.dart';

class ProductController {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getProducts() async {
    return await _apiService.fetchProducts();
  }

  List<Product> filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;
    return products
        .where((product) =>
        product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}