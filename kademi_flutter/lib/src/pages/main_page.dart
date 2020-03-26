import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'shopping_cart_page.dart';
import '../themes/light_color.dart';
import '../themes/theme.dart';
import '../widgets/bottomNagivationBar/bottom_navigation_bar.dart';
import '../widgets/profile_icon.dart';
import '../widgets/title_text.dart';

enum CURRENT_PAGE { HOME_PAGE, SHOPPING_CART, PROFILE_PAGE }

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CURRENT_PAGE _currentPage = CURRENT_PAGE.HOME_PAGE;
  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RotatedBox(
            quarterTurns: 4,
            child: _icon(Icons.sort, color: Colors.black54),
          ),
          ProfileIcon(),
        ],
      ),
    );
  }

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

  Widget _title() {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: (_currentPage == CURRENT_PAGE.SHOPPING_CART
                      ? 'Shopping'
                      : (_currentPage == CURRENT_PAGE.PROFILE_PAGE
                          ? 'Your'
                          : 'Our')),
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: (_currentPage == CURRENT_PAGE.SHOPPING_CART
                      ? 'Cart'
                      : (_currentPage == CURRENT_PAGE.PROFILE_PAGE
                          ? 'Details'
                          : 'Products')),
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            _currentPage == CURRENT_PAGE.SHOPPING_CART
                ? Icon(
                    Icons.delete_outline,
                    color: LightColor.orange,
                  )
                : SizedBox()
          ],
        ));
  }

  void onBottomIconPressed(int index) {
    if (index == 0) {
      setState(() {
        _currentPage = CURRENT_PAGE.HOME_PAGE;
      });
    } else if (index == 1) {
      setState(() {
        _currentPage = CURRENT_PAGE.SHOPPING_CART;
      });
    } else if (index == 2) {
      setState(() {
        _currentPage = CURRENT_PAGE.PROFILE_PAGE;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 50,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //_appBar(),
                    _title(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInToLinear,
                        switchOutCurve: Curves.easeOutBack,
                        child: (_currentPage == CURRENT_PAGE.SHOPPING_CART
                            ? Align(
                                alignment: Alignment.topCenter,
                                child: ShopingCartPage(),
                              )
                            : (_currentPage == CURRENT_PAGE.PROFILE_PAGE
                                ? Align(
                                    alignment: Alignment.topCenter,
                                    child: ProfilePage(),
                                  )
                                : MyHomePage())),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomNavigationBar(
                onIconPresedCallback: onBottomIconPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
