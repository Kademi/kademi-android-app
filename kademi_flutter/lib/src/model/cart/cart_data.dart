import 'package:kademi_app/src/model/json_result/data_interface.dart';

import 'cart.dart';

class CartData extends DataInterface{
  Cart cart;
  double pointsBalance;
  String pointsBucketOptionId;

  CartData({this.cart, this.pointsBalance});

  CartData.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
    pointsBalance = json['pointsBalance'].toDouble();
    pointsBucketOptionId = json['pointsBucketOptionId'];
  }
}