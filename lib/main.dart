import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecomerce_app/const/theme.data.dart';
import 'package:flutter_ecomerce_app/providers/theme_provider.dart';
import 'package:flutter_ecomerce_app/root_screen.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/product_detail.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'ShopSmart',
      theme: Styles.themeData(
          isDarkTheme: themeProvider.getIsDarkTheme, context: context),
      home: const RootScreen(),
      routes: {
        ProductDetailScreen.routName: (context) => ProductDetailScreen(),
      },
    );
  }
}
