import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';

import 'package:client/app.dart';
import 'package:client/bootstrap.dart';

void main() {
  bootstrap(
    () => EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'CO'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('es', 'CO'),
      assetLoader: const YamlAssetLoader(),
      child: const App(),
    ),
  );
}
