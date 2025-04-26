import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final String baseUrl = 'http://192.168.1.2:3000/api/products';
  List<Product> _products = [];

  List<Product> get products => [..._products];

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List;
        _products = extractedData.map((prod) => Product.fromJson(prod)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final productData = product.toJson();
      productData.remove('id');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productData),
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newProduct = Product.fromJson(responseData);
        _products.add(newProduct);
        notifyListeners();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to add product');
      }
    } catch (error) {
      debugPrint('Add Product Error: $error');
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _products.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/$id'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newProduct.toJson()),
        );

        if (response.statusCode == 200) {
          _products[index] = newProduct;
          notifyListeners();
        } else {
          throw Exception('Failed to update product');
        }
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        _products.removeWhere((prod) => prod.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      rethrow;
    }
  }
}