import 'product_sku.dart';

class LineItem {
  String itemId;
  int quantity;
  double unitCost;
  double taxRate;
  double tax;
  double finalCost;
  String itemDescription;
  ProductSku productSku;

  LineItem({
    this.itemId,
    this.quantity,
    this.unitCost,
    this.taxRate,
    this.tax,
    this.finalCost,
    this.itemDescription,
    this.productSku,
  });

  LineItem.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    quantity = json['quantity'];
    unitCost = json['unitCost'].toDouble();
    taxRate = json['taxRate'].toDouble();
    tax = json['tax'].toDouble();
    finalCost = json['finalCost'].toDouble();
    itemDescription = json['itemDescription'];
    productSku = json['productSku'] != null
        ? new ProductSku.fromJson(json['productSku'])
        : null;
  }
}
