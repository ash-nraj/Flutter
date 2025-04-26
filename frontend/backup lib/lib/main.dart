import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/product_provider.dart';
import './screens/home_screen.dart';
import './screens/add_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/product_detail_screen.dart';

void main() {
  runApp(ProductApp());
}

class ProductApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        title: 'Product App',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.deepPurple,
          colorScheme: ColorScheme.dark(
            primary: Colors.deepPurple,
            secondary: Colors.purpleAccent,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        routes: {
          AddProductScreen.routeName: (_) => AddProductScreen(),
          EditProductScreen.routeName: (_) => EditProductScreen(),
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
        },
      ),
    );
  }
}
