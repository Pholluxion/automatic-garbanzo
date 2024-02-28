import 'package:flutter/material.dart';

import 'package:client/features/settings/presentation/presentation.dart';
import 'package:client/features/wallet/presentation/presentation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Theme'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ThemePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Language'),
            onTap: () {},
          ),
        ],
      ),
      persistentFooterButtons: const [],
    );
  }
}
