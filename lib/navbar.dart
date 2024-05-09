import 'package:flutter/material.dart';
import 'package:uts_mobile/help.dart';
import 'package:uts_mobile/login.dart';
import 'package:uts_mobile/style.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  bool isExpense = false; // Added this line to initialize isExpense

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.darkblue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          Theme(
            data: ThemeData(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.category_rounded),
              title: const Text('Category'),
              childrenPadding: EdgeInsets.only(left: 30),
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text('Me Time'),
                    ],
                  ),
                  onLongPress: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.work),
                      SizedBox(width: 10),
                      Text('Work'),
                    ],
                  ),
                  onLongPress: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.school),
                      SizedBox(width: 10),
                      Text('Study'),
                    ],
                  ),
                  onLongPress: () {},
                ),
              ],
            ),
          ),
          Theme(
            data: ThemeData(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              childrenPadding: EdgeInsets.only(left: 30),
              children: [
                ListTile(
                title: Row(
                  children: [
                    Text('Choose : '),
                    Text(
                      isExpense ? 'DARK' : 'LIGHT',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 10),
                    Switch(
                      value: isExpense,
                      onChanged: (bool value) {
                        setState(() {
                          isExpense = value;
                        });
                      },
                    ),
                  ],
                ),
                  onLongPress: () {},
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_rounded),
            title: const Text('Help'),
            onTap: () {
               Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => HelpScreen()));
            },
          ),
          Theme(
            data: ThemeData(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              childrenPadding: EdgeInsets.only(left: 30),
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.language),
                      SizedBox(width: 10),
                      Text('Language'),
                    ],
                  ),
                  onLongPress: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.sync),
                      SizedBox(width: 10),
                      Text('synchronization'),
                    ],
                  ),
                  onLongPress: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.policy),
                      SizedBox(width: 10),
                      Text('Privacy policy'),
                    ],
                  ),
                  onLongPress: () {},
                ),
                ListTile(
                  title: Row(
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
                    title: Text('Confirm Log Out'),
                    content: Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },
                        child: Text('Log Out'),
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
