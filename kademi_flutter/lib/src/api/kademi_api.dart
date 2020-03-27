import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kademi_app/src/model/cart/cart_data.dart';
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
    });
  }

  static Future<JsonResult<CartData>> cart() {
    String url =
        '${KademiSettings.BASE_URL}/_flutterApi';
    return Requests.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      queryParameters: {
        'cart': 'true',
        'storeName': KademiSettings.STORE_NAME,
        'pointsBucket': KademiSettings.POINTS_BUCKET,
      },
    ).then((resp) {
      debugPrint('cart() - ${resp.hasError} - ${resp.statusCode}');
      if (resp.hasError) {
        return null;
      } else {
        Map<String, dynamic> body = resp.json();

        return JsonResult<CartData>.fromJson(body, (json) {
          return CartData.fromJson(json);
        });
      }
    });
  }

  static Future<JsonResult> addToCart(String skuId) {
    String url = '${KademiSettings.BASE_URL}/${KademiSettings.STORE_NAME}/cart';
    return Requests.post(
      url,
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
      body: {
        'quantity': '1',
        'skuId': skuId,
      },
    ).then((resp) {
      if (resp.hasError) {
        return null;
      } else {
        Map<String, dynamic> body = resp.json();

        return JsonResult.fromJson(body, null);
      }
    });
  }

  static Future<JsonResult> updateCartItemQuantity(
      String skuId, String newQuantity) {
    String url = '${KademiSettings.BASE_URL}/${KademiSettings.STORE_NAME}/cart';
    return Requests.post(
      url,
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
      body: {
        'newQuantity': newQuantity,
        'skuId': skuId,
      },
    ).then((resp) {
      if (resp.hasError) {
        return null;
      } else {
        Map<String, dynamic> body = resp.json();

        return JsonResult.fromJson(body, null);
      }
    });
  }

  static Future<JsonResult> removeCartItem(String lineId) {
    String url = '${KademiSettings.BASE_URL}/${KademiSettings.STORE_NAME}/cart';
    return Requests.post(
      url,
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
      body: {
        "removeLineId": lineId,
      },
    ).then((resp) {
      if (resp.hasError) {
        return null;
      } else {
        Map<String, dynamic> body = resp.json();

        return JsonResult.fromJson(body, null);
      }
    });
  }

  static Future<JsonResult> clearCart() {
    String url = '${KademiSettings.BASE_URL}/${KademiSettings.STORE_NAME}/cart';
    return Requests.post(
      url,
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
      body: {
        "clearCartItems": "true",
      },
    ).then((resp) {
      if (resp.hasError) {
        return null;
      } else {
        Map<String, dynamic> body = resp.json();

        debugPrint('clearCart - $body');

        return JsonResult.fromJson(body, null);
      }
    });
  }
}
