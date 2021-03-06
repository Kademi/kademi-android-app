import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kademi_app/src/api/kademi_api.dart';
import 'package:kademi_app/src/model/products/sku.dart';
import 'package:kademi_app/src/widgets/variant_select.dart';

import '../config/kademi_settings.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/title_text.dart';
import '../model/products/product.dart';
import '../model/products/sku_param_opt.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({
    Key key,
    @required this.product,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState(product);
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  final Product product;

  Map<String, String> _selectedVariants = new HashMap();
  int _variantCount = 0;

  AnimationController controller;
  Animation<double> animation;

  _ProductDetailPageState(this.product);
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isLiked = true;
  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: _icon(Icons.arrow_back_ios,
                color: Colors.black54, size: 15, padding: 12, isOutLine: true),
          ),
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       isLiked = !isLiked;
          //     });
          //   },
          //   child: _icon(isLiked ? Icons.favorite : Icons.favorite_border,
          //       color: isLiked ? LightColor.red : LightColor.lightGrey,
          //       size: 15,
          //       padding: 12,
          //       isOutLine: false),
          // )
        ],
      ),
    );
  }

  Widget _icon(IconData icon,
      {Color color = LightColor.iconColor,
      double size = 20,
      double padding = 10,
      bool isOutLine = false}) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    );
  }

  Widget _productImages(Product product) {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CarouselSlider.builder(
            itemCount: product.images.length,
            itemBuilder: (BuildContext context, int itemIndex) {
              if (product.images.length == 0) {
                return Image.asset('assets/photo_holder.png');
              }
              return Container(
                child: Image.network(
                  '${KademiSettings.BASE_URL}${product.images[itemIndex].href}',
                  loadingBuilder: (context, w, oci) {
                    if (oci == null) {
                      return w;
                    }
                    return CircularProgressIndicator();
                  },
                  errorBuilder: (conext, o, st) {
                    return Image.asset('assets/photo_holder.png');
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _detailWidget(Product product) {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(text: product.title, fontSize: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TitleText(
                                text: product.finalCost.toString(),
                                fontSize: 25,
                              ),
                              TitleText(
                                text: " Pts",
                                fontSize: 18,
                                color: LightColor.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _availableVariants(product),
                _description(product),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _availableVariants(Product product) {
    _variantCount = 0;
    if (product.skus != null && product.skus.length > 0) {
      Map<String, String> skuParams = new Map();
      Map<String, List<SkuParamOpts>> variants = new Map();
      product.skus.forEach((sku) {
        sku.params.forEach((param) {
          skuParams[param.paramName] = param.paramTitle;
          if (variants.containsKey(param.paramName)) {
            variants[param.paramName].addAll(param.opts);
          } else {
            var l = new List<SkuParamOpts>();
            l.addAll(param.opts);
            variants[param.paramName] = l;
          }
        });
      });

      List<Widget> widgets = [];

      skuParams.forEach((key, value) {
        var opts = variants[key];

        if (opts.length > 0) {
          _variantCount++;
          widgets.add(SizedBox(
            height: 20,
          ));

          widgets.add(VariantSelect(
            key: Key('$key-$value'),
            paramName: key,
            paramTitle: value,
            opts: opts,
            onVariantSelect: _onVariantSelect,
          ));
          //widgets.add(_variant(key, value, opts));
        }
      });

      if (widgets.length > 0) {
        return Stack(children: widgets);
      }
    }
    return SizedBox.shrink();
  }

  Widget _description(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // TitleText(
        //   text: product.title,
        //   fontSize: 14,
        // ),
        SizedBox(height: 20),
        Text(product.content),
      ],
    );
  }

  FloatingActionButton _floatingButton(Product product) {
    return FloatingActionButton(
      onPressed: () {
        if (_variantCount == _selectedVariants.length) {
          Sku sku = _findSku();
          if (sku != null) {
            debugPrint('Found SKU - ${sku.skuId}');
            KademiApi.addToCart('${sku.skuId}').then((value) {
              // Do Something
            });
          } else {
            debugPrint('Found NOT FOUND - $_selectedVariants');
          }
        }
      },
      backgroundColor: LightColor.orange,
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  void _onVariantSelect(String paramName, String optName) {
    setState(() {
      if (optName == null || optName.length < 1) {
        _selectedVariants.remove(paramName);
      } else {
        _selectedVariants[paramName] = optName;
      }
    });
  }

  Sku _findSku() {
    for (var sku in product.skus) {
      if (sku.matchesParam(_selectedVariants)) {
        return sku;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingButton(product),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xfffbfbfb),
                Color(0xfff7f7f7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _productImages(product),
                  //_categoryWidget(),
                ],
              ),
              _detailWidget(product)
            ],
          ),
        ),
      ),
    );
  }
}
