import 'package:flutter/material.dart';
import 'package:kademi_app/src/api/kademi_auth.dart';
import 'package:kademi_app/src/util/validator.dart';
import 'package:provider/provider.dart';

import '../themes/light_color.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _logo(),
                  SizedBox(height: 48.0),
                  _emailField(),
                  SizedBox(height: 24.0),
                  _passwordField(),
                  SizedBox(height: 12.0),
                  _loginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Hero(
      tag: 'hero',
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.fitHeight,
        height: 50.0,
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: LightColor.iconColor,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      obscureText: true,
      controller: _password,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _doLogin(
            email: _email.text,
            password: _password.text,
            context: context,
          );
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColorDark,
        child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _doLogin({String email, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      KademiAuth _auth = Provider.of<KademiAuth>(context, listen: false);
      var profile = await _auth.login(email, password);
      if (profile != null) {
        await Navigator.pushNamed(context, '/mainPage');
      } else {}
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
