import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/providers/wishList_provider.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class HeartBtn extends StatefulWidget {
  const HeartBtn({
    Key? key,
    this.bkgColor = Colors.transparent,
    this.size = 20,
    required this.productId,
    this.isInWishList = false,
  }) : super(key: key);
  final Color bkgColor;
  final double size;
  final String productId;
  final bool? isInWishList;
  @override
  State<HeartBtn> createState() => _HeartBtnState();
}

class _HeartBtnState extends State<HeartBtn> {
  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: widget.bkgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () async {
          // wishListProvider.addOrRemoveOnWishList(
          //   productId: widget.productId,
          // );
          try {
            if (wishListProvider.getWishLists.containsKey(widget.productId)) {
              await wishListProvider.removeWishlistItemFromDB(
                  wishlistId: wishListProvider
                      .getWishLists[widget.productId]!.wishListId,
                  productId: widget.productId,
                  context: context);
            } else {
              await wishListProvider.addToWishlistDB(
                productId: widget.productId,
                context: context,
              );
            }
            await wishListProvider.fetchWishlist();
          } catch (e) {
            await MyAppFunction.showErrorOrWarningDialog(
              context: context,
              subtitle: e.toString(),
              fct: () {},
            );
          }
        },
        icon: Icon(
          wishListProvider.isProductInWishList(productId: widget.productId)
              ? IconlyBold.heart
              : IconlyLight.heart,
          color:
              wishListProvider.isProductInWishList(productId: widget.productId)
                  ? Colors.red
                  : Colors.green,
        ),
      ),
    );
  }
}
