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

class ChangePassword extends StatefulWidget {
  static const routeName = "ChangePassword";
  const ChangePassword({Key? key, this.userModel}) : super(key: key);
  final User? userModel;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late final TextEditingController _currentPasswordController,
      _passwordController,
      _repeatPasswordController;

  late final FocusNode _currentPasswordFocusNode,
      _passwordFocusNode,
      _repeatPasswordFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool obscureText = true;
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
    _currentPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();

    _currentPasswordFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
  }

  void _disposeControllers() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();

    _currentPasswordFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
  }

  Future<void> _changePasswordFCT() async {
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
          'currentPassword': _currentPasswordController.text.trim(),
          'newPassword': _passwordController.text.trim(),
          'confirmationPassword': _repeatPasswordController.text.trim(),
        };
        await apiService.changePassword(token!, data);
        Fluttertoast.showToast(
          msg: "User password has been change",
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
          msg: "Change password failed. Please try again.",
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
                    child: TitleTextWidget(label: "Change Password"),
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
                          controller: _currentPasswordController,
                          focusNode: _currentPasswordFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Current Password",
                            prefixIcon: const Icon(IconlyLight.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "New Pasword",
                            prefixIcon: const Icon(IconlyLight.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_repeatPasswordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _repeatPasswordController,
                          focusNode: _repeatPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Repeat password",
                            prefixIcon: const Icon(IconlyLight.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            await _changePasswordFCT();
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
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
                              await _changePasswordFCT();
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
