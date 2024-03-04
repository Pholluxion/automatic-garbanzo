import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:client/features/settings/presentation/presentation.dart';
import 'package:client/features/wallet/presentation/presentation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'settings.title'.tr(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('settings.theme.title').tr(),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ThemePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('settings.language.title').tr(),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LanguagePage(),
                ),
              );
            },
          ),
        ],
      ),
      persistentFooterButtons: const [],
    );
  }
}
