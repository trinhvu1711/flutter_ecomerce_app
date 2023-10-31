import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/models/product_model.dart';
import 'package:flutter_ecomerce_app/providers/products_provider.dart';
import 'package:flutter_ecomerce_app/services/assets_manager.dart';
import 'package:flutter_ecomerce_app/widgets/products/product_widget.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetsManager.shoppingCart,
            ),
          ),
          title: const TitleTextWidget(label: "Search Products"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      searchTextController.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ),
                onChanged: (value) {
                  // print("value of the text $value");
                },
                onSubmitted: (value) {
                  // print("value of the text is $value");
                  // print(
                  //     "value of the controller text: ${searchTextController.text}");
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: DynamicHeightGridView(
                    itemCount: productProvider.getProducts.length,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    builder: (context, index) {
                      return ProductWidget(
                        productId: productProvider.getProducts[index].productId,
                      );
                    },
                    crossAxisCount: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
