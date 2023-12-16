import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/providers/theme_provider.dart';
import 'package:flutter_ecomerce_app/providers/user_provider.dart';
import 'package:flutter_ecomerce_app/screens/auth/login.dart';
import 'package:flutter_ecomerce_app/screens/dashboard_screen.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/view_recently.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/wishlist.dart';
import 'package:flutter_ecomerce_app/screens/loading_manager.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:flutter_ecomerce_app/widgets/app_name_text.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  AuthService authService = AuthService();
  User? userModel;
  bool _isLoading = true;
  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } catch (e) {
      await MyAppFunction.showErrorOrWarningDialog(
        context: context,
        fct: () {},
        subtitle: e.toString(),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: userModel == null ? true : false,
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: TitleTextWidget(
                    label: "Please login to have unlimited access",
                  ),
                ),
              ),
              userModel == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  width: 3),
                              image: DecorationImage(
                                image: NetworkImage(
                                  userModel!.userImage,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTextWidget(
                                label: userModel == null
                                    ? ''
                                    : userModel!.userName,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              SubtitleTextWidget(
                                label: userModel == null
                                    ? ''
                                    : userModel!.userEmail,
                              )
                            ],
                          )
                        ],
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
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                          imagePath: AssetsManager.orderSvg,
                          text: "All Order",
                          function: () {}),
                    ),
                    Visibility(
                      visible: userModel == null ? false : true,
                      child: CustomListTile(
                        imagePath: AssetsManager.wishlistSvg,
                        text: "Wishlist",
                        function: () {
                          Navigator.pushNamed(context, WishlistScreen.routName);
                        },
                      ),
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
                    CustomListTile(
                      imagePath: AssetsManager.recent,
                      text: "Dashboard",
                      function: () {
                        Navigator.pushNamed(context, DashboardScreen.routeName);
                      },
                    ),
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
                  label: Text(userModel == null ? "Login" : "Logout"),
                  onPressed: () async {
                    if (userModel == null) {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    } else {
                      await _showLogoutDialog();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _logoutUser();
                Navigator.pushReplacementNamed(
                  context,
                  LoginScreen.routeName,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logoutUser() async {
    try {
      final apiService = ApiService();
      await authService.logoutUser(apiService);
      Provider.of<UserProvider>(context, listen: false).logout();
    } catch (e) {
      await MyAppFunction.showErrorOrWarningDialog(
        context: context,
        fct: () {},
        subtitle: e.toString(),
      );
    }
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
