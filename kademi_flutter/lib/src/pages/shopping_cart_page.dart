import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kademi_app/src/api/kademi_api.dart';
import 'package:kademi_app/src/config/kademi_settings.dart';
import 'package:kademi_app/src/model/cart/cart_data.dart';
import 'package:kademi_app/src/model/cart/line_item.dart';
import 'package:kademi_app/src/widgets/loading.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/title_text.dart';

class ShopingCartPage extends StatefulWidget {
  const ShopingCartPage({Key key}) : super(key: key);

  @override
  _ShopingCartPageState createState() => _ShopingCartPageState();
}

class _ShopingCartPageState extends State<ShopingCartPage> {
  CartData _cartData;
  bool _isLoadingVisible = true;

  @override
  void initState() {
    super.initState();
    _refreshCart();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      inAsyncCall: _isLoadingVisible,
      child: Container(
        padding: AppTheme.padding,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                key: UniqueKey(),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    child: Text('Available Points: ${_getAvailablePoints()}'),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: InkWell(
                      child: Icon(
                        Icons.delete_outline,
                        color: LightColor.orange,
                      ),
                      onTap: () {
                        setState(() {
                          _isLoadingVisible = true;
                        });
                        KademiApi.clearCart().then((value) {
                          Fluttertoast.showToast(
                              msg: 'Shopping cart has been cleared',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: LightColor.orange,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          _refreshCart();
                        });
                      },
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              _cartItems(),
              Divider(
                thickness: 1,
                height: 70,
              ),
              _price(),
              SizedBox(height: 30),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lineItemImage(LineItem li) {
    if (li.productSku != null) {
      if (li.productSku.imageHash != null &&
          li.productSku.imageHash.length > 1) {
        return Image.network(
          '${KademiSettings.BASE_URL}/_hashes/files/${li.productSku.imageHash}',
          fit: BoxFit.contain,
          loadingBuilder: (context, w, oci) {
            if (oci == null) {
              return w;
            }
            return CircularProgressIndicator();
          },
          errorBuilder: (conext, o, st) {
            return Image.asset('assets/photo_holder.png');
          },
        );
      }
    }

    return Image.asset('assets/photo_holder.png');
  }

  Widget _item(LineItem li) {
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: _lineItemImage(li),
                )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: li.itemDescription,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      TitleText(
                        text: li.finalCost.toString(),
                        fontSize: 14,
                      ),
                      TitleText(
                        text: ' Pts',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: TitleText(
                      text: 'x ${li.quantity ?? 1}',
                      fontSize: 12,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _price() {
    double price = 0.0;
    int items = 0;
    if (_cartData != null && _cartData.cart != null) {
      price = _cartData.cart.totalCost ?? 0.0;
      items = _cartData.cart.numItems ?? 0;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: '$items Items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: '$price Pts',
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return FlatButton(
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: LightColor.orange,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12),
        width: AppTheme.fullWidth(context) * .7,
        child: TitleText(
          text: 'Next',
          color: LightColor.background,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _cartItems() {
    List<Widget> _children = [];
    if (_cartData != null && _cartData.cart != null) {
      _children = _cartData.cart.lineItems.map((e) => _item(e)).toList();
    }
    return Column(children: _children);
  }

  String _getAvailablePoints() {
    double points = 0.0;
    if (_cartData != null && _cartData.pointsBalance != null) {
      points = _cartData.pointsBalance ?? 0.0;
    }

    return points.toString();
  }

  void _refreshCart() async {
    setState(() {
      _isLoadingVisible = true;
    });
    KademiApi.cart().then((jr) {
      setState(() {
        if (jr != null && jr.status) {
          _cartData = jr.data;
        } else {
          _cartData = null;
        }
        _isLoadingVisible = false;
      });
    });
  }
}
