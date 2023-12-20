import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/cart_provider.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/screens/cart/cart_screen.dart';
import 'package:flutter_ecomerce_app/screens/home_screen.dart';
import 'package:flutter_ecomerce_app/screens/profile_screen.dart';
import 'package:flutter_ecomerce_app/screens/search_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  static const routeName = '/RootScreen';

  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;
  bool isLoadingProd = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screens = const [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  Future<void> fetchFCT() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      Future.wait({
        productProvider.fetchProducts(),
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: currentScreen,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 10,
          height: kBottomNavigationBarHeight,
          onDestinationSelected: (index) {
            setState(() {
              currentScreen = index;
            });
            controller.jumpToPage(currentScreen);
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(IconlyLight.home),
              label: "Home",
              selectedIcon: Icon(IconlyBold.home),
            ),
            const NavigationDestination(
              icon: Icon(IconlyLight.search),
              label: "Search",
              selectedIcon: Icon(IconlyBold.search),
            ),
            NavigationDestination(
              icon: Badge(
                label: Text(cartProvider.getCartItems.length.toString()),
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                child: const Icon(IconlyLight.bag2),
              ),
              label: "Cart",
              selectedIcon: const Icon(IconlyBold.bag2),
            ),
            const NavigationDestination(
              icon: Icon(IconlyLight.profile),
              label: "Profile",
              selectedIcon: Icon(IconlyBold.profile),
            )
          ]),
    );
  }
}
