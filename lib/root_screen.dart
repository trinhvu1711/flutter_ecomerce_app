import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/screens/cart/cart_screen.dart';
import 'package:flutter_ecomerce_app/screens/home_screen.dart';
import 'package:flutter_ecomerce_app/screens/profile_screen.dart';
import 'package:flutter_ecomerce_app/screens/search_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 2;
  late PageController controller;
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

  @override
  Widget build(BuildContext context) {
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
          destinations: const [
            NavigationDestination(
              icon: Icon(IconlyLight.home),
              label: "Home",
              selectedIcon: Icon(IconlyBold.home),
            ),
            NavigationDestination(
              icon: Icon(IconlyLight.search),
              label: "Search",
              selectedIcon: Icon(IconlyBold.search),
            ),
            NavigationDestination(
              icon: Icon(IconlyLight.bag2),
              label: "Cart",
              selectedIcon: Icon(IconlyBold.bag2),
            ),
            NavigationDestination(
              icon: Icon(IconlyLight.profile),
              label: "Profile",
              selectedIcon: Icon(IconlyBold.profile),
            )
          ]),
    );
  }
}
