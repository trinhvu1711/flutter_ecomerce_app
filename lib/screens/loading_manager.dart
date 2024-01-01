import 'package:flutter/material.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager({Key? key, required this.child, required this.isLoading})
      : super(key: key);
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        ]
      ],
    );
  }
}
