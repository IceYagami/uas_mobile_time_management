import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts_mobile/services/auth_service.dart';
import 'package:uts_mobile/style.dart';
import 'package:uts_mobile/widget/custom_textfield.dart';

import '../utils/contants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authservice = AuthService();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isEmailInValid = false;
  bool isObscure = true;
  bool isPasswordInValid = false;
  final passwordController = TextEditingController();

  final _errorEmailOrPassword = 'Email atau Password tidak valid';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _login() async {
    try {
      await authservice.loginUserWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      Get.offNamed("/home");
    } catch (e) {
      setState(() {
        isEmailInValid = true;
        isPasswordInValid = true;
      });
    }

    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('aset_media/gambar/loginui.png'),
                const SizedBox(height: 20.0),
                Obx(
                  () => Text(
                    'Sign In',
                    style: TextStyles.title.copyWith(
                      fontSize: 20.0,
                      color: createThemeColorSchema(
                          lightColor: AppColors.grey, darkColor: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                CustomTextField(
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hint: 'Email',
                  errorText: isEmailInValid ? _errorEmailOrPassword : null,
                  validator: (value) {
                    if (isEmailInValid) {
                      return _errorEmailOrPassword;
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextField(
                  controller: passwordController,
                  textInputType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  hint: 'Password',
                  isObscure: isObscure,
                  hasSuffix: true,
                  errorText: isPasswordInValid ? _errorEmailOrPassword : null,
                  validator: (value) {
                    if (isPasswordInValid) {
                      return _errorEmailOrPassword;
                    }

                    return null;
                  },
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                // Text(
                //   'Forgot Password?',
                //   style: TextStyles.body,
                // ),
                const SizedBox(
                  height: 24.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: _login,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Sign In',
                      style: TextStyles.title.copyWith(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Text(
                  'Don\'t have an account?',
                  style: TextStyles.body.copyWith(
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/sign_up');
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyles.body.copyWith(
                      fontSize: 18.0,
                      color: AppColors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
