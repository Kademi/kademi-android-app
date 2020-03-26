import 'package:flutter/material.dart';
import 'package:kademi_app/src/api/kademi_api.dart';
import '../widgets/category_card.dart';
import '../themes/theme.dart';
import '../model/categories/category.dart';

class CategorySelect extends StatefulWidget {
  final CategoryCallback onSelectedCategoryChanged;

  const CategorySelect({Key key, this.onSelectedCategoryChanged})
      : super(key: key);

  @override
  _CategorySelectState createState() =>
      _CategorySelectState(onSelectedCategoryChanged);
}

class _CategorySelectState extends State<CategorySelect> {
  final CategoryCallback onSelectedCategoryChanged;

  List<Category> categories;

  _CategorySelectState(this.onSelectedCategoryChanged);

  void _selectCategory(Category category) {
    if (categories != null) {
      setState(() {
        categories.forEach((cat) {
          if (cat.id != category.id) {
            cat.isSelected = false;
          }
        });
      });
      if (onSelectedCategoryChanged != null) {
        onSelectedCategoryChanged(category.isSelected ? category : null);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // AppData.categoryList.then((value) {
    //   setState(() {
    //     categories = value;
    //   });
    // });

    KademiApi.categories().then((jr) {
      if (jr != null && jr.status) {
        setState(() {
          categories = jr.data.categories;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categories == null) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: AppTheme.fullWidth(context),
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return CategoryCard(
              category: categories[index],
              callback: _selectCategory,
            );
          },
        ),
      );
    }
  }
}
