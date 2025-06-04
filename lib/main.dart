import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'e-commerce/providers/cart_provider.dart';
import 'e-commerce/providers/fav_provider.dart';
import 'e-commerce/view/Splash_Screen.dart';
import 'e-commerce/view/cart_sceen.dart';
import 'e-commerce/view/fav_screen.dart';
import 'e-commerce/view/home_screen.dart';
import 'e-commerce/view/login_screen.dart';
import 'e-commerce/view/product_details.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(), // Placeholder
          '/favorites': (context) => const FavoritesScreen(), // Placeholder
          '/product-details': (context) => const ProductDetailsScreen(), // Placeholder
        },
      ),
    );
  }
}
