import 'package:flutter/material.dart';
import 'package:kademi_app/src/model/products/sku_param_opt.dart';
import 'package:kademi_app/src/themes/light_color.dart';

import 'title_text.dart';

typedef VariantCallback = void Function(String paramName, String optName);

class VariantSelect extends StatefulWidget {
  final String paramName;
  final String paramTitle;
  final List<SkuParamOpts> opts;

  final VariantCallback onVariantSelect;

  const VariantSelect({
    Key key,
    @required this.paramName,
    @required this.paramTitle,
    @required this.opts,
    @required this.onVariantSelect,
  }) : super(key: key);

  @override
  _VariantSelectState createState() => _VariantSelectState();
}

class _VariantSelectState extends State<VariantSelect> {
  String _selectedVariant;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widget.opts.forEach((o) {
      widgets.add(_variantOptWidget(
        o.optName,
        o.optTitle,
        isSelected: _selectedVariant != null && _selectedVariant == o.optName,
      ));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: widget.paramTitle,
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widgets,
        )
      ],
    );
  }

  Widget _variantOptWidget(String name, String text,
      {Color color = LightColor.iconColor, bool isSelected = false}) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedVariant = name;
          widget.onVariantSelect(widget.paramName, name);
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: !isSelected ? BorderStyle.solid : BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: isSelected
              ? LightColor.orange
              : Theme.of(context).backgroundColor,
        ),
        child: TitleText(
          text: text,
          fontSize: 16,
          color: isSelected ? LightColor.background : LightColor.titleTextColor,
        ),
      ),
    );
  }
}
