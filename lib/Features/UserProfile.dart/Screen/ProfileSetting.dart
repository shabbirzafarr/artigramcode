import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Features/Authentication/Controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class ProfileSettings extends ConsumerStatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends ConsumerState<ProfileSettings> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final isLoad=ref.watch(authControllerProvider);
    return (isLoad)?Loader():Container(
      height: 500,
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.nightlight_round),
            title: Text('Dark Mode'),
            trailing: Switch(
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified),
            title: Text('Blue Tick'),
            onTap: () {
              // Handle Blue Tick setting
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Your Account'),
            onTap: () {
              // Handle Delete Your Account setting
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              ref.read(authControllerProvider.notifier).logout();
              // Handle Logout setting
            },
          ),
        ],
      ),
    );
  }
}
