


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controller/product_controller.dart';
import '../models/product_model.dart';

import '../providers/fav_provider.dart';
import 'bottam_nav_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController _controller = ProductController();
  late Future<List<Product>> _futureProducts;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _currentBannerIndex = 0;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _futureProducts = _controller.getProducts().then((products) {
      _allProducts = products;
      _filteredProducts = products;
      return products;
    });
  }

  void _searchProduct(String query) {
    setState(() {
      _filteredProducts = _controller.filterProducts(_allProducts, query);
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    if (index == 2) {
      Navigator.pushNamed(context, '/favorites');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/cart');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  _buildBanner(),
                  _buildCategories(),
                  _buildProductGrid(context),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      title: GestureDetector(
        onTap: () {
          setState(() {
            _isSearching = true;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Search...',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.grey),
          onPressed: () {
            // Handle notification action
          },
        ),
      ],
      bottom: _isSearching
          ? PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            onChanged: _searchProduct,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _filteredProducts = _allProducts;
                  });
                },
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }

  SliverToBoxAdapter _buildBanner() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                _filteredProducts.isNotEmpty
                    ? CarouselSlider(
                  options: CarouselOptions(
                    height: 150,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                  ),
                  items: _filteredProducts.map((product) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text(
                                'Image not available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                )
                    : Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'No products available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Super Sale',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const Text(
                        'Discount Up to 50%',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Shop Now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _filteredProducts.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => setState(() => _currentBannerIndex = entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentBannerIndex == entry.key ? Colors.black : Colors.grey[300],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildCategories() {
    final List<Map<String, String>> categories = [];
    final Set<String> seenCategories = {};

    for (var product in _filteredProducts) {
      if (!seenCategories.contains(product.category)) {
        seenCategories.add(product.category);
        categories.add({
          'name': product.category,
          'image': product.image,
        });
      }
    }

    return SliverToBoxAdapter(
      child: categories.isNotEmpty
          ? Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(categories[index]['image']!),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                    child: categories[index]['image'] == null
                        ? const Icon(Icons.broken_image, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categories[index]['name']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      )
          : Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: const Center(
          child: Text(
            'No categories available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  SliverPadding _buildProductGrid(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Special for You',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See all',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final productBake = _filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-details',
                      arguments: productBake,
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  productBake.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(
                                    favoriteProvider.isFavorite(productBake)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    favoriteProvider.toggleFavorite(productBake);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            productBake.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                '\$${productBake.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
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
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}