import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts_mobile/controller/schedule_controller.dart';
import 'package:uts_mobile/home.dart';
import 'package:uts_mobile/auth/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final ScheduleController schedule = Get.find<ScheduleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            schedule.init(); //load data dari firebase
            return const HomeScreen();
          } else {
            schedule.initClose(); //hapus load data login
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
