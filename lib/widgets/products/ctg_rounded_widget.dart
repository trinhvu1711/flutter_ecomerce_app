import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);
  final String image, name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          height: 50,
          width: 50,
        ),
        const SizedBox(
          height: 15,
        ),
        SubtitleTextWidget(
          label: name,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
