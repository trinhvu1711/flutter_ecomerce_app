import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/validator.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/root_screen.dart';
import 'package:flutter_ecomerce_app/screens/auth/image_picker_widget.dart';
import 'package:flutter_ecomerce_app/screens/auth/login.dart';
import 'package:flutter_ecomerce_app/screens/loading_manager.dart';
import 'package:flutter_ecomerce_app/services/api_service.dart';
import 'package:flutter_ecomerce_app/services/auth_service.dart';
import 'package:flutter_ecomerce_app/services/my_app_function.dart';
import 'package:flutter_ecomerce_app/widgets/app_name_text.dart';
import 'package:flutter_ecomerce_app/widgets/auth/google_btn.dart';
import 'package:flutter_ecomerce_app/widgets/subtitle_text.dart';
import 'package:flutter_ecomerce_app/widgets/title_text.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "EditProfileScreen";
  const EditProfileScreen({Key? key, this.userModel}) : super(key: key);
  final User? userModel;

  @override
  State<EditProfileScreen> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _lastNameController;

  late final FocusNode _emailFocusNode, _nameFocusNode, _lastNameFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    if (widget.userModel != null) {
      _emailController =
          TextEditingController(text: widget.userModel?.userEmail);
      _lastNameController =
          TextEditingController(text: widget.userModel?.userLastName);
      _nameController = TextEditingController(text: widget.userModel?.userName);
    } else {
      _emailController = TextEditingController();
      _lastNameController = TextEditingController();
      _nameController = TextEditingController();
    }

    _emailFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
  }

  void _disposeControllers() {
    _emailController.dispose();
    _lastNameController.dispose();
    _nameController.dispose();

    _emailFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _nameFocusNode.dispose();
  }

  Future<void> _changeUserInfoFCT() async {
    final isValid = _formKey.currentState!.validate();
    final authService = AuthService();
    final apiService = ApiService();
    FocusScope.of(context).unfocus();
    bool isLoggedIn = await authService.isLoggedInAndRefresh(apiService);
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(
        context,
        LoginScreen.routeName,
      );
    }
    final token = await authService.getToken();
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        final data = {
          'firstName': _nameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
        };
        await apiService.changeUserInfo(token!, data);
        await authService.isLoggedInAndRefresh(apiService);
        Fluttertoast.showToast(
          msg: "User info has been change",
          textColor: Colors.white,
        );

        if (!mounted) {
          return;
        }
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      } catch (e) {
        // Handle registration error
        await MyAppFunction.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: e.toString(),
        );

        Fluttertoast.showToast(
          msg: "Change user info failed. Please try again.",
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const AppNameText(nameText: "Shop smart"),
                  const SizedBox(
                    height: 16,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: TitleTextWidget(label: "Edit User Info"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "First Name",
                            prefixIcon: Icon(Icons.person),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_lastNameFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Last Name",
                            prefixIcon: Icon(Icons.person),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(IconlyLight.message),
                          ),
                          onFieldSubmitted: (value) async {
                            await _changeUserInfoFCT();
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text("Change"),
                            onPressed: () async {
                              await _changeUserInfoFCT();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
