import 'product.dart';

import '../json_result/data_interface.dart';

class ProductList extends DataInterface {
  List<Product> products;

  ProductList.fromJson(List<dynamic> json) {
    products = new List();

    json.forEach((v) {
      products.add(Product.fromJson(v));
    });
  }
}
