import 'package:flutter/material.dart';

import '../api/kademi_api.dart';
import '../model/json_result/json_result.dart';
import '../model/products/product_list.dart';
import '../widgets/category_select.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/product_card.dart';
import '../model/products/product.dart';
import '../model/categories/category.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchQuery = new TextEditingController();
  Category selectedCategory;
  String productQuery;

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _productWidget(String q, String categoryName) {
    return StreamBuilder(
      stream: KademiApi.searchProducts(q, categoryName).asStream(),
      builder: (BuildContext context,
          AsyncSnapshot<JsonResult<ProductList>> snapshot) {
        if (snapshot.hasData && snapshot.data.status) {
          List<Product> products = snapshot.data.data.products;
          return Container(
            key: UniqueKey(),
            margin: EdgeInsets.symmetric(vertical: 10),
            width: AppTheme.fullWidth(context),
            height: AppTheme.fullHeight(context) * .4,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 4 / 6,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              itemBuilder: (BuildContext context, int index) {
                Product p = products[index];
                if (this.selectedCategory != null) {
                  if (p.categoryIds != null &&
                      p.categoryIds.contains(this.selectedCategory.id)) {
                    return ProductCard(
                      key: Key('${p.product}'),
                      product: p,
                    );
                  } else {
                    return SizedBox();
                  }
                } else {
                  return ProductCard(
                    product: p,
                  );
                }
              },
              itemCount: products.length,
            ),
          );
        } else {
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                controller: _searchQuery,
                onSubmitted: (s) {
                  if (this.productQuery != _searchQuery.text) {
                    setState(() {
                      this.productQuery = _searchQuery.text;
                    });
                  }
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
          // SizedBox(width: 20),
          // _icon(Icons.filter_list, color: Colors.black54),
        ],
      ),
    );
  }

  void categoryChanged(Category category) {
    setState(() {
      this.selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _search(),
        CategorySelect(
          onSelectedCategoryChanged: categoryChanged,
        ),
        _productWidget(productQuery,
            (selectedCategory != null ? selectedCategory.name : null)),
      ],
    );
  }
}
