import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({Key? key, this.fontSize = 30, required this.nameText})
      : super(key: key);
  final double fontSize;
  final String nameText;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 12),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: TitleTextWidget(
        label: nameText,
        fontSize: fontSize,
      ),
    );
  }
}
