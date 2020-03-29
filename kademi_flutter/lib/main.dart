import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kademi_app/src/api/kademi_auth.dart';
import 'package:kademi_app/src/pages/checkout_page.dart';
import 'package:kademi_app/src/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'src/config/route.dart';
import 'src/model/cart/cart_data.dart';
import 'src/model/products/product.dart';
import 'src/pages/product_detail.dart';
import 'src/pages/root_page.dart';
import 'src/themes/theme.dart';

void main() => runApp(
      ChangeNotifierProvider<KademiAuth>(
        child: MyApp(),
        create: (BuildContext context) {
          return KademiAuth();
        },
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<KademiAuth>(context).getProfile();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kademi E-Commerce',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.muliTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: RootPage(),
      routes: Routes.getRoute(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/detail':
            final Product product = settings.arguments;

            return MaterialPageRoute(
              builder: (context) {
                return ProductDetailPage(
                  product: product,
                );
              },
            );
            break;
          case '/checkout':
            final CartData cartData = settings.arguments;

            return MaterialPageRoute(
              builder: (context) {
                return CheckoutPage(
                  cartData: cartData,
                );
              },
            );
            break;
          default:
        }
        return null;
      },
    );
  }
}
