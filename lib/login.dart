import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uts_mobile/home.dart';
import 'package:uts_mobile/sign_up.dart';
import 'package:uts_mobile/style.dart';
import 'package:uts_mobile/widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('aset_media/gambar/login_ui.png'),
              const SizedBox(height: 20.0),
              Text(
                'Sign In',
                style: TextStyles.title.copyWith(fontSize: 20.0),
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hint: 'Email atau Username',
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                hint: 'Password',
                isObsure: isObscure,
                hasSuffix: true,
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                'Forgot Password?',
                style: TextStyles.body,
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Sign In',
                    style: TextStyles.title
                        .copyWith(fontSize: 20.0, color: Colors.white),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SignUpScreen()));
                },
                child: Text(
                  'Sign Up',
                  style: TextStyles.body
                      .copyWith(fontSize: 18.0, color: AppColors.darkblue),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
