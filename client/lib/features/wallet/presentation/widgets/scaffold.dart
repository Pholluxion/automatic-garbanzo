import 'package:flutter/material.dart';

import 'package:client/features/wallet/presentation/widgets/widgets.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget> persistentFooterButtons;

  const AppScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.persistentFooterButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: AppBar(title: Text(title)),
      bottomNavigationBar: const BottomBar(),
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}
