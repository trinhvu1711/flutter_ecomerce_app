import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/product_model.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/providers/reivew_provider.dart';
import 'package:flutter_ecomerce_app/screens/inner_screen/reivew_item_widget.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class ReviewInputWidget extends StatefulWidget {
  final ProductModel productModel;
  const ReviewInputWidget({
    required this.productModel,
  });

  @override
  State<ReviewInputWidget> createState() => _ReviewInputWidgetState();
}

class _ReviewInputWidgetState extends State<ReviewInputWidget> {
  int _rating = 0;
  String _review = '';
  final _controller = TextEditingController();
  User? _user;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateReview);
    _initUser();
  }

  Future<void> _initUser() async {
    final apiService = ApiService();
    final authService = AuthService();
    final token = await authService.getToken();
    if (token != null) {
      _user = await apiService.getUserInfo(token);
      setState(() {});
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void _updateReview() {
    setState(() {
      _review = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final productModel = widget.productModel;

    return _user != null
        ? Column(
            children: [
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Reviews',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) {
                            return Icon(
                              index <
                                      reviewProvider
                                          .averageRating(
                                              productId: productModel.productId)
                                          .floor()
                                  ? Icons.star
                                  : (index <
                                          reviewProvider.averageRating(
                                              productId:
                                                  productModel.productId))
                                      ? Icons.star_half
                                      : Icons.star_border,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        '${reviewProvider.averageRating(productId: productModel.productId)}/5',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                          '(${reviewProvider.totalReviews(productId: productModel.productId)} reviews)'),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_user!.userImage),
                    ),
                    title: Text(_user!.userName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border,
                              ),
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  labelText: 'Write your review...',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(12),
                              ),
                              onPressed: () {
                                // reviewProvider.addReview(
                                //     username: _user!.userName,
                                //     userimg: _user!.userImage,
                                //     productid: productModel.productId,
                                //     rating: _rating,
                                //     reviews: _review);
                                reviewProvider.addToReviewDB(
                                    username: _user!.userName,
                                    userimg: _user!.userImage,
                                    productid: productModel.productId,
                                    rating: _rating,
                                    reviews: _review,
                                    context: context);
                                _controller.clear();
                                _rating = 0;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Successful product reviews'),
                                    backgroundColor: Colors.blue[800],
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text('Post'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              reviewProvider.getListProductReviews(
                          productId: productModel.productId) ==
                      null
                  ? const Text(
                      'This product has no reviews yet. Be the first to review the product',
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(
                      height: 200, // Đặt chiều cao phù hợp với yêu cầu của bạn
                      child: ListView.builder(
                        itemCount: reviewProvider
                            .getListProductReviews(
                              productId: productModel.productId,
                            )!
                            .length,
                        itemBuilder: (context, index) {
                          final reviewModel =
                              reviewProvider.getListProductReviews(
                            productId: productModel.productId,
                          )![index];

                          return ChangeNotifierProvider.value(
                            key: UniqueKey(),
                            value: reviewModel,
                            child: ReviewItemsWidget(),
                          );
                        },
                      ),
                    ),
              const Divider(),
            ],
          )
        : Column(
            children: [
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Reviews',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) {
                            return Icon(
                              index <
                                      reviewProvider
                                          .averageRating(
                                              productId: productModel.productId)
                                          .floor()
                                  ? Icons.star
                                  : (index <
                                          reviewProvider.averageRating(
                                              productId:
                                                  productModel.productId))
                                      ? Icons.star_half
                                      : Icons.star_border,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        '${reviewProvider.averageRating(productId: productModel.productId)}/5',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                          '(${reviewProvider.totalReviews(productId: productModel.productId)} reviews)'),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const Text('Please login to review the product'),
              const Divider(),
              reviewProvider.getListProductReviews(
                          productId: productModel.productId) ==
                      null
                  ? const Text(
                      'This product has no reviews yet. Be the first to review the product',
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(
                      height: 200, // Đặt chiều cao phù hợp với yêu cầu của bạn
                      child: ListView.builder(
                        itemCount: reviewProvider
                            .getListProductReviews(
                                productId: productModel.productId)!
                            .length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider(
                            create: (context) =>
                                reviewProvider.getListProductReviews(
                                    productId: productModel.productId)![index],
                            child: const ReviewItemsWidget(),
                          );
                        },
                      ),
                    ),
              const Divider(),
            ],
          );
  }
}
