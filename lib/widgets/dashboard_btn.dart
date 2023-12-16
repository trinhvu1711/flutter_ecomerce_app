import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';

class DashboardBtn extends StatelessWidget {
  const DashboardBtn(
      {Key? key, this.text, this.imagePath, required this.onpressed})
      : super(key: key);
  final text, imagePath;
  final Function onpressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onpressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 65,
                  height: 65,
                ),
                const SizedBox(
                  height: 10,
                ),
                SubtitleTextWidget(
                  label: text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
