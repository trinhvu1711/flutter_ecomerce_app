import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/theme_provider.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/orders/orders_screen.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/view_recently.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/wishlist.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:flutter_ecomerce_app/widgets/app_name_text.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
        title: const AppNameText(
          nameText: "Shop Smart",
          fontSize: 20,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Visibility(
              visible: false,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: TitleTextWidget(
                  label: "Please login to have unlimited access",
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.background,
                            width: 3),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextWidget(label: "sodjijflaasdass"),
                        SizedBox(
                          height: 6,
                        ),
                        SubtitleTextWidget(label: "aldjasldjkajlasdasdasdasd")
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TitleTextWidget(label: "General"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomListTile(
                      imagePath: AssetsManager.orderSvg,
                      text: "My Orders",
                      function: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MyOrderScreen()));
                      }),
                  CustomListTile(
                    imagePath: AssetsManager.wishlistSvg,
                    text: "Wishlist",
                    function: () {
                      Navigator.pushNamed(context, WishlistScreen.routName);
                    },
                  ),
                  CustomListTile(
                    imagePath: AssetsManager.recent,
                    text: "View recently",
                    function: () {
                      Navigator.pushNamed(
                          context, ViewedRecentlyScreen.routName);
                    },
                  ),
                  CustomListTile(
                      imagePath: AssetsManager.address,
                      text: "Adress",
                      function: () {}),
                  const SizedBox(
                    height: 6,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const TitleTextWidget(label: "Settings"),
                  const SizedBox(
                    height: 10,
                  ),
                  SwitchListTile(
                    secondary: Image.asset(
                      AssetsManager.theme,
                      height: 34,
                    ),
                    title: Text(themeProvider.getIsDarkTheme
                        ? "Dark Mode"
                        : "Light Mode"),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(value);
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ),
                  ),
                ),
                icon: const Icon(Icons.login),
                label: const Text("Login"),
                onPressed: () async {
                  await MyAppFunction.showErrorOrWarningDialog(
                    context: context,
                    fct: () {},
                    subtitle: "Are you want to signout",
                    isError: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {Key? key,
      required this.imagePath,
      required this.text,
      required this.function})
      : super(key: key);
  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
