import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/features/settings/presentation/presentation.dart';
import 'package:client/features/wallet/presentation/presentation.dart';

final List<FlexScheme> schemes = [
  FlexScheme.material,
  FlexScheme.materialHc,
  FlexScheme.blue,
  FlexScheme.indigo,
  FlexScheme.hippieBlue,
  FlexScheme.aquaBlue,
  FlexScheme.brandBlue,
  FlexScheme.deepBlue,
  FlexScheme.sakura,
  FlexScheme.mandyRed,
  FlexScheme.red,
  FlexScheme.redWine,
  FlexScheme.purpleBrown,
  FlexScheme.green,
  FlexScheme.money,
  FlexScheme.jungle,
  FlexScheme.greyLaw,
  FlexScheme.wasabi,
  FlexScheme.gold,
  FlexScheme.mango,
  FlexScheme.amber,
  FlexScheme.vesuviusBurn,
  FlexScheme.deepPurple,
  FlexScheme.ebonyClay,
  FlexScheme.barossa,
  FlexScheme.shark,
  FlexScheme.bigStone,
  FlexScheme.damask,
  FlexScheme.bahamaBlue,
  FlexScheme.mallardGreen,
  FlexScheme.espresso,
  FlexScheme.outerSpace,
  FlexScheme.blueWhale,
  FlexScheme.sanJuanBlue,
  FlexScheme.rosewood,
  FlexScheme.blumineBlue,
  FlexScheme.flutterDash,
  FlexScheme.materialBaseline,
  FlexScheme.verdunHemlock,
  FlexScheme.dellGenoa,
  FlexScheme.redM3,
  FlexScheme.pinkM3,
  FlexScheme.purpleM3,
  FlexScheme.indigoM3,
  FlexScheme.blueM3,
  FlexScheme.cyanM3,
  FlexScheme.tealM3,
  FlexScheme.greenM3,
  FlexScheme.limeM3,
  FlexScheme.yellowM3,
  FlexScheme.orangeM3,
  FlexScheme.deepOrangeM3,
];

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'settings.theme.title'.tr(),
      actions: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return IconButton(
              icon: !state.isDark
                  ? const Icon(Icons.brightness_4)
                  : const Icon(Icons.brightness_7),
              onPressed: () {
                context.read<ThemeCubit>().changeTheme(isDark: !state.isDark);
              },
            );
          },
        ),
      ],
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: schemes
            .map((scheme) => ThemeCard(
                  scheme: scheme,
                ))
            .toList(),
      ),
      persistentFooterButtons: const [],
    );
  }
}

class ThemeCard extends StatelessWidget {
  const ThemeCard({super.key, required this.scheme});

  final FlexScheme scheme;

  @override
  Widget build(BuildContext context) {
    final ThemeData light = FlexThemeData.light(scheme: scheme);
    final ThemeData dark = FlexThemeData.dark(scheme: scheme);

    /// show a card with the theme color for dark and light mode

    return GestureDetector(
      onTap: () {
        context.read<ThemeCubit>().changeTheme(scheme: scheme);
      },
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: dark.colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: dark.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: light.colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: light.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                scheme.name,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
