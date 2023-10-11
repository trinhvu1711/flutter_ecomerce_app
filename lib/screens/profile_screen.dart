import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TitleTextWidget(label: "ProfileScreen"),
      ),
    );
  }
}
