import 'package:flutter/material.dart';

import '../model/category.dart';
import '../widgets/category_select.dart';
import '../model/data.dart';
import '../model/product.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/product_card.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Category selectedCategory;

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

  Widget _productWidget() {
    return StreamBuilder(
      stream: AppData.productList.asStream(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData) {
          List<Product> products = snapshot.data;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: AppTheme.fullWidth(context),
            height: AppTheme.fullHeight(context) * .4,
            child: GridView.builder(
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
                      product: p,
                    );
                  }else{
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
          SizedBox(width: 20),
          _icon(Icons.filter_list, color: Colors.black54),
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
        _productWidget(),
      ],
    );
  }
}
