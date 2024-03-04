import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:client/features/wallet/presentation/presentation.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'settings.language.title'.tr(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('settings.language.en').tr(),
            onTap: () {
              context.setLocale(const Locale('en', 'US'));
            },
          ),
          ListTile(
            title: const Text('settings.language.es').tr(),
            onTap: () {
              context.setLocale(const Locale('es', 'CO'));
            },
          ),
        ],
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('common.close').tr(),
            ],
          ),
        ),
      ],
    );
  }
}
