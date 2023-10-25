import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    Key? key,
    this.pickedImage,
    required this.function,
  }) : super(key: key);
  final XFile? pickedImage;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: pickedImage == null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                  )
                : Image.file(
                    File(
                      pickedImage!.path,
                    ),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.blue,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                function();
              },
              splashColor: Colors.red,
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  Icons.add_shopping_cart_outlined,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
