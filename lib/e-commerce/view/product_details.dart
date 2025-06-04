


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> with SingleTickerProviderStateMixin {
  int _quantity = 1;
  String _selectedColor = 'Red';
  final List<String> _colors = ['Red', 'Black', 'Blue', 'Brown', 'Gray'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1.0,
                autoPlay: false,
                enableInfiniteScroll: false,
              ),
              items: [product.image].map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(
                      image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // Dots Indicator for Carousel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0 ? Colors.black : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Price and Seller
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, color: Colors.orange),
                      ),
                      Text(
                        'Seller: Tariqul Islam',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '4.8 (320 Reviews)',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Color Selection
                  const Text(
                    'Color',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _colors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color == 'Red'
                                ? Colors.red.shade900
                                : color == 'Black'
                                ? Colors.black
                                : color == 'Blue'
                                ? Colors.blue.shade900
                                : color == 'Brown'
                                ? Colors.brown
                                : Colors.grey.shade300,
                            border: Border.all(
                              color: _selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Tabs for Description, Specifications, Reviews
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.orange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    tabs: const [
                      Tab(text: 'Description'),
                      Tab(text: 'Specifications'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Description Tab
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                        // Specifications Tab
                        const Text(
                          'Specifications content goes here.',
                          style: TextStyle(fontSize: 14, height: 1.5),
                        ),
                        // Reviews Tab
                        const Text(
                          'Reviews content goes here.',
                          style: TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Quantity Selector and Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_quantity > 1) {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove_circle, color: Colors.grey),
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _quantity++;
                              });
                            },
                            icon: const Icon(Icons.add_circle, color: Colors.grey),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cartProvider.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.title} added to cart!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size(200, 50),
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}