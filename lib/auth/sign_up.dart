import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts_mobile/auth/login.dart';
import 'package:uts_mobile/services/auth_service.dart';
import 'package:uts_mobile/style.dart';
import 'package:uts_mobile/utils/contants.dart';
import 'package:uts_mobile/widget/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authservice = AuthService();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  bool isObscure = true;
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  _signup() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      return;
    }
    authservice.createUserWithEmailAndPassword(
        emailController.text, passwordController.text);
    Get.offNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyles.title.copyWith(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: createThemeColorSchema(
                      lightColor: AppColors.grey, darkColor: Colors.white),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              CustomTextField(
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hint: 'Email',
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                hint: 'Password',
                isObscure: isObscure,
                hasSuffix: true,
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                controller: confirmPasswordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                hint: 'Confirm Password',
                isObscure: isObscure,
                hasSuffix: true,
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                onPressed: () {
                  _signup();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyles.title
                        .copyWith(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: Row(
                  children: [
                    Text(
                      'Already have account?',
                      style: TextStyles.body.copyWith(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'Sign in',
                      style: TextStyles.body
                          .copyWith(fontSize: 16.0, color: AppColors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
