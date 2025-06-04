import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
// import '../providers/favorite_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/fav_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: favoriteProvider.favorites.isEmpty
          ? const Center(
        child: Text(
          'No favorites yet',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: favoriteProvider.favorites.length,
        itemBuilder: (context, index) {
          final product = favoriteProvider.favorites[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            favoriteProvider.toggleFavorite(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.title} removed from favorites!')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(
                          3,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == 0
                                  ? Colors.black
                                  : index == 1
                                  ? Colors.blue
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: () {
                          cartProvider.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.title} added to cart!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size(double.infinity, 36),
                        ),
                        child: const Text('Add to Cart'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}