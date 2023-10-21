import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class HeartBtn extends StatefulWidget {
  const HeartBtn({
    Key? key,
    this.bkgColor = Colors.transparent,
    this.size = 20,
  }) : super(key: key);
  final Color bkgColor;
  final double size;

  @override
  State<HeartBtn> createState() => _HeartBtnState();
}

class _HeartBtnState extends State<HeartBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bkgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () {},
        icon: Icon(
          IconlyLight.heart,
          size: widget.size,
        ),
      ),
    );
  }
}
