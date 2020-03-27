import 'line_item.dart';

class Cart {
  int numItems;
  int cartId;
  double totalCost;
  List<LineItem> lineItems;

  Cart({this.numItems, this.cartId, this.totalCost, this.lineItems});

  Cart.fromJson(Map<String, dynamic> json) {
    numItems = json['numItems'];
    cartId = json['cartId'];
    totalCost = json['totalCost'].toDouble();
    if (json['lineItems'] != null) {
      lineItems = new List<LineItem>();
      json['lineItems'].forEach((v) {
        lineItems.add(new LineItem.fromJson(v));
      });
    }
  }
}
