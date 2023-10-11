import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TitleTextWidget(label: "SearchScreen"),
      ),
    );
  }
}
