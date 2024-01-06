import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/review_model.dart';
import 'package:flutter_ecomerce_app/providers/reivew_provider.dart';
import 'package:provider/provider.dart';

class ReviewItemsWidget extends StatelessWidget {
  const ReviewItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewModel>(
      builder: (context, reviewModel, child) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(reviewModel.userImg),
          ),
          title: Text(reviewModel.user_name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < reviewModel.rating ? Icons.star : Icons.star_border,
                  ),
                ),
              ),
              Text(reviewModel.review),
            ],
          ),
        );
      },
    );
  }
}
