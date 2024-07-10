import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uts_mobile/auth/sign_up.dart';
import 'package:uts_mobile/controller/schedule_controller.dart';
import 'package:uts_mobile/controller/theme_controller.dart';
import 'package:uts_mobile/home.dart';
import 'package:uts_mobile/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uts_mobile/services/notification/config_notify_helper.dart';
import 'package:uts_mobile/services/notification/notify_helper.dart';
import 'package:uts_mobile/wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationHelper.configureLocalTimeZone();

  await NotificationHelper().initialize(
    null,
    channels,
    channelGroups: groups,
    debug: true,
  );

  await NotificationHelper.checkNotificationPermission(channelGlobalKey);
  await NotificationHelper.checkNotificationPermission(channelScheduleKey);

  await AwesomeNotifications().setListeners(
    onNotificationDisplayedMethod:
        NotificationHelper.onNotificationDisplayedMethod,
    onActionReceivedMethod: NotificationHelper.onActionReceivedMethod,
    onDismissActionReceivedMethod:
        NotificationHelper.onDismissActionReceivedMethod,
    onNotificationCreatedMethod: NotificationHelper.onNotificationCreatedMethod,
  );

  Get.put(ThemeController());
  Get.put(ScheduleController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        // menggunakan getPages untuk routing
        getPages: [
          GetPage(name: "/home", page: () => const HomeScreen()),
          GetPage(name: "/login", page: () => const LoginScreen()),
          GetPage(name: "/sign_up", page: () => const SignUpScreen()),
        ],
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Page not found'),
              ),
            ),
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Time Management App',
        darkTheme: theme.darkMode,
        themeMode: theme.themeMode.value,
        theme: theme.lightMode,
        // Memanggil Wrapper untuk mengecek user login
        home: const Wrapper(),
      );
    });
  }
}
