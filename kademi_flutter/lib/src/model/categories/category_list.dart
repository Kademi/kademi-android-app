import 'package:kademi_app/src/model/categories/category.dart';
import 'package:kademi_app/src/model/json_result/data_interface.dart';

class CategoryList extends DataInterface {
  List<Category> categories;

  CategoryList.fromJson(List<dynamic> json) {
    categories = new List();
    json.forEach((v) {
      categories.add(Category.fromJson(v));
    });
  }
}
