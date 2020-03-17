import 'package:flutter/material.dart';
import '../config/kademi_settings.dart';
import '../model/data.dart';
import '../model/product.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/title_text.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  ProductCard({Key key, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Product model;
  @override
  void initState() {
    model = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/detail', arguments: model);
        setState(() {
          // model.isSelected = !model.isSelected;
          // AppData.productList.forEach((x) {
          //   if (x.id == model.id && x.name == model.name) {
          //     return;
          //   }
          //   x.isSelected = false;
          // });
          // var m = AppData.productList
          //     .firstWhere((x) => x.id == model.id && x.name == model.name);
          // m.isSelected = !m.isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: LightColor.background,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
          ],
        ),
        margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 0),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: LightColor.orange.withAlpha(40),
                    ),
                    (model.primaryImageHref != null
                        ? Image.network(
                            KademiSettings.BASE_URL + model.primaryImageHref,
                            loadingBuilder: (context, w, oci) {
                              if (oci == null) {
                                return w;
                              }
                              return CircularProgressIndicator();
                            },
                            errorBuilder: (conext, o, st) =>
                                Image.asset('assets/photo_holder.png'),
                          )
                        : Image.asset('assets/photo_holder.png'))
                  ],
                ),
                // SizedBox(height: 5),
                TitleText(
                  text: model.title,
                  fontSize: 14,
                ),
                TitleText(
                  text: '${model.finalCost.toString()} Pts',
                  fontSize: 13,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
