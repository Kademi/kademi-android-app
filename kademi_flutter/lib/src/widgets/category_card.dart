import 'package:flutter/material.dart';

import '../config/kademi_settings.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/title_text.dart';
import '../model/categories/category.dart';

typedef CategoryCallback = void Function(Category category);

class CategoryCard extends StatefulWidget {
  final Category category;
  final CategoryCallback callback;

  const CategoryCard({Key key, this.category, this.callback}) : super(key: key);

  @override
  CategoryState createState() => CategoryState(category, callback);
}

class CategoryState extends State<CategoryCard> {
  final Category category;
  final CategoryCallback callback;

  CategoryState(this.category, this.callback);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return category.id == null
        ? Container(
            width: 5,
          )
        : InkWell(
            onTap: () {
              //Navigator.of(context).pushNamed('/detail', arguments: model);
              setState(() {
                this.category.isSelected = !this.category.isSelected;
                this.callback(this.category);
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              padding: AppTheme.hPadding,
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: this.category.isSelected
                    ? LightColor.background
                    : Colors.transparent,
                border: Border.all(
                    color: this.category.isSelected
                        ? LightColor.orange
                        : LightColor.grey,
                    width: this.category.isSelected ? 2 : 1),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: this.category.isSelected
                          ? Color(0xfffbf2ef)
                          : Colors.white,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(5, 5)),
                ],
              ),
              child: Row(
                children: <Widget>[
                  (category.mainImageHash != null
                      ? Image.network(
                          KademiSettings.BASE_URL + category.mainImageHash,
                          loadingBuilder: (context, w, oci) {
                            if (oci == null) {
                              return w;
                            }
                            return CircularProgressIndicator();
                          },
                          errorBuilder: (conext, o, st) =>
                              Image.asset('assets/photo_holder.png'),
                        )
                      : Image.asset('assets/photo_holder.png')),
                  category.name == null
                      ? Container()
                      : Container(
                          child: TitleText(
                            text: category.title ?? category.name,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        )
                ],
              ),
            ),
          );
  }
}
