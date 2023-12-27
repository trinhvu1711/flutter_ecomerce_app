import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecomerce_app/const/app_constants.dart';
import 'package:flutter_ecomerce_app/const/validator.dart';
import 'package:flutter_ecomerce_app/models/product_model.dart';
import 'package:flutter_ecomerce_app/screens/auth/login.dart';
import 'package:flutter_ecomerce_app/screens/loading_manager.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditUploadProductScreen extends StatefulWidget {
  static const routeName = "/EditUploadProductScreen";
  const EditUploadProductScreen({Key? key, this.productModel})
      : super(key: key);
  final ProductModel? productModel;
  @override
  _EditUploadProductScreenState createState() =>
      _EditUploadProductScreenState();
}

class _EditUploadProductScreenState extends State<EditUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;

  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quatityController;
  String? _categoryValue;

  String? categoryValue;
  bool isEditing = false;
  String? productNetworkImage;
  bool _isLoading = false;
  @override
  void initState() {
    if (widget.productModel != null) {
      isEditing = true;
      productNetworkImage = widget.productModel?.productImage;
      _categoryValue = widget.productModel?.productCategory;
    }
    _titleController =
        TextEditingController(text: widget.productModel?.productTitle);
    _priceController = TextEditingController(
        text: widget.productModel?.productPrice.toString());
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quatityController = TextEditingController(
        text: widget.productModel?.productQuantity.toString());

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quatityController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quatityController.clear();
    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }

  Future<void> _uploadProduct() async {
    final apiService = ApiService();
    final authService = AuthService();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(
        context,
        LoginScreen.routeName,
      );
    }
    final token = await authService.getToken();
    if (_pickedImage == null) {
      MyAppFunction.showErrorOrWarningDialog(
        context: context,
        fct: () {},
        subtitle: "Please pick up an image",
      );
      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        final imgUrl = await apiService.uploadImage(_pickedImage!);
        final productId = Random().nextInt(100000);
        ;
        print("produdct id $productId");
        final productData = {
          "id": productId,
          "name": _titleController.text,
          "description": _descriptionController.text,
          "category": _categoryValue,
          "price": _priceController.text.trim(),
          "quantity": _quatityController.text,
          "img": imgUrl
        };
        print('access token $token');
        await apiService.createProduct(token!, productData);
        Fluttertoast.showToast(
          msg: "Product has been added ",
          textColor: Colors.white,
        );
        if (!mounted) return;
        MyAppFunction.showErrorOrWarningDialog(
          context: context,
          subtitle: "Clear Form?",
          fct: () {
            clearForm();
          },
        );
      } catch (e) {
        await MyAppFunction.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: e.toString(),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editProduct() async {
    final apiService = ApiService();
    final authService = AuthService();
    final isValid = _formKey.currentState!.validate();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(
        context,
        LoginScreen.routeName,
      );
    }
    final token = await authService.getToken();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && productNetworkImage == null) {
      MyAppFunction.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please pick up an image",
        fct: () {},
      );
      return;
    }
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        String? imgUrl;

        if (_pickedImage != null) {
          imgUrl = await apiService.uploadImage(_pickedImage!);
        }

        final productId = widget.productModel!.productId;
        final productData = {
          "id": productId,
          "name": _titleController.text,
          "description": _descriptionController.text,
          "category": _categoryValue,
          "price": _priceController.text.trim(),
          "quantity": _quatityController.text,
          "img": imgUrl ?? productNetworkImage
        };
        print('access token $token');
        await apiService.createProduct(token!, productData);
        Fluttertoast.showToast(
          msg: "Product has been edit ",
          textColor: Colors.white,
        );
        if (!mounted) return;
        MyAppFunction.showErrorOrWarningDialog(
          context: context,
          subtitle: "Clear Form?",
          fct: () {
            clearForm();
          },
        );
      } catch (e) {
        await MyAppFunction.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: e.toString(),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await MyAppFunction.imagePickerDialog(
      context: context,
      cameraFct: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          productNetworkImage = null;
        });
      },
      galleryFct: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          productNetworkImage = null;
        });
      },
      removeFct: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingManager(
      isLoading: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      clearForm();
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      "clear",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (isEditing) {
                        _editProduct();
                      } else {
                        _uploadProduct();
                      }
                    },
                    icon: const Icon(Icons.upload),
                    label: Text(
                      isEditing ? "Edit Product" : "Upload product",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: TitleTextWidget(
              label: isEditing ? "Edit product" : "Upload a new product",
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                // image picker
                if (isEditing && productNetworkImage != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      productNetworkImage!,
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  )
                ] else if (_pickedImage == null ||
                    productNetworkImage != null) ...[
                  SizedBox(
                    height: size.width * 0.4 + 10,
                    width: size.width * 0.4 + 10,
                    child: DottedBorder(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              size: 80,
                              color: Colors.blue,
                            ),
                            TextButton(
                              onPressed: () {
                                localImagePicker();
                              },
                              child: Text("Pick product image"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_pickedImage!.path),
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  )
                ],
                if (_pickedImage != null || productNetworkImage != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          localImagePicker();
                        },
                        child: const Text("Pick another image"),
                      ),
                      TextButton(
                        onPressed: () {
                          removePickedImage();
                        },
                        child: const Text(
                          "Remove image",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
                const SizedBox(
                  height: 25,
                ),
                // category dropdown
                DropdownButton(
                  items: AppConstants.categoriesDropDownList,
                  value: _categoryValue,
                  hint: Text("Choose a Category"),
                  onChanged: (value) {
                    setState(() {
                      _categoryValue = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          key: const ValueKey('Title'),
                          maxLength: 80,
                          maxLines: 2,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: 'Product title',
                          ),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                                value: value,
                                toBeReturnedString:
                                    "Please enter a valid title");
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: _priceController,
                                key: const ValueKey('Price \$'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Price',
                                  prefix: SubtitleTextWidget(
                                    label: "\$ ",
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                                validator: (value) {
                                  return MyValidators.uploadProdTexts(
                                      value: value,
                                      toBeReturnedString: "Price is missing");
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: _quatityController,
                                key: const ValueKey('Quatity'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Qty',
                                ),
                                validator: (value) {
                                  return MyValidators.uploadProdTexts(
                                      value: value,
                                      toBeReturnedString:
                                          "Quantity is missing");
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          key: const ValueKey('Description'),
                          maxLength: 1000,
                          maxLines: 8,
                          minLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Product description',
                          ),
                          validator: (value) {
                            return MyValidators.uploadProdTexts(
                                value: value,
                                toBeReturnedString: "Description is missing");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
