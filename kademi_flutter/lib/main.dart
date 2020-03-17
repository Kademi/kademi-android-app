import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/config/route.dart';
import 'src/model/product.dart';
import 'src/pages/product_detail.dart';
import 'src/themes/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kademi E-Commerce',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.muliTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
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
          default:
        }
        return null;
      },
    );
  }
}
