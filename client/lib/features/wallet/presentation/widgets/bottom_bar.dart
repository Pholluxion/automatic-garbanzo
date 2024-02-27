import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:client/core/core.dart';
import 'package:client/features/wallet/presentation/utils/utils.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarCubit, int>(
      builder: (context, state) {
        return SalomonBottomBar(
          currentIndex: state,
          onTap: (index) {
            context.read<BottomBarCubit>().changeIndex(index);
          },
          items: [
            /// Home

            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              selectedColor: context.theme.primaryColor,
            ),

            /// Wallet

            SalomonBottomBarItem(
              icon: const Icon(Icons.account_balance_wallet),
              title: const Text('Wallet'),
              selectedColor: context.theme.primaryColor,
            ),

            /// Settings

            SalomonBottomBarItem(
              icon: const Icon(Icons.settings),
              title: const Text('Settings'),
              selectedColor: context.theme.primaryColor,
            ),

            /// Profile

            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Profile'),
              selectedColor: context.theme.primaryColor,
            ),
          ],
        );
      },
    );
  }
}
