import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/dashboard_btn_model.dart';
import 'package:flutter_ecomerce_app/providers/theme_provider.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/widgets/dashboard_btn.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/DashboardScreen";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const TitleTextWidget(label: "Dashboard Screen"),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
          actions: [
            IconButton(
              onPressed: () {
                themeProvider.setDarkTheme(!themeProvider.getIsDarkTheme);
              },
              icon: Icon(themeProvider.getIsDarkTheme
                  ? Icons.light_mode
                  : Icons.dark_mode),
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(
              DashboardButtonModel.dashboardBtnList(context).length,
              (index) => DashboardBtn(
                    onpressed:
                        DashboardButtonModel.dashboardBtnList(context)[index]
                            .onpressed,
                    imagePath:
                        DashboardButtonModel.dashboardBtnList(context)[index]
                            .imagePath,
                    text: DashboardButtonModel.dashboardBtnList(context)[index]
                        .text,
                  )),
        ));
  }
}
