import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts_mobile/controller/theme_controller.dart';
import 'package:uts_mobile/help.dart';
import 'package:uts_mobile/services/auth_service.dart';
import 'package:uts_mobile/style.dart';

import 'controller/schedule_controller.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isExpense = false;

  final authservices = AuthService();
  final ScheduleController schedule = Get.find<ScheduleController>();
  final themeData = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          // Theme(
          //   data: themeData.currentTheme(),
          //   child: ExpansionTile(
          //     leading: const Icon(Icons.category_rounded),
          //     title: const Text('Category'),
          //     childrenPadding: const EdgeInsets.only(left: 30),
          //     children: [
          //       ListTile(
          //         onTap: () {
          //           // log("coba me time");
          //         },
          //         title: const Row(
          //           children: [
          //             Icon(Icons.person),
          //             SizedBox(width: 10),
          //             Text('Me Time'),
          //           ],
          //         ),
          //         onLongPress: () {
          //           // log("coba me time");
          //         },
          //       ),
          //       ListTile(
          //         title: const Row(
          //           children: [
          //             Icon(Icons.work),
          //             SizedBox(width: 10),
          //             Text('Work'),
          //           ],
          //         ),
          //         onLongPress: () {},
          //       ),
          //       ListTile(
          //         title: const Row(
          //           children: [
          //             Icon(Icons.school),
          //             SizedBox(width: 10),
          //             Text('Study'),
          //           ],
          //         ),
          //         onLongPress: () {},
          //       ),
          //     ],
          //   ),
          // ),
          Theme(
            data: themeData.currentTheme(),
            child: ExpansionTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              childrenPadding: const EdgeInsets.only(left: 30),
              children: [
                ListTile(
                  title: Row(
                    children: [
                      const Text('Choose : '),
                      Text(
                        themeData.isDarkMode.value ? 'DARK' : 'LIGHT',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 10),
                      Switch(
                        value: themeData.isDarkMode.value,
                        onChanged: (bool value) {
                          setState(() {
                            themeData.setThemeData(
                                value ? ThemeMode.dark : ThemeMode.light);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_rounded),
            title: const Text('Help'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const HelpScreen()));
            },
          ),
          Theme(
            data: themeData.currentTheme(),
            child: ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              childrenPadding: const EdgeInsets.only(left: 30),
              children: [
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.language),
                      SizedBox(width: 10),
                      Text('Language'),
                    ],
                  ),
                  onLongPress: () {},
                ),
                // ListTile(
                //   title: const Row(
                //     children: [
                //       Icon(Icons.sync),
                //       SizedBox(width: 10),
                //       Text('Synchronization'),
                //     ],
                //   ),
                //   onLongPress: () {},
                // ),
                // ListTile(
                //   title: const Row(
                //     children: [
                //       Icon(Icons.policy),
                //       SizedBox(width: 10),
                //       Text('Privacy policy'),
                //     ],
                //   ),
                //   onLongPress: () {},
                // ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.info),
                      SizedBox(width: 10),
                      Text('Version: 1.00.10.430'),
                    ],
                  ),
                  onLongPress: () {},
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Log Out'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await authservices.signOut();
                          Get.offNamed("/login");
                        },
                        child: const Text('Log Out'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
