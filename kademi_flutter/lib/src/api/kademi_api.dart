import 'dart:async';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

import '../config/kademi_settings.dart';
import '../model/json_result/json_result.dart';
import '../model/profile/profile_data.dart';
import '../model/categories/category_list.dart';
import '../model/products/product_list.dart';

class KademiApi {
  static Future<JsonResult<ProfileData>> profileData() {
    String url = KademiSettings.BASE_URL + '/profile';

    return Requests.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).then((resp) {
      if (resp.hasError) {
        return null;
      } else {
        Map<String, dynamic> body = resp.json();

        return JsonResult<ProfileData>.fromJson(
            body, (dataBody) => ProfileData.fromJson(dataBody));
      }
    });
  }

  static Future<JsonResult<CategoryList>> categories() {
    String url = '${KademiSettings.BASE_URL}/_flutterApi';

    return Requests.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      queryParameters: {
        'categories': 'true',
        'storeName': KademiSettings.STORE_NAME
      },
    ).then((resp) {
      if (resp.hasError) {
        return null;
      } else {
        Map<String, dynamic> body = resp.json();

        return JsonResult<CategoryList>.fromJson(
            body, (json) => CategoryList.fromJson(json));
      }
    });
  }

  static Future<JsonResult<ProductList>> searchProducts(
      String q, String categoryName) {
    String url = '${KademiSettings.BASE_URL}/_flutterApi';

    return Requests.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      queryParameters: {
        'products': 'true',
        'storeName': KademiSettings.STORE_NAME,
        'q': q,
        'categoryName': categoryName
      },
    ).then((resp) {
      if (resp.hasError) {
        return null;
      } else {
        Map<String, dynamic> body = resp.json();

        return JsonResult<ProductList>.fromJson(body, (json) {
          return ProductList.fromJson(json);
        });
      }
    }).catchError((e) {
      debugPrint('Error getting products $e');
    });
  }

  static Future<JsonResult> addToCart() {}

  static Future<JsonResult> cart() {}
}
