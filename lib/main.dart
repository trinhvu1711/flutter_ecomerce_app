import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecomerce_app/const/theme.data.dart';
import 'package:flutter_ecomerce_app/models/paymentmethod_model.dart';
import 'package:flutter_ecomerce_app/providers/bill_provider.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/location_provider.dart';
import 'package:flutter_ecomerce_app/providers/order_provider.dart';
import 'package:flutter_ecomerce_app/providers/paymentMethod_provider.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/providers/shipping_provider.dart';
import 'package:flutter_ecomerce_app/providers/theme_provider.dart';
import 'package:flutter_ecomerce_app/providers/viewed_recently_provider.dart';
import 'package:flutter_ecomerce_app/providers/wishList_provider.dart';
import 'package:flutter_ecomerce_app/root_screen.dart';
import 'package:flutter_ecomerce_app/screens/auth/forgot_password.dart';
import 'package:flutter_ecomerce_app/screens/auth/login.dart';
import 'package:flutter_ecomerce_app/screens/auth/register.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orders_screen.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/product_detail.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/view_recently.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/wishlist.dart';
import 'package:flutter_ecomerce_app/screens/profile_screen.dart';
import 'package:flutter_ecomerce_app/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return ProductProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return CartProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return WishListProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return ViewedProdvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return LocationProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return BillProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return PaymentMethodProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return OrderProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return StatusShippingProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "ShopSmart EN",
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const RootScreen(),
            routes: {
              RootScreen.routeName: (context) => const RootScreen(),
              ProductDetailScreen.routName: (context) =>
                  const ProductDetailScreen(),
              WishlistScreen.routName: (context) => const WishlistScreen(),
              ViewedRecentlyScreen.routName: (context) =>
                  const ViewedRecentlyScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              ForgotPasswordScreen.routeName: (context) =>
                  const ForgotPasswordScreen(),
              SearchScreen.routName: (context) => const SearchScreen(),
            },
          );
        },
      ),
    );
  }
}
