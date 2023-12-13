import 'package:flutter/material.dart';
import 'package:flutter_ecomerce_app/const/validator.dart';
import 'package:flutter_ecomerce_app/models/user_model.dart';
import 'package:flutter_ecomerce_app/root_screen.dart';
import 'package:flutter_ecomerce_app/screens/auth/image_picker_widget.dart';
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

class RegisterScreen extends StatefulWidget {
  static const routeName = "RegisterScreen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  bool obscureText = true;

  late final TextEditingController _passwordController,
      _nameController,
      _emailController,
      _repeatPasswordController;

  late final FocusNode _emailFocusNode,
      _passwordFocusNode,
      _nameFocusNode,
      _repeatPasswordFocusNode;
  final _formKey = GlobalKey<FormState>();
  XFile? pickedImage;
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
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _nameController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
  }

  void _disposeControllers() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _repeatPasswordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
  }

  Future<void> _registerFct() async {
    final isValid = _formKey.currentState!.validate();
    final authService = AuthService();
    final apiService = ApiService();
    FocusScope.of(context).unfocus();
    if (pickedImage == null) {
      MyAppFunction.showErrorOrWarningDialog(
          context: context,
          fct: () {},
          subtitle: "Make sure to pick up an image");
      return;
    } else {}
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        final imgUrl = await apiService.uploadImage(pickedImage!);
        final registerData = {
          'firstname': _nameController.text.trim(),
          'lastname': '', // Assuming no last name is provided in your UI
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'role': 'USER',
          'imgUrl': imgUrl // Set the role as needed
        };
        String token = await authService.registerUser(registerData, apiService);
        await authService.saveToken(token);
        final currentUser = await apiService.getUserInfo(token);
        // Check the response status
        Fluttertoast.showToast(
          msg: "An account has been created " + token,
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
          msg: "Registration failed. Please try again.",
          textColor: Colors.white,
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
        pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFct: () async {
        pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFct: () {
        setState(() {
          pickedImage = null;
        });
      },
    );
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
                    child: TitleTextWidget(label: "Welcome back"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: size.width * 0.3,
                    width: size.width * 0.3,
                    child: ImagePickerWidget(
                      pickedImage: pickedImage,
                      function: () async {
                        await localImagePicker();
                      },
                    ),
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
                            hintText: "Full Name",
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
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(IconlyLight.message),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value);
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
                            hintText: "*********",
                            prefixIcon: const Icon(IconlyLight.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
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
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            await _registerFct();
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const SubtitleTextWidget(
                              label: "Forgot password?",
                              fontStyle: FontStyle.italic,
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
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
                            icon: const Icon(Icons.login),
                            label: const Text("Signup"),
                            onPressed: () async {
                              await _registerFct();
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
