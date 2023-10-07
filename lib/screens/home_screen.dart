import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_color.dart';
import 'package:flutter_ecomerce_app/providers/theme_provider.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      // backgroundColor: AppColor.LightScaffold,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Hello world",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Hello world")),
            SwitchListTile(
              title: Text(
                  themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode"),
              value: themeProvider.getIsDarkTheme,
              onChanged: (value) {
                themeProvider.setDarkTheme(value);
              },
            )
          ],
        ),
      ),
    );
  }
}
