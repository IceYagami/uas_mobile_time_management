import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uts_mobile/home.dart';
import 'package:uts_mobile/login.dart';
import 'package:uts_mobile/sign_up.dart';
import 'package:uts_mobile/style.dart';
import 'package:uts_mobile/widget/custom_textfield.dart';

class firstScreen extends StatefulWidget {
  const firstScreen({super.key});

  @override
  State<firstScreen> createState() => _firstScreenState();
}

class _firstScreenState extends State<firstScreen> {
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
              const SizedBox(
                height: 40.0,
              ),

              Image.asset('aset_media/gambar/mobile_login.png'),
              const SizedBox(height: 40.0),
              
              const SizedBox(
                height: 20.0,
              ),



              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => LoginScreen()));
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

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SignUpScreen()));
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
              
            ],
          ),
        ),
      ),
    );
  }
}
