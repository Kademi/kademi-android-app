import 'package:flutter/material.dart';
import 'package:kademi_app/src/api/kademi_api.dart';
import 'package:kademi_app/src/model/cart/cart_data.dart';
import 'package:kademi_app/src/themes/light_color.dart';
import 'package:kademi_app/src/themes/theme.dart';
import 'package:kademi_app/src/util/validator.dart';
import 'package:kademi_app/src/widgets/loading.dart';
import 'package:kademi_app/src/widgets/title_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutPage extends StatefulWidget {
  final CartData cartData;

  const CheckoutPage({Key key, this.cartData}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = new GlobalKey<FormState>();
  bool _isLoadingVisible = false;
  bool _autoValidate = false;

  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _surNameController = new TextEditingController();
  TextEditingController _address1Controller = new TextEditingController();
  TextEditingController _address2Controller = new TextEditingController();
  TextEditingController _addressStateController = new TextEditingController();
  TextEditingController _addressPostcodeController =
      new TextEditingController();
  TextEditingController _addressCityController = new TextEditingController();
  TextEditingController _orderNotesController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingScreen(
        inAsyncCall: _isLoadingVisible,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
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
                        TitleText(
                          text: 'Checkout',
                          fontSize: 27,
                          fontWeight: FontWeight.w400,
                        ),
                        _checkoutForm(),
                        //_productImages(product),
                        //_categoryWidget(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkoutForm() {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //_logo(),
              SizedBox(height: 12.0),
              _textInput('First Name', _firstNameController, true),
              SizedBox(height: 12.0),
              _textInput('Surname', _surNameController, true),
              SizedBox(height: 12.0),
              _textInput('Address line 1', _address1Controller, true),
              SizedBox(height: 12.0),
              _textInput('Address line 2', _address2Controller, false),
              SizedBox(height: 12.0),
              _textInput('State', _addressStateController, true),
              SizedBox(height: 12.0),
              _textInput('Postcode', _addressPostcodeController, true),
              SizedBox(height: 12.0),
              _textInput('City', _addressCityController, true),
              SizedBox(height: 12.0),
              _textInput('Order Notes', _orderNotesController, false),
              SizedBox(height: 12.0),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInput(
      String hint, TextEditingController inputController, bool req) {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.text,
        cursorColor: LightColor.orange,
        autofocus: false,
        controller: inputController,
        validator: req ? Validator.validateRequired : null,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          focusColor: LightColor.orange,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: LightColor.orange,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return FlatButton(
      onPressed: () {
        _doCheckout();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: LightColor.orange,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12),
        width: AppTheme.fullWidth(context) * .7,
        child: TitleText(
          text: 'Submit my order',
          color: LightColor.background,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

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

  void _doCheckout() async {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoadingVisible = true);

      Map<String, dynamic> params = {
        'pointsCheckoutCartId': widget.cartData.cart.cartId,
        'pointsBucketOptionId': widget.cartData.pointsBucketOptionId,
        'source': 'app',
        'firstName': _firstNameController.text,
        'surName': _surNameController.text,
        'addressLine1': _address1Controller.text,
        'addressLine2': _address2Controller.text,
        'addressState': _addressStateController.text,
        'city': _addressCityController.text,
        'postcode': _addressPostcodeController.text,
        'notes': _orderNotesController.text,
      };

      KademiApi.checkoutCart(params).then((resp) {
        if (resp != null) {
          if (resp.status) {
            setState(() => _isLoadingVisible = false);
            Navigator.of(context).pop(true);
          } else {
            debugPrint('Checkout failed: ${resp.messages}');
            Fluttertoast.showToast(
                msg: resp.messages.join(' '),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: LightColor.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          debugPrint('Unknown Error occurred');
        }
      });

      //Navigator.of(context).pop();

      setState(() => _isLoadingVisible = false);
    } else {
      setState(() {
        _autoValidate = true;
        _isLoadingVisible = false;
      });
    }
  }
}
