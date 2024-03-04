import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:client/core/core.dart';
import 'package:client/features/settings/presentation/presentation.dart';
import 'package:client/features/wallet/presentation/pages/pages.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarCubit, int>(
      builder: (context, state) {
        return Hero(
          tag: 'bottom_bar',
          child: SalomonBottomBar(
            currentIndex: state,
            onTap: (index) {
              context.read<BottomBarCubit>().changeIndex(index);
              if (index == 0) {
                Navigator.of(context).pushAndRemoveUntil(
                  _createRoute(const BudgetPage()),
                  (route) => false,
                );
              } else if (index == 1) {
                Navigator.of(context).pushAndRemoveUntil(
                  _createRoute(const SettingsPage()),
                  (route) => false,
                );
              } else if (index == 3) {}
            },
            items: [
              /// Home

              SalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: const Text('home.title').tr(),
                selectedColor: context.theme.primaryColor,
              ),

              /// Settings

              SalomonBottomBarItem(
                icon: const Icon(Icons.settings),
                title: const Text('settings.title').tr(),
                selectedColor: context.theme.primaryColor,
              ),

              /// Profile

              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: const Text('account.title').tr(),
                selectedColor: context.theme.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
