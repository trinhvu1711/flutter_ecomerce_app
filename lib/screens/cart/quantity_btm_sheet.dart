import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';

class QuantityButtonSheetWidget extends StatelessWidget {
  const QuantityButtonSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 6,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 25,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SubtitleTextWidget(label: "${index + 1}"),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
