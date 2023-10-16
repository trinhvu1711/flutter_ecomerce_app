import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/app_constants.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        log("Todo add the navigate to the product details screen");
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              imageUrl: AppConstants.imageUrl,
              height: size.height * 0.2,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TitleTextWidget(
                    label: "Title" * 10,
                    fontSize: 18,
                    maxLines: 2,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(IconlyLight.heart),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                flex: 1,
                child: SubtitleTextWidget(
                  label: "1550.00\$",
                  color: Colors.blue,
                ),
              ),
              Flexible(
                child: Material(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.blue,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {},
                    splashColor: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.add_shopping_cart_outlined),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
