import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'category.dart';
import 'product.dart';

class AppData {
  static List<Product> _productList = [];
  static List<Category> _categoryList = [];

  static List<Product> cartList = [];

  static Future<List<Product>> get productList async {
    if (_productList.length == 0) {
      await _getJsonSource('assets/test_data/products.json').then((jsonString) {
        final json = jsonDecode(jsonString);
        print(json['data']['products']);
        json['data']['products'].forEach((v) {
          _productList.add(Product.fromJson(v));
        });
        _productList.sort((a, b) {
          return a.name.compareTo(b.name);
        });
      });
    }
    return _productList;
  }

  static List<Category> get categoryList {
    if (_categoryList.length == 0) {}
    return _categoryList;
  }

  static Future<String> _getJsonSource(String pathName) async {
    return await rootBundle.loadString(pathName);
  }
}
