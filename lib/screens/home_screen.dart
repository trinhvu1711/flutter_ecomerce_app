import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_constants.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/widgets/app_name_text.dart';
import 'package:flutter_ecomerce_app/widgets/products/ctg_rounded_widget.dart';
import 'package:flutter_ecomerce_app/widgets/products/lastest_arrival.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      // backgroundColor: AppColor.LightScaffold,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: size.height * 0.25,
                child: Swiper(
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      AppConstants.bannerImage[index],
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: AppConstants.bannerImage.length,
                  pagination: const SwiperPagination(
                      builder:
                          DotSwiperPaginationBuilder(activeColor: Colors.red)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const TitleTextWidget(label: "Lastest arrival"),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const LastestArrivalProductWidget();
                  },
                ),
              ),
              const TitleTextWidget(label: "Categories"),
              const SizedBox(
                height: 15,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List.generate(
                  AppConstants.categoriesList.length,
                  (index) {
                    return CategoryRoundedWidget(
                        image: AppConstants.categoriesList[index].image,
                        name: AppConstants.categoriesList[index].name);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
